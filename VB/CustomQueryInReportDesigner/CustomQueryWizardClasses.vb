Imports System.Collections.Generic
Imports DevExpress.XtraReports.Web
Imports DevExpress.DataAccess.Sql

Namespace CustomQueryInReportDesigner
	Public Class QueryInfo
		Public Property Name() As String
		Public Property Sql() As String

		Public Function CreateCustomSqlQuery() As CustomSqlQuery
			Return New CustomSqlQuery() With {.Name = Me.Name, .Sql = Me.Sql}
		End Function
	End Class

	Public Class DataSourceInfo
		Public Property Name() As String
		Public Property ConnectionName() As String
		Public Property Queries() As List(Of QueryInfo)

		Public Function CreateSqlDataSource() As SqlDataSource
			Dim dataSource As New SqlDataSource() With {.Name = Me.Name, .ConnectionName = Me.ConnectionName}

			If Queries IsNot Nothing Then
				For Each query As QueryInfo In Queries
					dataSource.Queries.Add(query.CreateCustomSqlQuery())
				Next query
			End If

			dataSource.RebuildResultSchema()
			Return dataSource
		End Function
	End Class

	Public Class CustomQueryWizardModel
		Public Property DataSources() As List(Of DataSourceInfo)

		Public Sub CreateDataSources(ByVal reportDesigner As ASPxReportDesigner)
			reportDesigner.DataSources.Clear()
			If DataSources IsNot Nothing Then
				For Each dataSource As DataSourceInfo In DataSources
					reportDesigner.DataSources.Add(dataSource.Name, dataSource.CreateSqlDataSource())
				Next dataSource
			End If
		End Sub
	End Class
End Namespace