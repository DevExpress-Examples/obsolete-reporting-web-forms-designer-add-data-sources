function popupQueryEditor_Shown(s, e) {
    if (!newQuery) {
        var selectedQuery = GetSelectedQuery(model, listBoxDataSource, listBoxQuery);
        txQueryName.SetValue(selectedQuery.Name);
        mmQuerySql.SetValue(selectedQuery.Sql);
    }
}

function popupQueryEditor_Closing(s, e) {
    ASPxClientEdit.ClearEditorsInContainer(null, "Query");
    lbQueryError.SetValue(null);
}

function btQuerySave_Click(s, e) {
    if (ASPxClientEdit.ValidateGroup("Query")) {
        query = CreateQuery(txQueryName.GetValue(), mmQuerySql.GetValue());
        var selectedDataSource = GetSelectedDataSource(model, listBoxDataSource);
        callbackValidation.PerformCallback("Query|" + JSON.stringify(query) + "|" + JSON.stringify(selectedDataSource));
    }
}

function btQueryCancel_Click(s, e) {
    popupQueryEditor.Hide();
}