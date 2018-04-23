function GetSelectedDataSource(model, dataSourceListBox) {
    var index = dataSourceListBox.GetSelectedIndex();
    if (index >= 0) {
        return model.DataSources[index];
    }
    else {
        return null;
    }
}

function GetSelectedQuery(model, dataSourceListBox, queryListBox) {
    var dataSource = GetSelectedDataSource(model, dataSourceListBox);
    var index = queryListBox.GetSelectedIndex();
    if (index >= 0) {
        return dataSource.Queries[index];
    }
    else {
        return null;
    }
}

function CreateDataSource(name, connectionName) {
    return {
        Name: name,
        ConnectionName: connectionName,
        Queries: new Array()
    };
}

function CreateQuery(name, sql) {
    return {
        Name: name,
        Sql: sql
    };
}

function AddDataSource(model, dataSource) {
    model.DataSources.push(dataSource);
}

function AddQuery(dataSource, query) {
    dataSource.Queries.push(query);
}

function RemoveSelectedDataSource(model, dataSourceListBox) {
    var index = dataSourceListBox.GetSelectedIndex();
    if (index >= 0) {
        model.DataSources.splice(index, 1);
    }
}

function RemoveSelectedQuery(model, dataSourceListBox, queryListBox) {
    var dataSource = GetSelectedDataSource(model, dataSourceListBox);
    var index = queryListBox.GetSelectedIndex();
    if (index >= 0) {
        dataSource.Queries.splice(index, 1);
    }
}

function PopulateListBox1(listBox, itemsDataSource) {
    listBox.BeginUpdate();
    listBox.ClearItems();
    for (var i = 0; i < itemsDataSource.length; i++) {
        listBox.AddItem(itemsDataSource[i].Name);
    }
    listBox.EndUpdate();
}

function PopulateDataSourceListBox(model, dataSourceListBox) {
    PopulateListBox1(dataSourceListBox, model.DataSources);
}

function PopulateQueryListBox(model, dataSourceListBox, queryListBox) {
    var dataSource = GetSelectedDataSource(model, dataSourceListBox);
    if (dataSource == null) {
        queryListBox.ClearItems();
    }
    else {
        PopulateListBox1(queryListBox, dataSource.Queries);
    }
}

function UpdateListBoxButtons(listBox, addButton, editButton, deleteButton, enabledState) {
    var itemSelected = listBox.GetSelectedIndex() != -1;
    addButton.SetEnabled(enabledState);
    editButton.SetEnabled(enabledState && itemSelected);
    deleteButton.SetEnabled(enabledState && itemSelected);
}