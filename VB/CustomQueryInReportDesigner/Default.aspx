<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="CustomQueryInReportDesigner.Default" %>

<%@ Register Assembly="DevExpress.Web.v19.2, Version=19.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
	Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraReports.v19.2.Web.WebForms, Version=19.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
	Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraReports.v19.2.Web.WebForms, Version=19.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
	Namespace="DevExpress.XtraReports.Web.ClientControls" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
	<style type="text/css">
		.DataSourceWizardImage
		{
			background-image: url('Images/Database_32x32.png');
		}
	</style>
	<script type="text/javascript" src="Scripts/HelperMethods.js"></script>
	<script type="text/javascript">
		var model;
		var dataSource;
		var query;
		var newDataSource = false;
		var newQuery = false;
		var upadateDataSourcesAfterCallback = false;
		var wizardError = false;

		function callbackPanel_CallbackError(s, e) {
			lbWizardError.SetText("An exception occured while creating the DataSources: " + e.message);
			e.handled = true;
			wizardError = true;
		}

		function callbackPanel_EndCallback(s, e) {
			if (!wizardError) {
				popupWizard.Hide();
			}
			wizardError = false;
		}

		function RunReportDataDourceEditor_Click() {
			popupWizard.Show();
		}

		function reportDesigner_EndCallback(s, e) {
			if (upadateDataSourcesAfterCallback) {
				upadateDataSourcesAfterCallback = false;
				callbackPanel.PerformCallback(JSON.stringify(model));
			}
		}

		function callbackValidation_CallbackComplete(s, e) {
			var parameters = e.parameter.split("|");
			switch (parameters[0]) {
				case "DataSource":
					if (e.result === "") {
						popupDataSourceEditor.Hide();

						if (newDataSource) {
							AddDataSource(model, dataSource);
						}
						else {
							var selectedDataSource = GetSelectedDataSource(model, listBoxDataSource);
							selectedDataSource.Name = dataSource.Name;
							selectedDataSource.ConnectionName = dataSource.ConnectionName;
						}
						PopulateDataSourceListBox(model, listBoxDataSource);
						PopulateQueryListBox(model, listBoxDataSource, listBoxQuery);
					}
					else {
						lbDataSourceError.SetText(e.result);
					}
					break;

				case "Query":
					if (e.result === "") {
						popupQueryEditor.Hide();
						var selectedDataSource = GetSelectedDataSource(model, listBoxDataSource);
						if (newQuery) {
							AddQuery(selectedDataSource, query);
						}
						else {
							var selectedQuery = GetSelectedQuery(model, listBoxDataSource, listBoxQuery);
							selectedQuery.Name = query.Name;
							selectedQuery.Sql = query.Sql;
						}
						PopulateQueryListBox(model, listBoxDataSource, listBoxQuery);
					}
					else {
						lbQueryError.SetText(e.result);
					}
					break;
			}
		}
	</script>
	<script type="text/javascript" src="Scripts/WizardFormEventHandlers.js"></script>
	<script type="text/javascript" src="Scripts/DataSourceFormEventHandlers.js"></script>
	<script type="text/javascript" src="Scripts/QueryFormEventHandlers.js"></script>
</head>
<body>
	<form id="form1" runat="server">
	<div>
		<dx:ASPxCallbackPanel ID="callbackPanel" runat="server" ClientInstanceName="callbackPanel"
			Width="100%" OnCustomJSProperties="callbackPanel_CustomJSProperties" OnCallback="callbackPanel_Callback">
			<ClientSideEvents CallbackError="callbackPanel_CallbackError" EndCallback="callbackPanel_EndCallback" />
			<PanelCollection>
				<dx:PanelContent runat="server">
					<dx:ASPxReportDesigner ID="reportDesigner" runat="server" ClientInstanceName="reportDesigner"
						OnInit="reportDesigner_Init" OnSaveReportLayout="reportDesigner_SaveReportLayout">
						<MenuItems>
							<cc1:ClientControlsMenuItem Text="Run Report Data Source Editor" ImageClassName="DataSourceWizardImage"
								JSClickAction="RunReportDataDourceEditor_Click" />
						</MenuItems>
						<ClientSideEvents EndCallback="reportDesigner_EndCallback" />
					</dx:ASPxReportDesigner>
				</dx:PanelContent>
			</PanelCollection>
		</dx:ASPxCallbackPanel>
		<dx:ASPxCallback ID="callbackValidation" runat="server" ClientInstanceName="callbackValidation"
			OnCallback="callbackValidation_Callback">
			<ClientSideEvents CallbackComplete="callbackValidation_CallbackComplete" />
		</dx:ASPxCallback>
		<dx:ASPxPopupControl ID="popupWizard" runat="server" ClientInstanceName="popupWizard"
			CloseAction="CloseButton" CloseAnimationType="Slide" HeaderText="Report Data Source Editor"
			Modal="True" PopupAnimationType="Slide" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
			<ClientSideEvents Shown="popupWizard_Shown" Closing="popupWizard_Closing" />
			<ContentCollection>
				<dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
					<dx:ASPxFormLayout ID="frmWizard" runat="server" Width="500" ColCount="6">
						<Items>
							<dx:LayoutItem Caption="Select Data Source" ColSpan="3" Name="DataSource">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
										<dx:ASPxListBox ID="listBoxDataSource" runat="server" ClientInstanceName="listBoxDataSource"
											Width="100%" ValueType="System.String">
											<ValidationSettings ValidationGroup="Wizard" />
											<ClientSideEvents ValueChanged="listBoxDataSource_ValueChanged" />
										</dx:ASPxListBox>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
								<CaptionSettings Location="Top" />
							</dx:LayoutItem>
							<dx:LayoutItem Caption="Select Query" ColSpan="3" Name="Query">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
										<dx:ASPxListBox ID="listBoxQuery" runat="server" ClientInstanceName="listBoxQuery"
											Width="100%" ValueType="System.String">
											<ValidationSettings ValidationGroup="Wizard" />
											<ClientSideEvents ValueChanged="listBoxQuery_ValueChanged" />
										</dx:ASPxListBox>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
								<CaptionSettings Location="Top" />
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" Width="50" HorizontalAlign="Right">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
										<dx:ASPxButton ID="btDataSourceAdd" runat="server" ClientInstanceName="btDataSourceAdd"
											AutoPostBack="false" Text="Add..." Width="50">
											<ClientSideEvents Click="btDataSourceAdd_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" Width="50" HorizontalAlign="Center">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
										<dx:ASPxButton ID="btDataSourceEdit" runat="server" ClientInstanceName="btDataSourceEdit"
											AutoPostBack="false" Text="Edit..." Width="50">
											<ClientSideEvents Click="btDataSourceEdit_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" Width="50" HorizontalAlign="Left">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
										<dx:ASPxButton ID="btDataSourceDelete" runat="server" ClientInstanceName="btDataSourceDelete"
											AutoPostBack="false" Text="Delete" Width="50">
											<ClientSideEvents Click="btDataSourceDelete_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" Width="50" HorizontalAlign="Right">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer>
										<dx:ASPxButton ID="btQueryAdd" runat="server" ClientInstanceName="btQueryAdd" AutoPostBack="false"
											Text="Add..." Width="50">
											<ClientSideEvents Click="btQueryAdd_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" Width="50" HorizontalAlign="Center">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer>
										<dx:ASPxButton ID="btQueryEdit" runat="server" ClientInstanceName="btQueryEdit" AutoPostBack="false"
											Text="Edit..." Width="50">
											<ClientSideEvents Click="btQueryEdit_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" Width="50" HorizontalAlign="Left">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer>
										<dx:ASPxButton ID="btQueryDelete" runat="server" ClientInstanceName="btQueryDelete"
											AutoPostBack="false" Text="Delete" Width="50">
											<ClientSideEvents Click="btQueryDelete_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ColSpan="6" ShowCaption="False">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
										<dx:ASPxLabel ID="lbWizardError" runat="server" ClientInstanceName="lbWizardError"
											ForeColor="Red">
										</dx:ASPxLabel>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ColSpan="3" HorizontalAlign="Center" Name="Cancel" ShowCaption="False"
								Width="100px">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
										<dx:ASPxButton ID="btApply" runat="server" AutoPostBack="False" Text="Apply" Width="100px">
											<ClientSideEvents Click="btApply_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ColSpan="3" HorizontalAlign="Center" Name="Apply" ShowCaption="False"
								Width="100px">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxButton ID="btCancel" runat="server" AutoPostBack="False" Text="Cancel" Width="100px">
											<ClientSideEvents Click="btCancel_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
						</Items>
					</dx:ASPxFormLayout>
				</dx:PopupControlContentControl>
			</ContentCollection>
		</dx:ASPxPopupControl>
		<dx:ASPxPopupControl ID="popupDataSourceEditor" runat="server" ClientInstanceName="popupDataSourceEditor"
			HeaderText="Data Source Editor" CloseAction="CloseButton" CloseAnimationType="Slide"
			Modal="True" PopupAnimationType="Slide" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
			<ClientSideEvents Shown="popupDataSourceEditor_Shown" Closing="popupDataSourceEditor_Closing" />
			<ContentCollection>
				<dx:PopupControlContentControl runat="server">
					<dx:ASPxFormLayout ID="frmDataSource" runat="server" Width="500" ColCount="2">
						<Items>
							<dx:LayoutItem Caption="Name" ColSpan="2">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxTextBox ID="txDataSourceName" runat="server" ClientInstanceName="txDataSourceName"
											Width="100%">
											<ValidationSettings ValidationGroup="DataSource" Display="Dynamic">
												<RequiredField IsRequired="true" />
											</ValidationSettings>
										</dx:ASPxTextBox>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem Caption="Connection" ColSpan="2">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxComboBox ID="cbDataSourceConnection" runat="server" ClientInstanceName="cbDataSourceConnection"
											Width="100%" OnInit="cbDataSourceConnection_Init">
											<ValidationSettings ValidationGroup="DataSource" Display="Dynamic">
												<RequiredField IsRequired="true" />
											</ValidationSettings>
										</dx:ASPxComboBox>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" ColSpan="2">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxLabel ID="lbDataSourceError" runat="server" ClientInstanceName="lbDataSourceError"
											ForeColor="Red">
										</dx:ASPxLabel>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" HorizontalAlign="Center" Width="100px">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxButton ID="btDataSourceSave" runat="server" Text="Save" Width="100px" AutoPostBack="false">
											<ClientSideEvents Click="btDataSourceSave_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem HorizontalAlign="Center" ShowCaption="False" Width="100px">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxButton ID="btDataSourceCancel" runat="server" AutoPostBack="False" Text="Cancel"
											Width="100px">
											<ClientSideEvents Click="btDataSourceCancel_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
						</Items>
					</dx:ASPxFormLayout>
				</dx:PopupControlContentControl>
			</ContentCollection>
		</dx:ASPxPopupControl>
		<dx:ASPxPopupControl ID="popupQueryEditor" runat="server" ClientInstanceName="popupQueryEditor"
			HeaderText="Query Editor" CloseAction="CloseButton" CloseAnimationType="Slide"
			Modal="True" PopupAnimationType="Slide" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
			<ClientSideEvents Shown="popupQueryEditor_Shown" Closing="popupQueryEditor_Closing" />
			<ContentCollection>
				<dx:PopupControlContentControl runat="server">
					<dx:ASPxFormLayout ID="frmQuery" runat="server" Width="500" ColCount="2">
						<Items>
							<dx:LayoutItem Caption="Name" ColSpan="2">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxTextBox ID="txQueryName" runat="server" ClientInstanceName="txQueryName"
											Width="100%">
											<ValidationSettings ValidationGroup="Query" Display="Dynamic">
												<RequiredField IsRequired="true" />
											</ValidationSettings>
										</dx:ASPxTextBox>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem Caption="SQL Command Text" ColSpan="2">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxMemo ID="mmQuerySql" runat="server" ClientInstanceName="mmQuerySql" Width="100%"
											Height="100px">
											<ValidationSettings ValidationGroup="Query" Display="Dynamic">
												<RequiredField IsRequired="true" />
											</ValidationSettings>
										</dx:ASPxMemo>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" ColSpan="2">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxLabel ID="lbQueryError" runat="server" ClientInstanceName="lbQueryError"
											ForeColor="Red">
										</dx:ASPxLabel>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" HorizontalAlign="Center" Width="100px">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxButton ID="btQuerySave" runat="server" Text="Save" Width="100px" AutoPostBack="false">
											<ClientSideEvents Click="btQuerySave_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
							<dx:LayoutItem ShowCaption="False" HorizontalAlign="Center" Width="100px">
								<LayoutItemNestedControlCollection>
									<dx:LayoutItemNestedControlContainer runat="server">
										<dx:ASPxButton ID="btQueryCancel" runat="server" Text="Cancel" Width="100px" AutoPostBack="false">
											<ClientSideEvents Click="btQueryCancel_Click" />
										</dx:ASPxButton>
									</dx:LayoutItemNestedControlContainer>
								</LayoutItemNestedControlCollection>
							</dx:LayoutItem>
						</Items>
					</dx:ASPxFormLayout>
				</dx:PopupControlContentControl>
			</ContentCollection>
		</dx:ASPxPopupControl>
	</div>
	</form>
</body>
</html>