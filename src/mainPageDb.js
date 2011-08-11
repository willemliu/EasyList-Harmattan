var db;
var resultSet;
var listName;
var selectSql = "SELECT * FROM EasyListData WHERE listName=(?) ORDER BY selected ASC, itemText ASC, pid ASC";

/**
 * The entry point. This function needs to be called prior to the other functions
 * in this JavaScript file. This function starts the database connection. The table
 * EasyListData is also created if it does not exist yet.
 * Then the populateModel() function is called.
 *
 * Returns listModel.
 */
function loadDB(theListName)
{
    listName = theListName;
    db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
        console.log("load list: " + listName);
        resultSet = tx.executeSql(selectSql, [listName]);
    });

    populateModel();
    return listModel;
}

/**
 * A debug function to test the inserting of new items.
 */
function populateDB()
{
    var itemText = "test";
    var itemSelected = false;
    insertRecord(itemText, itemSelected);
}

/**
 * Populate the model.
 */
function populateModel()
{
    listModel.clear();
    for(var i = 0; i < resultSet.rows.length; i++)
    {
        var index = resultSet.rows.item(i).pid;
        var itemText = resultSet.rows.item(i).itemText;
        var itemSelected = resultSet.rows.item(i).selected;
        listModel.append({ itemIndex: index, itemText: itemText, itemSelected: itemSelected });
    }
}

/**
 * Insert a record.
 */
function insertRecord(itemText, itemSelected)
{
    console.log("insert row: " + listName);
    var index = 0;
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO EasyListData (listName, itemText, selected) VALUES (?, ?, ?)', [listName, itemText, itemSelected]);
        resultSet = tx.executeSql(selectSql, [listName]);
        var rs = tx.executeSql('SELECT MAX(pid) as maxId FROM EasyListData');
        for(var i = 0; i < rs.rows.length; i++)
        {
            index = rs.rows.item(i).maxId;
        }
    });
    listModel.append({ itemIndex: index, itemText: itemText, itemSelected: itemSelected });
}


/**
 * Remove the record indicated by id.
 */
function removeRecord(index)
{
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM EasyListData WHERE pid=(?)', [index]);
        console.log("load list: " + listName);
        resultSet = tx.executeSql(selectSql, [listName]);
    });
}

/**
 * Drop table.
 */
function removeTable()
{
    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE EasyListData');
    });
}

function saveRecord(pid, itemSelected)
{
    db.transaction(function(tx) {
        tx.executeSql('UPDATE EasyListData SET selected=(?) WHERE pid=(?)', [itemSelected, pid]);
                       console.log('UPDATE EasyListData SET selected=' + itemSelected + ' WHERE pid=' + pid);
        resultSet = tx.executeSql(selectSql, [listName]);
    });
}

function deselectAll()
{
    db.transaction(function(tx) {
        tx.executeSql('UPDATE EasyListData SET selected=(?)', [false]);
        resultSet = tx.executeSql(selectSql, [listName]);
    });
}
