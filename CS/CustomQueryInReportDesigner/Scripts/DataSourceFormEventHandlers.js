function popupDataSourceEditor_Shown(s, e) {
    if (!newDataSource) {
        var selectedDataSource = GetSelectedDataSource(model, listBoxDataSource);
        txDataSourceName.SetValue(selectedDataSource.Name);
        cbDataSourceConnection.SetValue(selectedDataSource.ConnectionName);
    }
}

function popupDataSourceEditor_Closing(s, e) {
    ASPxClientEdit.ClearEditorsInContainer(null, "DataSource");
    lbDataSourceError.SetValue(null);
}

function btDataSourceSave_Click(s, e) {
    if (ASPxClientEdit.ValidateGroup("DataSource")) {
        dataSource = CreateDataSource(txDataSourceName.GetValue(), cbDataSourceConnection.GetValue());
        callbackValidation.PerformCallback("DataSource|" + JSON.stringify(dataSource));
    }
}

function btDataSourceCancel_Click(s, e) {
    popupDataSourceEditor.Hide();
}