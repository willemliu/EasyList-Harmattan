var db;

/**
 * Remove the records indicated by listName.
 */
function removeList(listName)
{
    db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
    db.transaction(function(tx) {
        console.log("remove list name: " + listName);
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
        tx.executeSql('DELETE FROM EasyListData WHERE listName=(?)', [listName]);
    });
}

function getListsModel()
{
    listModel.clear();
    db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
        var rs = tx.executeSql("SELECT listName FROM EasyListData GROUP BY listName ORDER BY listName");
        for(var i = 0; i < rs.rows.length; i++)
        {
            listModel.append({listName: rs.rows.item(i).listName});
        }
    });
    return listModel;
}

function saveAs(listName, newListName)
{
    if(listName != newListName)
    {
        console.log("Save " + listName + " as " + newListName);
        db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
            var rs = tx.executeSql("SELECT listName, itemText, selected FROM EasyListData WHERE listName=(?)ORDER BY pid", [listName]);
            for(var i = 0; i < rs.rows.length; i++)
            {
                var item = rs.rows.item(i);
                insertRecord(newListName, item.itemText, item.selected);
            }
        });
    }
    else
    {
        console.log(listName + " is the same as " + newListName + " no save needed.");
    }
}

/**
 * Insert a record.
 */
function insertRecord(listName, itemText, itemSelected)
{
    db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO EasyListData (listName, itemText, selected) VALUES (?, ?, ?)', [listName, itemText, itemSelected]);
    });
}
