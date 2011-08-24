function getDbConnection() {
    return openDatabaseSync("EasyList", "1.0", "EasyList SQL", 1000000);
}
