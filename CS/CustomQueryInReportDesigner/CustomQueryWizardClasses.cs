using System.Collections.Generic;
using DevExpress.XtraReports.Web;
using DevExpress.DataAccess.Sql;

namespace CustomQueryInReportDesigner {
    public class QueryInfo {
        public string Name { get; set; }
        public string Sql { get; set; }

        public CustomSqlQuery CreateCustomSqlQuery() {
            return new CustomSqlQuery() {
                Name = this.Name,
                Sql = this.Sql
            };
        }
    }

    public class DataSourceInfo {
        public string Name { get; set; }
        public string ConnectionName { get; set; }
        public List<QueryInfo> Queries { get; set; }

        public SqlDataSource CreateSqlDataSource() {
            SqlDataSource dataSource = new SqlDataSource() {
                Name = this.Name,
                ConnectionName = this.ConnectionName
            };

            if (Queries != null) {
                foreach (QueryInfo query in Queries) {
                    dataSource.Queries.Add(query.CreateCustomSqlQuery());
                }
            }

            dataSource.RebuildResultSchema();
            return dataSource;
        }
    }

    public class CustomQueryWizardModel {
        public List<DataSourceInfo> DataSources { get; set; }

        public void CreateDataSources(ASPxReportDesigner reportDesigner) {
            reportDesigner.DataSources.Clear();
            if (DataSources != null) {
                foreach(DataSourceInfo dataSource in DataSources) {
                    reportDesigner.DataSources.Add(dataSource.Name, dataSource.CreateSqlDataSource());
                }
            }
        }
    }
}