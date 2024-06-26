
# Reporting for Web Forms - Report Data Source Editor (up to v15.1)

> **Important:**
> This example is relevant for versions **prior to 15.1**. Current versions provide a built-in [Data Source Wizard](https://docs.devexpress.com/XtraReports/400947) in the designer's menu. Review the [Register Data Connections](https://docs.devexpress.com/XtraReports/114129/) and [Register Data Sources](https://docs.devexpress.com/XtraReports/17557) topics for more information on how to add data sources to the built-in Wizard.

## Overview 

This example demonstrates how you can modify the list of DataSources that is passed to the ASPxReportDesigner on the fly.

To run the DataSource wizard, open the ASPxReportDesigner menu and click **Run Report DataSource Editor**:

![](/images/screenshot-menu.png)


The **Report Data Source Editor** is displayed:

![](/images/screenshot-data-source-editor.png)


This form displays the list of data sources. Select a data source and the list box on the right shows its queries. You can add, edit and remove data sources and queries.

Click the **Apply** button to post the data sources to the server. In case of any exception, an error message is displayed. The data sources are available in the Report Designer.

To add data sources, click the **+ (plus)** button in the **Field List**:

![](/images/screenshot-plus-add-data-source.png)

## Implementation Details

The main idea of this approach is to use the [ASPxReportDesigner.DataSources](https://docs.devexpress.com/XtraReports/DevExpress.XtraReports.Web.ASPxReportDesigner.DataSources) property to pass the set of DataSources to ASPxReportDesigner. To update the set of DataSources passed to the designer dynamically, the ASPxReportDesinger control is placed in the [ASPxCallbackPanel](https://docs.devexpress.com/AspNet/DevExpress.Web.ASPxCallbackPanel) control. The callbacks are used to update the ASPxReportDesigner. 

The designer's DataSource list is populated on the server dynamically with the CustomQueryWizardModel class. This class is converted to JSON format and passed to the client in the CustomJSProperties event handler (review the [How to Access Server Data on the Client Side](https://docs.devexpress.com/AspNet/11816) topic for more information).

When the Wizard popup form opens, JSON data passed to the client is converted to the JavaScript object and used to populate a Wizard form. This object is used to edit the data source collection on the client side.

When the user clicks the **Apply** button, the modified CustomQueryWizardModel object is converted to JSON and passed back to the server as a callback parameter. The server-side [ASPxCallbackPanel.Callback](https://docs.devexpress.com/AspNet/DevExpress.Web.ASPxCallbackPanel.Callback) event handler restores the  CustomQueryWizardModel class and updates the data source collection.

To save the report layout, the client-side [ASPxClientReportDesigner.PerformCallback](https://docs.devexpress.com/XtraReports/js-ASPxClientReportDesigner#js_aspxclientreportdesigner_performcallback_arg_) method triggers a callback and raises the server-side [ASPxReportDesigner.SaveReportLayout](https://docs.devexpress.com/XtraReports/DevExpress.XtraReports.Web.ASPxReportDesigner.SaveReportLayout) event that saves the report layout to Session. Subsequently the ASPxCallbackPanel callback is triggered, and the saved report layout is restored from the Session in the **ASPxReportDesigner.Init** event handler.

When the user clicks the **Save** button, the [ASPxCallback](https://docs.devexpress.com/AspNet/DevExpress.Web.ASPxCallback) control sends a non-visual callback to the server to validate the data source or query. The data source and query instances are created. If any errors occur, the error message is sent back to the client. The client-side [ASPxClientCallback.CallbackComplete](https://docs.devexpress.com/AspNet/js-ASPxClientCallback.CallbackComplete) event handler analyzes data that is sent back to the client and displays an error message.

## Files to Look At

* **[CustomQueryWizardClasses.cs](./CS/CustomQueryInReportDesigner/CustomQueryWizardClasses.cs) (VB: [CustomQueryWizardClasses.vb](./VB/CustomQueryInReportDesigner/CustomQueryWizardClasses.vb))**
* [Default.aspx](./CS/CustomQueryInReportDesigner/Default.aspx) (VB: [Default.aspx](./VB/CustomQueryInReportDesigner/Default.aspx))
* [Default.aspx.cs](./CS/CustomQueryInReportDesigner/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/CustomQueryInReportDesigner/Default.aspx.vb))
* [DataSourceFormEventHandlers.js](./CS/CustomQueryInReportDesigner/Scripts/DataSourceFormEventHandlers.js) (VB: [DataSourceFormEventHandlers.js](./VB/CustomQueryInReportDesigner/Scripts/DataSourceFormEventHandlers.js))
* [HelperMethods.js](./CS/CustomQueryInReportDesigner/Scripts/HelperMethods.js) (VB: [HelperMethods.js](./VB/CustomQueryInReportDesigner/Scripts/HelperMethods.js))
* [QueryFormEventHandlers.js](./CS/CustomQueryInReportDesigner/Scripts/QueryFormEventHandlers.js) (VB: [QueryFormEventHandlers.js](./VB/CustomQueryInReportDesigner/Scripts/QueryFormEventHandlers.js))
* [WizardFormEventHandlers.js](./CS/CustomQueryInReportDesigner/Scripts/WizardFormEventHandlers.js) (VB: [WizardFormEventHandlers.js](./VB/CustomQueryInReportDesigner/Scripts/WizardFormEventHandlers.js))

## Documentation

- [Data Source Wizard](http://docs.devexpress.devx/XtraReports/400947/web-reporting/gui/wizards/data-source-wizard-fullscreen)
