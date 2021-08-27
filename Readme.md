<!-- default badges list -->
![](https://img.shields.io/endpoint?url=https://codecentral.devexpress.com/api/v1/VersionRange/128604788/14.2.3%2B)
[![](https://img.shields.io/badge/Open_in_DevExpress_Support_Center-FF7200?style=flat-square&logo=DevExpress&logoColor=white)](https://supportcenter.devexpress.com/ticket/details/T196136)
[![](https://img.shields.io/badge/📖_How_to_use_DevExpress_Examples-e9f6fc?style=flat-square)](https://docs.devexpress.com/GeneralInformation/403183)
<!-- default badges end -->
<!-- default file list -->
*Files to look at*:

* **[CustomQueryWizardClasses.cs](./CS/CustomQueryInReportDesigner/CustomQueryWizardClasses.cs) (VB: [CustomQueryWizardClasses.vb](./VB/CustomQueryInReportDesigner/CustomQueryWizardClasses.vb))**
* [Default.aspx](./CS/CustomQueryInReportDesigner/Default.aspx) (VB: [Default.aspx](./VB/CustomQueryInReportDesigner/Default.aspx))
* [Default.aspx.cs](./CS/CustomQueryInReportDesigner/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/CustomQueryInReportDesigner/Default.aspx.vb))
* [DataSourceFormEventHandlers.js](./CS/CustomQueryInReportDesigner/Scripts/DataSourceFormEventHandlers.js) (VB: [DataSourceFormEventHandlers.js](./VB/CustomQueryInReportDesigner/Scripts/DataSourceFormEventHandlers.js))
* [HelperMethods.js](./CS/CustomQueryInReportDesigner/Scripts/HelperMethods.js) (VB: [HelperMethods.js](./VB/CustomQueryInReportDesigner/Scripts/HelperMethods.js))
* [QueryFormEventHandlers.js](./CS/CustomQueryInReportDesigner/Scripts/QueryFormEventHandlers.js) (VB: [QueryFormEventHandlers.js](./VB/CustomQueryInReportDesigner/Scripts/QueryFormEventHandlers.js))
* [WizardFormEventHandlers.js](./CS/CustomQueryInReportDesigner/Scripts/WizardFormEventHandlers.js) (VB: [WizardFormEventHandlers.js](./VB/CustomQueryInReportDesigner/Scripts/WizardFormEventHandlers.js))
<!-- default file list end -->
# Web Report Designer - How to add/edit/remove DataSourses in the web report designer (Custom DataSource wizard)


<p>This example demonstrates how you can modify the list of DataSources that is passed to the ASPxReportDesigner on the fly. <br><br></p>
<p><strong>Important Note:</strong><br>Starting with version <strong>15.1</strong>, our <a href="https://documentation.devexpress.com/XtraReports/17103/Creating-End-User-Reporting-Applications/Web-Reporting/Report-Designer">Web Report Designer</a> provides a built-in <a href="https://documentation.devexpress.com/XtraReports/114093/Creating-End-User-Reporting-Applications/Web-Reporting/Report-Designer/GUI/Wizards/SQL-Data-Source-Wizard">SQL Data Source Wizard</a>, which is available in the designer's menu. Please refer to the <a href="https://documentation.devexpress.com/XtraReports/114129/Creating-End-User-Reporting-Applications/Web-Reporting/Report-Designer/API-and-Customization/Registering-Default-Data-Connections">Registering Default Data Connections</a> help topic to learn how to enable this wizard for the Web Report Designer on your web page.</p>
<p><br><br><strong>Description:</strong><br>To run the DataSource wizard, open the ASPxReportDesigner menu and press the "Run Report DataSource Editor" item:</p>
<p><img src="https://raw.githubusercontent.com/DevExpress-Examples/web-report-designer-how-to-add-edit-remove-datasourses-in-the-web-report-designer-custom-d-t196136/14.2.3+/media/3cd019e7-9bfa-11e4-80ba-00155d624807.png"><br><br></p>
<p>After that the Custom DataSource wizard form will be displayed:</p>
<p><img src="https://raw.githubusercontent.com/DevExpress-Examples/web-report-designer-how-to-add-edit-remove-datasourses-in-the-web-report-designer-custom-d-t196136/14.2.3+/media/5d77bae3-9bfa-11e4-80ba-00155d624807.png"></p>
<p>On this form you can see the list of DataSources. After one of the data sources is selected in the list you will see the list of its Queries in the right list box. You can add, edit and remove either the DataSources or the Queries by using the buttons located under the lists. After <strong>Add...</strong> or <strong>Edit...</strong> buttons are pressed a separate modal form will be displayed to add or edit the selected Data Source or Query. Note that after the <strong>Save</strong> button is pressed on these forms, the Data Source or Query will be validated, and the error message will be displayed if the Data Source or Query cannot be created. <br><br>When the <strong>Apply</strong> button is pressed on the wizard form, all the DataSources will be posted to the server. If any exception occurs during these DataSources' creation, an error message will be displayed on the wizard form. Otherwise, the data sources will be available in the Report Designer.<br>You can add them to your report by pressing a <strong>+</strong> button in the Field List:</p>
<p><img src="https://raw.githubusercontent.com/DevExpress-Examples/web-report-designer-how-to-add-edit-remove-datasourses-in-the-web-report-designer-custom-d-t196136/14.2.3+/media/04470e0c-9bfc-11e4-80ba-00155d624807.png"></p>
<p>Or by using the built-in Report Wizard that is available in the Report Designer menu:</p>
<p><img src="https://raw.githubusercontent.com/DevExpress-Examples/web-report-designer-how-to-add-edit-remove-datasourses-in-the-web-report-designer-custom-d-t196136/14.2.3+/media/2a0ceb55-9bfc-11e4-80ba-00155d624807.png"><br><br><strong>Implementation Details:</strong></p>
<p>The main idea of this approach is to use the <a href="https://documentation.devexpress.com/#XtraReports/DevExpressXtraReportsWebASPxReportDesigner_DataSourcestopic">ASPxReportDesigner.DataSources</a> property to pass the set of DataSources to ASPxReportDesigner. To update the set of DataSources passed to the designer dynamically, I have placed the ASPxReportDesinger control into the <a href="https://documentation.devexpress.com/#AspNet/clsDevExpressWebASPxCallbackPaneltopic">ASPxCallbackPanel</a> control. So, its callbacks are used to update the entire ASPxReportDesinger. <br>The designer's DataSource list is populated on the server dynamically by using the CustomQueryWizardModel class. This class is converted to <a href="http://en.wikipedia.org/wiki/JSON">JSON</a> and passed to the client by using the CustomJSProperties event handler (see the <a href="https://documentation.devexpress.com/#AspNet/CustomDocument11816/event">How to: Access Server Data on the Client Side</a> help topic for more information). <br>After the Wizard popup form is opened, JSON data passed to the client is converted to the JavaScript object and used to populate a Wizard form. So, this object is used to edit the data source collection on the client side.<br>When the <strong>Apply</strong> button is pressed on the Wizard form, the CustomQueryWizardModel object that was edited on the client side is converted to JSON and passed back to the server as a callback parameter. In the server-side <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxCallbackPanel_Callbacktopic">ASPxCallbackPanel.Callback</a> event handler, the CustomQueryWizardModel class is restored from the parameter passed form the client and used to update <a href="https://documentation.devexpress.com/#XtraReports/DevExpressXtraReportsWebASPxReportDesigner_DataSourcestopic">ASPxReportDesigner.DataSources</a>.<br><br>Not to lose the report layout designed in ASPxReportDesigner on the ASPxCallbackPanel callback, it is saved by using the client-side <a href="https://documentation.devexpress.com/#XtraReports/DevExpressXtraReportsWebScriptsASPxClientReportDesigner_PerformCallbacktopic">ASPxClientReportDesigner.PerformCallback</a> method that triggers a callback on which the report layout is saved and raises the server-side <a href="https://documentation.devexpress.com/#XtraReports/DevExpressXtraReportsWebASPxReportDesigner_SaveReportLayouttopic">ASPxReportDesigner.SaveReportLayout</a> event handler, where the report layout is saved to the Session. Only after that the ASPxCallbackPanel callback is triggered, and the saved report layout is restored from the Session in the ASPxReportDesigner.Init event handler.<br><br>To validate the entered DataSource or Query data on the DataSource and Query editing forms (when the Save button is pressed), the <a href="https://documentation.devexpress.com/#AspNet/clsDevExpressWebASPxCallbacktopic">ASPxCallback</a> control is used. It sends a non-visual callback to the server and passes the entered DataSource or Query data to the server. Then, in the <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxCallback_Callbacktopic">ASPxCallback.Callback</a> event handler data passed from the client is used to create a <a href="https://documentation.devexpress.com/#corelibraries/clsDevExpressDataAccessSqlSqlDataSourcetopic">SqlDataSource</a> or <a href="https://documentation.devexpress.com/#corelibraries/clsDevExpressDataAccessSqlCustomSqlQuerytopic">CustomSqlQuery</a> instance and check if any errors occur while the creation. The error message is sent back to the client. The client-side <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientCallback_CallbackCompletetopic">ASPxClientCallback.CallbackComplete</a> event handler is used to analyze data that was sent back to the client and to display an error message if required.</p>

<br/>


