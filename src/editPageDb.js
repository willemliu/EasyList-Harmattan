Qt.include("settingsDb.js");
var resultText = "";
var resultSet;
var listName =  "default";
var selectSql = "SELECT * FROM EasyListData WHERE listName=(?)";

/**
 * The entry point. This function needs to be called prior to the other functions
 * in this JavaScript file. This function starts the database connection. The table
 * EasyListData is also created if it does not exist yet.
 * Then the populateModel() function is called.
 *
 * Returns resultText.
 */
function loadEditDb(theListName)
{
    listName = theListName;
    var db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
        resultSet = tx.executeSql(getOrderBy(selectSql), [listName]);
    });

    populateEditModel();
    return resultText;
}

function setListName(theListName)
{
    listName = theListname;
}

/**
 * Populate the database with the given text. Each new line represents a new row.
 * A line starting with '!' is considered selected. The text is saved into the database
 * without the '!' character. Instead the selected flag is set to true.
 */
function populateEditDb(text)
{
    var db = getDbConnection();
    db.transaction(function(tx) {
        // Clear all items.
        tx.executeSql('DELETE FROM EasyListData WHERE listName=(?)', [listName]);
    });
    var lines = text.split("\n");
    var lineNum = lines.length;
    for(var i = 0; i < lineNum; ++i)
    {
        if(lines[i].length > 0)
        {
            if(lines[i].substring(0, 1) == "!")
            {
                insertEditRecord(lines[i].substring(1), true);
            }
            else
            {
                insertEditRecord(lines[i], false);
            }
        }
    }
}

/**
 * Populate the model.
 */
function populateEditModel()
{
    resultText = "";
    for(var i = 0; i < resultSet.rows.length; i++)
    {
        var itemText = resultSet.rows.item(i).itemText;
        var itemSelected = resultSet.rows.item(i).selected;
        var prefix = "";
        if(itemSelected == "true")
        {
            prefix = "!";
        }
        resultText += prefix + itemText + "\n";
    }
}

/**
 * Insert a record.
 */
function insertEditRecord(itemText, itemSelected)
{
    var index = 0;
    var db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO EasyListData (listName, itemText, selected) VALUES (?, ?, ?)', [listName, itemText, itemSelected]);
        resultSet = tx.executeSql(getOrderBy(selectSql), [listName]);
        var rs = tx.executeSql('SELECT MAX(pid) as maxId FROM EasyListData');
        for(var i = 0; i < rs.rows.length; i++)
        {
            index = rs.rows.item(i).maxId;
        }
    });
}
