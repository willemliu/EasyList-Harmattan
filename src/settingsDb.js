var db;
var listName =  "default";
var resultSet;
var selectSql = "SELECT * FROM EasyListApp WHERE property=(?) ORDER BY pid ASC";
var propListName = "listName";

/**
 * The entry point. This function is called by all other functions which need this
 * database connection te be setup. This function starts the database connection. The table
 * EasyListApp is also created if it does not exist yet.
 *
 */
function loadDB()
{
    db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListApp(property STRING UNIQUE, value STRING)');
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propListName, "default"]);
    });
}

/**
 * Set the list name in the database.
 */
function setListName(theListName)
{
    loadDB();
    listName = theListName;
    db.transaction(function(tx) {
        console.log("set list name: " + listName);
        tx.executeSql("INSERT OR REPLACE INTO EasyListApp (property, value) VALUES (?,?)", [propListName, listName]);
    });
}

/**
 * Return the list name.
 */
function getListName()
{
    loadDB();
    db.transaction(function(tx) {
        resultSet = tx.executeSql("SELECT * FROM EasyListApp WHERE property=(?)", [propListName]);
    });
    for(var i = 0; i < resultSet.rows.length; i++)
    {
        listName = resultSet.rows.item(i).value;
    }
    console.log("get list name: " + listName);
    return listName;
}

/**
 * Drop table.
 */
function removeTables()
{
    db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE IF EXISTS EasyListData');
        tx.executeSql('DROP TABLE IF EXISTS EasyListApp');
    });
}
