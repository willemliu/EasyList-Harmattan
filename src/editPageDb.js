var db;
var resultText = "";
var resultSet;
var listName =  "default";
var selectSql = "SELECT * FROM EasyListData WHERE listName=(?) ORDER BY selected ASC, itemText ASC, pid ASC";

/**
 * The entry point. This function needs to be called prior to the other functions
 * in this JavaScript file. This function starts the database connection. The table
 * EasyListData is also created if it does not exist yet.
 * Then the populateModel() function is called.
 *
 * Returns resultText.
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
    return resultText;
}

/**
 * Populate the database with the given text. Each new line represents a new row.
 * A line starting with '!' is considered selected. The text is saved into the database
 * without the '!' character. Instead the selected flag is set to true.
 */
function populateDB(text)
{
    console.log("populate list: " + listName);
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
                insertRecord(lines[i].substring(1), true);
            }
            else
            {
                insertRecord(lines[i], false);
            }
        }
    }
}

/**
 * Populate the model.
 */
function populateModel()
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
