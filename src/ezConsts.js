Qt.include("db.js");

var propListName = "listName";
var propSort = "sort";
var propSortSelected = "sortSelected";
var propSortPid = "sortPid";
var propOrientationLock = "orientationLock";
var propTheme = "theme";
var propSyncUrl = "syncUrl";
var propSyncUsername = "syncUsername";
var propSyncPassword = "syncPassword";

var SORT_SELECTED = "selected ASC"
var SORT_A_Z = "UPPER(itemText) ASC";
var SORT_PID = "pid ASC";

/**
 * Here starts the code for themes.
 */
// Default theme name.
var THEME = getProperty("theme");

// List of theme names. Must correspond to the associative
// value used in the list of values below.
var THEME_NAMES = ["default",
                   "blue",
                   "dark",
                   "pink"];


// List of values for each theme. Associative index must exist
// in the THEME_NAMES array in order to make it available for use.
var BACKGROUND_COLORS = new Array();
BACKGROUND_COLORS['default'] = "transparent";
BACKGROUND_COLORS['dark'] = "#666666";
BACKGROUND_COLORS['pink'] = "#FFBAD2";
BACKGROUND_COLORS['blue'] = "#B4D8E7";

var LIST_ITEM_BACKGROUND_COLORS = new Array();
LIST_ITEM_BACKGROUND_COLORS['default'] = "transparent";
LIST_ITEM_BACKGROUND_COLORS['dark'] = "transparent";
LIST_ITEM_BACKGROUND_COLORS['pink'] = "transparent";
LIST_ITEM_BACKGROUND_COLORS['blue'] = "transparent";

var LIST_ITEM_TEXT_COLORS = new Array();
LIST_ITEM_TEXT_COLORS['default'] = "#000000";
LIST_ITEM_TEXT_COLORS['dark'] = "#ffffff";
LIST_ITEM_TEXT_COLORS['pink'] = "#5C604D";
LIST_ITEM_TEXT_COLORS['blue'] = "#5C604D";

var HOVER_COLORS = new Array();
HOVER_COLORS['default'] = "#d7d8d8";
HOVER_COLORS['dark'] = "#d7d8d8";
HOVER_COLORS['pink'] = "#d7d8d8";
HOVER_COLORS['blue'] = "#d7d8d8";

var HIGHLIGHT_COLORS = new Array();
HIGHLIGHT_COLORS['default'] = "lightsteelblue";
HIGHLIGHT_COLORS['dark'] = "lightsteelblue";
HIGHLIGHT_COLORS['pink'] = "#FFE9E8";
HIGHLIGHT_COLORS['blue'] = "#E4F6F8";

var TEXT_COLORS = new Array();
TEXT_COLORS['default'] = "#000000";
TEXT_COLORS['dark'] = "#ffffff";
TEXT_COLORS['pink'] = "#5C604D";
TEXT_COLORS['blue'] = "#5C604D";

var DIVISION_LINE_COLORS = new Array();
DIVISION_LINE_COLORS['default'] = "#cccccc";
DIVISION_LINE_COLORS['dark'] = "#cccccc";
DIVISION_LINE_COLORS['pink'] = "#FFE9E8";
DIVISION_LINE_COLORS['blue'] = "#ffffff";

var DIVISION_LINE_TEXT_COLORS = new Array();
DIVISION_LINE_TEXT_COLORS['default'] = "#333333";
DIVISION_LINE_TEXT_COLORS['dark'] = "#cccccc";
DIVISION_LINE_TEXT_COLORS['pink'] = "#FFE9E8";
DIVISION_LINE_TEXT_COLORS['blue'] = "#ffffff";

var HEADER_BACKGROUND_COLORS = new Array();
HEADER_BACKGROUND_COLORS['default'] = "#333333";
HEADER_BACKGROUND_COLORS['dark'] = "#333333";
HEADER_BACKGROUND_COLORS['pink'] = "#E47297";
HEADER_BACKGROUND_COLORS['blue'] = "#56BAEC";

var HEADER_TEXT_COLORS = new Array();
HEADER_TEXT_COLORS['default'] = "#ffffff";
HEADER_TEXT_COLORS['dark'] = "#ffffff";
HEADER_TEXT_COLORS['pink'] = "#E5E7E1";
HEADER_TEXT_COLORS['blue'] = "#ffffff";

// Nothing needs to be done here.
var THEME_VALUES = new Array();
THEME_VALUES['BACKGROUND_COLOR'] = BACKGROUND_COLORS;
THEME_VALUES['LIST_ITEM_BACKGROUND_COLOR'] = LIST_ITEM_BACKGROUND_COLORS;
THEME_VALUES['LIST_ITEM_TEXT_COLOR'] = LIST_ITEM_TEXT_COLORS;
THEME_VALUES['TEXT_COLOR'] = TEXT_COLORS;
THEME_VALUES['HOVER_COLOR'] = HOVER_COLORS;
THEME_VALUES['HIGHLIGHT_COLOR'] = HIGHLIGHT_COLORS;
THEME_VALUES['DIVISION_LINE_COLOR'] = DIVISION_LINE_COLORS;
THEME_VALUES['DIVISION_LINE_TEXT_COLOR'] = DIVISION_LINE_TEXT_COLORS;
THEME_VALUES['HEADER_BACKGROUND_COLOR'] = HEADER_BACKGROUND_COLORS;
THEME_VALUES['HEADER_TEXT_COLOR'] = HEADER_TEXT_COLORS;

/**
 * To get a value from the theme. For instance if you want to get the
 * background color of the current theme, use: getValue("BACKGROUND_COLOR");
 * The String BACKGROUND_COLOR is the associative index in the THEME_VALUES
 * array.
 */
function getValue(themeValue)
{
    return THEME_VALUES[themeValue][THEME];
}

function loadTheme()
{
    THEME = getProperty("theme");
}

/**
 * Get a property in the database.
 */
function getProperty(propertyName)
{
    var db = getDbConnection();
    var resultSet;
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS EasyListApp(property STRING UNIQUE, value STRING)');
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propListName, "default"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSort, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSortSelected, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSortPid, "true"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propOrientationLock, "Automatic"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propTheme, "default"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSyncUrl, "http://easylist.willemliu.nl/getList.php"]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSyncUsername, ""]);
        tx.executeSql("INSERT OR IGNORE INTO EasyListApp (property, value) VALUES (?,?)", [propSyncPassword, ""]);
        resultSet = tx.executeSql("SELECT * FROM EasyListApp WHERE property=(?)", [propertyName]);
    });
    var propertyValue;
    for(var i = 0; i < resultSet.rows.length; i++)
    {
        propertyValue = resultSet.rows.item(i).value;
    }
    return propertyValue;
}
