var propListName = "listName";
var propSort = "sort";
var propSortSelected = "sortSelected";
var propSortPid = "sortPid";
var propOrientationLock = "orientationLock";
var propCommaDelimitedSelected = "commaDelimitedSelected";
var propTheme = "theme";
var propSyncUrl = "syncUrl";
var propSyncUsername = "syncUsername";
var propSyncPassword = "syncPassword";

var db;

function getDbConnection() {
    if (typeof db == 'undefined')
        {
        db = openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
        }
    return db;
}

function initDb() {
    //console.log("ezConsts::initDb");
    getDbConnection();

    // test if database tables are set up already
    db.transaction(function(tx) {
        // If database does not exist yet, creates tables and sets default value for settings.
        // This is done only once.

        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListData(pid INTEGER PRIMARY KEY, listName STRING, itemText STRING, selected BOOLEAN)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListApp(property STRING UNIQUE, value STRING)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListLists(pid INTEGER PRIMARY KEY, listName STRING UNIQUE)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListListsLastModified(pid INTEGER PRIMARY KEY, listName STRING UNIQUE, lastModified INTEGER)');

        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propListName, "default"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSort, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSortSelected, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSortPid, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propOrientationLock, "Automatic"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propCommaDelimitedSelected, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propTheme, "default"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSyncUrl, "http://easylist.willemliu.nl/getList.php"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSyncUsername, ""]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSyncPassword, ""]);
        // console.log("ezConsts::initDb complete");
        });

    return 1;
}

