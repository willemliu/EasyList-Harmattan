var db;
var resultSet;
var resultAsText;

function loadDB()
{
    db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(id INTEGER PRIMARY_KEY, listName STRING, itemText STRING, selected BOOLEAN)');
        //tx.executeSql('DELETE FROM EasyListData');
        resultSet = tx.executeSql('SELECT * FROM EasyListData ORDER BY id DESC');
    });

    populateModel();
    return listModel;
}

function populateDB()
{
    var listName = "test";
    var itemText = "test" + resultSet.rows.length;
    var itemSelected = false;
    var index = resultSet.rows.length+1;
    insertRecord(index, mainPage.listName, itemText, itemSelected);
}

function populateModel()
{
    listModel.clear();
    for(var i = 0; i < resultSet.rows.length; i++)
    {
        var index = resultSet.rows.item(i).id;
        var listName = resultSet.rows.item(i).listName;
        var itemText = resultSet.rows.item(i).itemText;
        var itemSelected = resultSet.rows.item(i).selected;
        listModel.append({id:index, itemText: itemText, itemSelected: itemSelected });
        mainPage.listName = listName;
    }
}

function insertRecord(index, listName, itemText, itemSelected)
{
    listModel.append({id:index, itemText: itemText, itemSelected: itemSelected });
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO EasyListData (id, listName, itemText, selected) VALUES (?, ?, ?, ?)', [index, listName, itemText, itemSelected]);
        resultSet = tx.executeSql('SELECT * FROM EasyListData ORDER BY id DESC');
    });
}

function removeRecord(id)
{
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM EasyListData WHERE id=(?)', [id]);
        resultSet = tx.executeSql('SELECT * FROM EasyListData ORDER BY id DESC');
    });
    populateModel();
}

function removeTable()
{
    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE EasyListData');
    });
}
