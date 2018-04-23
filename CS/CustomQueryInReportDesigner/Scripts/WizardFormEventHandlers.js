function popupWizard_Shown(s, e) {
    model = JSON.parse(callbackPanel.cpModel);

    PopulateDataSourceListBox(model, listBoxDataSource);
    PopulateQueryListBox(model, listBoxDataSource, listBoxQuery);
    UpdateListBoxButtons(listBoxDataSource, btDataSourceAdd, btDataSourceEdit, btDataSourceDelete, true);
    UpdateListBoxButtons(listBoxQuery, btQueryAdd, btQueryEdit, btQueryDelete, false);
}

function popupWizard_Closing(s, e) {
    ASPxClientEdit.ClearEditorsInContainer(null, "Wizard");
    lbWizardError.SetValue(null);
}

function listBoxDataSource_ValueChanged(s, e) {
    var dataSourceSelected = listBoxDataSource.GetSelectedIndex() != -1;
    PopulateQueryListBox(model, listBoxDataSource, listBoxQuery);
    UpdateListBoxButtons(listBoxDataSource, btDataSourceAdd, btDataSourceEdit, btDataSourceDelete, true);
    UpdateListBoxButtons(listBoxQuery, btQueryAdd, btQueryEdit, btQueryDelete, dataSourceSelected);
}

function listBoxQuery_ValueChanged(s, e) {
    var dataSourceSelected = listBoxDataSource.GetSelectedIndex() != -1;
    UpdateListBoxButtons(listBoxQuery, btQueryAdd, btQueryEdit, btQueryDelete, dataSourceSelected);
}

function btDataSourceAdd_Click(s, e) {
    newDataSource = true;
    popupDataSourceEditor.Show();
}

function btDataSourceEdit_Click(s, e) {
    newDataSource = false;
    popupDataSourceEditor.Show();
}

function btDataSourceDelete_Click(s, e) {
    RemoveSelectedDataSource(model, listBoxDataSource);
    PopulateDataSourceListBox(model, listBoxDataSource);
    PopulateQueryListBox(model, listBoxDataSource, listBoxQuery);
}

function btQueryAdd_Click(s, e) {
    newQuery = true;
    popupQueryEditor.Show();
}

function btQueryEdit_Click(s, e) {
    newQuery = false;
    popupQueryEditor.Show();
}

function btQueryDelete_Click(s, e) {
    RemoveSelectedQuery(model, listBoxDataSource, listBoxQuery);
    PopulateQueryListBox(model, listBoxDataSource, listBoxQuery);
}

function btCancel_Click(s, e) {
    popupWizard.Hide();
}

function btApply_Click(s, e) {    
    upadateDataSourcesAfterCallback = true;
    reportDesigner.PerformCallback("CallbackCache");
}