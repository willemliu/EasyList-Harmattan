Qt.include("ezConsts.js");
Qt.include("db.js");
var db;
var listName =  "default";
var resultSet;
var selectSql = "SELECT * FROM EasyListApp WHERE property=(?) ORDER BY pid ASC";
var propListName = "listName";
var propSort = "sort";
var propSortSelected = "sortSelected";
var propSortPid = "sortPid";
var propOrientationLock = "orientationLock";

/**
 * The entry point. This function is called by all other functions which need this
 * database connection te be setup. This function starts the database connection. The table
 * EasyListApp is also created if it does not exist yet.
 *
 */
function loadSettingsDb()
{
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListApp(property STRING UNIQUE, value STRING)');
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propListName, "default"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSort, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSortSelected, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSortPid, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propOrientationLock, "Automatic"]);
    });
}

/**
 * Set the list name in the database.
 */
function setListName(theListName)
{
    listName = theListName;
    setProperty(propListName, listName);
}

/**
 * Return the list name.
 */
function getListName()
{
    return getProperty(propListName);
}

function getOrientationLock()
{
    var result = PageOrientation.Automatic;
    if(getProperty(propOrientationLock) == "Automatic")
    {
        result = PageOrientation.Automatic;
    }
    else if(getProperty(propOrientationLock) == "Portrait")
    {
        result = PageOrientation.LockPortrait;
    }
    else if(getProperty(propOrientationLock) == "Landscape")
    {
        result = PageOrientation.LockLandscape;
    }
    return result;
}

/**
 * Set a property in the database.
 */
function setProperty(propertyName, propertyValue)
{
    loadSettingsDb();
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO EasyListApp (property, value) VALUES (?,?)", [propertyName, propertyValue]);
    });
}

/**
 * Get a property in the database.
 */
function getProperty(propertyName)
{
    loadSettingsDb();
    db.transaction(function(tx) {
        resultSet = tx.executeSql("SELECT * FROM EasyListApp WHERE property=(?)", [propertyName]);
    });
    var propertyValue;
    for(var i = 0; i < resultSet.rows.length; i++)
    {
        propertyValue = resultSet.rows.item(i).value;
    }
    return propertyValue;
}

/**
 * Returns the given query with the order by statement appended to it.
 */
function getOrderBy(query)
{
    var orderBy = "";
    var doOrder = false;
    if(getProperty(propSortSelected) == "true")
    {
        doOrder = true;
        if(orderBy.length > 0)
        {
            orderBy += ", ";
        }
        orderBy += SORT_SELECTED;
    }
    if(getProperty(propSort) == "true")
    {
        doOrder = true;
        if(orderBy.length > 0)
        {
            orderBy += ", ";
        }
        orderBy += SORT_A_Z;
    }
    if(getProperty(propSortPid) == "true")
    {
        doOrder = true;
        if(orderBy.length > 0)
        {
            orderBy += ", ";
        }
        orderBy += SORT_PID;
    }
    if(doOrder)
    {
        orderBy = " ORDER BY " + orderBy;
    }
    return (query + orderBy);
}

/**
 * Drop tables.
 */
function removeTables()
{
    db = getDbConnection();
    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE IF EXISTS EasyListData');
        tx.executeSql('DROP TABLE IF EXISTS EasyListApp');
        tx.executeSql('DROP TABLE IF EXISTS EasyListLists');
    });
}
