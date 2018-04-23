Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.Script.Serialization
Imports DevExpress.Web
Imports DevExpress.XtraReports.Web
Imports DevExpress.XtraReports.UI
Imports System.IO
Imports System.Configuration
Imports DevExpress.DataAccess.Sql

Namespace CustomQueryInReportDesigner
    Partial Public Class [Default]
        Inherits System.Web.UI.Page

        Public Property WizardModel() As CustomQueryWizardModel
            Get
                If Session("WizardModel") Is Nothing Then
                    Return New CustomQueryWizardModel() With {.DataSources = New List(Of DataSourceInfo)() _
                        From { _
                            New DataSourceInfo() With { _
                                .Name = "Northwind", _
                                .ConnectionName = "NorthwindConnection", _
                                .Queries = New List(Of QueryInfo)() From { _
                                    New QueryInfo() With { _
                                        .Name = "Categories", _
                                        .Sql = "SELECT * FROM [Categories]" _
                                    }, _
                                    New QueryInfo() With { _
                                        .Name = "Products", _
                                        .Sql = "SELECT * FROM [Products]" _
                                    } _
                                } _
                            }, _
                            New DataSourceInfo() With { _
                                .Name = "Departments", _
                                .ConnectionName = "DepartmentsConnection", _
                                .Queries = New List(Of QueryInfo)() From { _
                                    New QueryInfo() With { _
                                        .Name = "Departments", _
                                        .Sql = "SELECT * FROM [Departments]" _
                                    } _
                                } _
                                _
                            } _
                        }}
                Else
                    Return TryCast(Session("WizardModel"), CustomQueryWizardModel)
                End If
            End Get
            Set(ByVal value As CustomQueryWizardModel)
                Session("WizardModel") = value
            End Set
        End Property

        Protected Sub reportDesigner_Init(ByVal sender As Object, ByVal e As EventArgs)
            Dim designer As ASPxReportDesigner = TryCast(sender, ASPxReportDesigner)
            Dim model As CustomQueryWizardModel = WizardModel
            model.CreateDataSources(designer)

            Dim report As New XtraReport()
            If Session("CallbackCache") IsNot Nothing Then
                Using ms As New MemoryStream(DirectCast(Session("CallbackCache"), Byte()))
                    report.LoadLayout(ms)
                End Using
                Session("CallbackCache") = Nothing
            End If
            designer.OpenReport(report)
        End Sub

        Protected Sub callbackPanel_CustomJSProperties(ByVal sender As Object, ByVal e As CustomJSPropertiesEventArgs)
            Dim serializer As New JavaScriptSerializer()
            e.Properties("cpModel") = serializer.Serialize(WizardModel)
        End Sub

        Protected Sub callbackPanel_Callback(ByVal sender As Object, ByVal e As CallbackEventArgsBase)
            Dim serializer As New JavaScriptSerializer()
            Dim model As CustomQueryWizardModel = serializer.Deserialize(Of CustomQueryWizardModel)(e.Parameter)
            model.CreateDataSources(reportDesigner)
            WizardModel = model
        End Sub

        Protected Sub callbackValidation_Callback(ByVal source As Object, ByVal e As CallbackEventArgs)
            Dim parameters() As String = e.Parameter.Split("|"c)
            Dim serializer As New JavaScriptSerializer()
            Dim errorMessage As String = String.Empty

            Select Case parameters(0)
                Case "DataSource"
                    Try
                        Dim dataSource As DataSourceInfo = serializer.Deserialize(Of DataSourceInfo)(parameters(1))
                        dataSource.CreateSqlDataSource()
                    Catch ex As Exception
                        errorMessage = ex.Message
                    End Try
                Case "Query"
                    Try
                        Dim query As QueryInfo = serializer.Deserialize(Of QueryInfo)(parameters(1))
                        Dim dataSource As DataSourceInfo = serializer.Deserialize(Of DataSourceInfo)(parameters(2))
                        dataSource.Queries.Clear()
                        dataSource.Queries.Add(query)
                        dataSource.CreateSqlDataSource()
                    Catch ex As Exception
                        If TypeOf ex Is DevExpress.Xpo.DB.Exceptions.SchemaCorrectionNeededException Then
                            errorMessage = ex.InnerException.Message
                        Else
                            errorMessage = ex.Message
                        End If
                    End Try
            End Select
            e.Result = errorMessage
        End Sub

        Protected Sub reportDesigner_SaveReportLayout(ByVal sender As Object, ByVal e As SaveReportLayoutEventArgs)
            If e.Parameters = "CallbackCache" Then
                Session("CallbackCache") = e.ReportLayout
                Return
            End If

            'Save report layout here
        End Sub

        Protected Sub cbDataSourceConnection_Init(ByVal sender As Object, ByVal e As EventArgs)
            Dim comboBox As ASPxComboBox = TryCast(sender, ASPxComboBox)

            For Each connectionString As ConnectionStringSettings In ConfigurationManager.ConnectionStrings
                comboBox.Items.Add(connectionString.Name)
            Next connectionString
        End Sub
    End Class
End Namespace