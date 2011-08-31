Qt.include("settingsDb.js");
var db;

/**
 * Remove the records indicated by listName.
 */
function removeList(listName)
{
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListLists(pid INTEGER PRIMARY KEY, listName STRING UNIQUE)');
        tx.executeSql('DELETE FROM EasyListData WHERE listName=(?)', [listName]);
        tx.executeSql('DELETE FROM EasyListLists WHERE listName=(?)', [listName]);
    });
}

function getFirstListName()
{
    var listName = "default";
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListLists(pid INTEGER PRIMARY KEY, listName STRING UNIQUE)');
        var lists = tx.executeSql("SELECT listName FROM EasyListLists ORDER BY UPPER(listName)");
        for(var j = 0; j < lists.rows.length; j++)
        {
            listName = lists.rows.item(j).listName;
            break;
        }
    });
    return listName;
}

function getListsModel()
{
    listModel.clear();
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListLists(pid INTEGER PRIMARY KEY, listName STRING UNIQUE)');
        var lists = tx.executeSql("SELECT listName FROM EasyListLists ORDER BY UPPER(listName)");
        if(lists.rows.length === 0)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
            var rs = tx.executeSql("SELECT listName FROM EasyListData GROUP BY listName ORDER BY UPPER(listName)");
            for(var i = 0; i < rs.rows.length; i++)
            {
                addList(rs.rows.item(i).listName);
                listModel.append({listName: rs.rows.item(i).listName});
            }
        }
        else
        {
            for(var j = 0; j < lists.rows.length; j++)
            {
                listModel.append({listName: lists.rows.item(j).listName});
            }
        }
    });
    return listModel;
}

/**
 * Clone a list.
 */
function cloneList(listName, newListName)
{
    if(listName != newListName)
    {
        console.log("Clone " + listName + " as " + newListName);
        db = getDbConnection();
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
            var rs = tx.executeSql("SELECT listName, itemText, selected FROM EasyListData WHERE listName=(?)ORDER BY pid", [listName]);
            for(var i = 0; i < rs.rows.length; i++)
            {
                var item = rs.rows.item(i);
                insertListRecord(newListName, item.itemText, item.selected);
            }
        });
    }
    else
    {
        console.log(listName + " is the same as " + newListName + " no clone needed.");
    }
}

/**
 * Insert a record.
 */
function insertListRecord(listName, itemText, itemSelected)
{
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO EasyListData (listName, itemText, selected) VALUES (?, ?, ?)', [listName, itemText, itemSelected]);
    });
}

function addList(listName)
{
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListLists(pid INTEGER PRIMARY KEY, listName STRING UNIQUE)');
        tx.executeSql("INSERT OR IGNORE INTO EasyListLists (listName) VALUES (?)", [listName]);
    });
}

function renameList(oldListName, newListName)
{
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListLists(pid INTEGER PRIMARY KEY, listName STRING UNIQUE)');
        tx.executeSql("UPDATE OR IGNORE EasyListLists SET listName=(?) WHERE listName=(?)", [newListName, oldListName]);
        tx.executeSql("UPDATE OR IGNORE EasyListData SET listName=(?) WHERE listName=(?)", [newListName, oldListName]);
    });
}

