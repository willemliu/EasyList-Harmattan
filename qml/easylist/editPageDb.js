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
    db.readTransaction(function(tx) {
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
    //console.log("populate list: " + listName);
    db.transaction(function(tx) {
        // Clear all items.
        tx.executeSql('DELETE FROM EasyListData WHERE listName=(?)', [listName]);
    });
    var lines = text.split(/[\n,]+/);
    var lineNum = lines.length;
    for(var i = 0; i < lineNum; ++i)
    {
        if(lines[i].length > 0)
        {
            if(lines[i].substring(0, 1) == "!")
            {
                insertEditRecord(listName, lines[i].substring(1), true);
            }
            else
            {
                insertEditRecord(listName, lines[i], false);
            }
        }
    }
}

/**
 * Set a list into the database. Each new line represents a new row.
 * The timestamp is used to check if the list is newer.
 * A line starting with '!' is considered selected. The text is saved into the database
 * without the '!' character. Instead the selected flag is set to true.
 */
function setListDb(listName, text, timestamp)
{
    var db = getDbConnection();
    //console.log("populate list: " + listName);
    addList(listName);
    var newer = false;
    db.transaction(function(tx) {
        // Insert list with timestamp+1 if it does not exist.
        var rs = tx.executeSql('SELECT * FROM EasyListListsLastModified WHERE listName=(?)', listName);
        if(rs.rows.length == 0)
        {
            var res = tx.executeSql("INSERT OR IGNORE INTO EasyListListsLastModified (listName, lastModified) VALUES (?, ?)", [listName, (parseInt(timestamp, 10)+1)]);
            // Check if a record has been inserted or not.
            if(res.insertId == false)
            {
                // No record has been inserted so it already exists. Now we compare timestamps and see if the list
                // to be set is newer.
                var rs = tx.executeSql('SELECT * FROM EasyListListsLastModified WHERE listName=(?) AND lastModified<(?)', [listName, timestamp]);
                for(var i = 0; i < rs.rows.length; i++)
                {
                    newer = true;
                }
            }
            else
            {
                newer = true;
            }
        }
        else
        {
            var rs = tx.executeSql('SELECT * FROM EasyListListsLastModified WHERE listName=(?) AND lastModified<(?)', [listName, timestamp]);
            for(var i = 0; i < rs.rows.length; i++)
            {
                console.log(timestamp-rs.rows.item(i).lastModified);
                newer = true;
            }
            tx.executeSql("UPDATE EasyListListsLastModified SET lastModified=(?) WHERE listName=(?)", [(parseInt(timestamp, 10)+1), listName]);
        }
        if(newer == true)
        {
            // Clear all items.
            tx.executeSql('DELETE FROM EasyListData WHERE listName=(?)', [listName]);
        }
    });
    if(newer)
    {
        var lines = text.split(/[\n,]+/);
        var lineNum = lines.length;
        for(var i = 0; i < lineNum; ++i)
        {
            if(lines[i].length > 0)
            {
                if(lines[i].substring(0, 1) == "!")
                {
                    insertEditRecord(listName, lines[i].substring(1), true);
                }
                else
                {
                    insertEditRecord(listName, lines[i], false);
                }
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
        tx.executeSql('UPDATE EasyListListsLastModified SET lastModified=lastModified+1 WHERE listName=(?)', listName);
        tx.executeSql('INSERT INTO EasyListData (listName, itemText, selected) VALUES (?, ?, ?)', [listName, itemText, itemSelected]);
        resultSet = tx.executeSql(getOrderBy(selectSql), [listName]);
        var rs = tx.executeSql('SELECT MAX(pid) as maxId FROM EasyListData');
        for(var i = 0; i < rs.rows.length; i++)
        {
            index = rs.rows.item(i).maxId;
        }
    });
}

/**
 * Insert a record in the given list.
 */
function insertEditRecord(listName, itemText, itemSelected)
{
    var index = 0;
    var db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('UPDATE EasyListListsLastModified SET lastModified=lastModified+1 WHERE listName=(?)', [listName]);
        var res = tx.executeSql('INSERT INTO EasyListData (listName, itemText, selected) VALUES (?, ?, ?)', [listName, itemText, itemSelected]);
        resultSet = tx.executeSql(getOrderBy(selectSql), [listName]);
        var rs = tx.executeSql('SELECT MAX(pid) as maxId FROM EasyListData');
        for(var i = 0; i < rs.rows.length; i++)
        {
            index = rs.rows.item(i).maxId;
        }
    });
}

function addList(listName)
{
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR IGNORE INTO EasyListLists (listName) VALUES (?)", [listName]);
    });
}
