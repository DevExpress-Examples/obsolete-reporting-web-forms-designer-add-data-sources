using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using DevExpress.Web;
using DevExpress.XtraReports.Web;
using DevExpress.XtraReports.UI;
using System.IO;
using System.Configuration;
using DevExpress.DataAccess.Sql;

namespace CustomQueryInReportDesigner {
    public partial class Default : System.Web.UI.Page {
        public CustomQueryWizardModel WizardModel {
            get {
                if (Session["WizardModel"] == null) {
                    return new CustomQueryWizardModel() {
                        DataSources = new List<DataSourceInfo>() {
                        new DataSourceInfo() {
                            Name = "Northwind",
                            ConnectionName = "NorthwindConnection",
                            Queries = new List<QueryInfo>() {
                                new QueryInfo() { Name = "Categories", Sql = "SELECT * FROM [Categories]" },
                                new QueryInfo() { Name = "Products", Sql = "SELECT * FROM [Products]" }
                            }
                        },
                        new  DataSourceInfo() {
                            Name = "Departments",
                            ConnectionName = "DepartmentsConnection",
                            Queries = new List<QueryInfo>() {
                                new QueryInfo() { Name = "Departments", Sql = "SELECT * FROM [Departments]" }
                            }
                        }
                    }
                    };
                }
                else {
                    return Session["WizardModel"] as CustomQueryWizardModel;
                }
            }
            set {
                Session["WizardModel"] = value;
            }
        }

        protected void reportDesigner_Init(object sender, EventArgs e) {
            ASPxReportDesigner designer = sender as ASPxReportDesigner;
            CustomQueryWizardModel model = WizardModel;
            model.CreateDataSources(designer);

            XtraReport report = new XtraReport();
            if (Session["CallbackCache"] != null) {
                using (MemoryStream ms = new MemoryStream((byte[])Session["CallbackCache"])) {
                    report.LoadLayout(ms);
                }
                Session["CallbackCache"] = null;
            }
            designer.OpenReport(report);
        }

        protected void callbackPanel_CustomJSProperties(object sender, CustomJSPropertiesEventArgs e) {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            e.Properties["cpModel"] = serializer.Serialize(WizardModel);
        }

        protected void callbackPanel_Callback(object sender, CallbackEventArgsBase e) {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            CustomQueryWizardModel model = serializer.Deserialize<CustomQueryWizardModel>(e.Parameter);
            model.CreateDataSources(reportDesigner);
            WizardModel = model;
        }

        protected void callbackValidation_Callback(object source, CallbackEventArgs e) {
            string[] parameters = e.Parameter.Split('|');
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string errorMessage = String.Empty;

            switch (parameters[0]) {
                case "DataSource":
                    try {
                        DataSourceInfo dataSource = serializer.Deserialize<DataSourceInfo>(parameters[1]);
                        dataSource.CreateSqlDataSource();
                    }
                    catch (Exception ex) {
                        errorMessage = ex.Message;
                    }
                    break;
                case "Query":
                    try {
                        QueryInfo query = serializer.Deserialize<QueryInfo>(parameters[1]);
                        DataSourceInfo dataSource = serializer.Deserialize<DataSourceInfo>(parameters[2]);
                        dataSource.Queries.Clear();
                        dataSource.Queries.Add(query);
                        dataSource.CreateSqlDataSource();
                    }
                    catch (Exception ex) {
                        if (ex is DevExpress.Xpo.DB.Exceptions.SchemaCorrectionNeededException) {
                            errorMessage = ex.InnerException.Message;
                        }
                        else {
                            errorMessage = ex.Message;
                        }
                    }
                    break;
            }
            e.Result = errorMessage;
        }

        protected void reportDesigner_SaveReportLayout(object sender, SaveReportLayoutEventArgs e) {
            if (e.Parameters == "CallbackCache") {
                Session["CallbackCache"] = e.ReportLayout;
                return;
            }

            //Save report layout here
        }

        protected void cbDataSourceConnection_Init(object sender, EventArgs e) {
            ASPxComboBox comboBox = sender as ASPxComboBox;

            foreach (ConnectionStringSettings connectionString in ConfigurationManager.ConnectionStrings) {
                comboBox.Items.Add(connectionString.Name);
            }
        }
    }
}