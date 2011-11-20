import com.nokia.meego 1.0
import QtQuick 1.0
import "mainPageDb.js" as DbConnection

Page {
    id: mainPage
    orientationLock: DbConnection.getOrientationLock();
    property string listName: DbConnection.getListName()
    property color backgroundColor: DbConnection.getValue("BACKGROUND_COLOR")
    property color headerBackgroundColor: DbConnection.getValue("HEADER_BACKGROUND_COLOR")
    property color headerTextColor: DbConnection.getValue("HEADER_TEXT_COLOR")
    property color divisionLineColor: DbConnection.getValue("DIVISION_LINE_COLOR")
    property color divisionLineTextColor: DbConnection.getValue("DIVISION_LINE_TEXT_COLOR")
    property color textColor: DbConnection.getValue("TEXT_COLOR")
    property color listItemBackgroundColor: DbConnection.getValue("LIST_ITEM_BACKGROUND_COLOR")
    property color hoverColor: DbConnection.getValue("HOVER_COLOR");
    signal settingsView
    signal aboutView
    signal listsView
    signal hideToolbar(bool hideToolbar)
    property int index: -1
    property int modelIndex: -1


    onStatusChanged: {
        //console.log("+++ MainPage::onStatusChanged", status);
        if (status==PageStatus.Activating) {
            updateButtonStatus();
        }
        if (status==PageStatus.Activated) {
            //console.log("+++ MainPage::onStatusChanged.Activated");
        }
        if (status==PageStatus.Deactivating) {
            //console.log("+++ MainPage::onStatusChanged .Deactivating");
            listsPage.hideToolbar(false);
        }
    }


    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-edit";
            onClicked: {
                myEditPage.open();
            }
        }
        ToolIcon {
            id: deleteToolIcon
            iconId: "toolbar-delete";
            onClicked: {
                myMenu.close();
                removeDialog.open();
            }
        }
        ToolIcon {
            iconId: "toolbar-list";
            onClicked: {
                myMenu.close();
                mainPage.listsView();
            }
        }
        ToolIcon {
            iconId: "toolbar-view-menu";
            onClicked: {
                if(myMenu.status == DialogStatus.Closed)
                {
                    myMenu.open();
                }
                else {
                    myMenu.close();
                }
            }
        }
    }

    Menu {
        id: myMenu
        MenuLayout {
            MenuItem {
                id: deselectAllMenuItem
                text: qsTr("Deselect all");
                onClicked: {
                    DbConnection.deselectAll()
                    DbConnection.loadDB(listName);
		    updateButtonStatus();
				}
            }
            MenuItem {
                id: removeSelectedMenuItem
                text: qsTr("Remove checked");
                onClicked: {
                    removeDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Synchronise");
                onClicked: {
                    syncDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Settings");
                onClicked: {
                    mainPage.settingsView();
                }
            }
            MenuItem {
                text: qsTr("About");
                onClicked: {
                    onClicked: mainPage.aboutView()
                }
            }
        }
    }

    QueryDialog {
        id: removeDialog
        titleText: qsTr("Remove checked items?")
        message: qsTr("Do you really want to remove all checked items?")
        acceptButtonText: qsTr("Ok")
        rejectButtonText: qsTr("Cancel")
        onAccepted: {
            removeSelected();
        }
    }

    QueryDialog {
        id: syncDialog
        titleText: qsTr("Sync with online list?")
        message: qsTr("Do you really want sync your current list with the online list?\n\nAll your current items will be overwritten.")
        acceptButtonText: qsTr("Ok")
        rejectButtonText: qsTr("Cancel")
        onAccepted: {
            mainPage.sync();
        }
    }

    QueryDialog {
        id: unableToSyncDialog
        titleText: qsTr("Can't synchronize")
        message: qsTr("Unable to synchronize with online list. Please make sure you've correctly setup your sync account in settings.")
        acceptButtonText: qsTr("Ok")
    }

    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent

        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 70
            color: headerBackgroundColor
            z: 10
            Label {
                id: title
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 20
                text: "EasyList - [" + mainPage.listName + "]"
                font.pixelSize: 32
                color: headerTextColor
            }
        }

        EditPage {
            id: myEditPage
            visualParent: mainPage
            anchors.fill: parent
            z: 2
            onAccepted: {
                mainPage.reloadDb();
            }
            onVisibleChanged: {
                if(visible)
                {
                    mainPage.hideToolbar(true);
                }
                else
                {
                    mainPage.hideToolbar(false);
                }
            }
        }

        ListModel {
            id: listModel
        }

        ListView {
            id: listView
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            model: DbConnection.loadDB(listName)
            delegate: itemComponent
        }
        ScrollDecorator {
            flickableItem: listView
        }

        Component {
            id: itemComponent
            ListItemDelegate {
                id: listItem
                itemIndex: model.itemIndex
                itemText: model.itemText
                itemSelected: model.itemSelected
                height: 60
                width: listView.width

                onCheckChanged: {
                    DbConnection.saveRecord(itemIndex, itemSelected);
                    DbConnection.loadDB(listName);
                    updateButtonStatus();
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(listItem.itemSelected == "true")
                        {
                            DbConnection.saveRecord(itemIndex, "false");
                        }
                        else
                        {
                            DbConnection.saveRecord(itemIndex, "true");
                        }
                        DbConnection.loadDB(listName);
                        listItem.backgroundColor = DbConnection.getValue("LIST_ITEM_BACKGROUND_COLOR");
                        updateButtonStatus();
                    }
                    onPressAndHold: {
                        mainPage.index = listItem.itemIndex;
                        contextMenu.open();
                        listItem.backgroundColor = DbConnection.getValue("LIST_ITEM_BACKGROUND_COLOR");
                    }
                    onHoveredChanged: {
                        if(containsMouse)
                        {
                            listItem.backgroundColor = DbConnection.getValue("HOVER_COLOR");
                        }
                        else
                        {
                            listItem.backgroundColor = DbConnection.getValue("LIST_ITEM_BACKGROUND_COLOR");
                        }
                    }
                    onReleased: {
                        listItem.backgroundColor = DbConnection.getValue("LIST_ITEM_BACKGROUND_COLOR");
                    }
                }
            }
        }
    }

    ContextMenu {
        id: contextMenu
        MenuLayout {
            MenuItem {
                text: qsTr("Remove");
                onClicked: {
                    DbConnection.removeRecord(mainPage.index);
                    mainPage.reloadDb();
                }
            }
        }
    }

    onVisibleChanged: {
        if(visible)
        {
            reloadDb();
        }
    }

    function reloadDb()
    {
        listName = DbConnection.getListName();
        DbConnection.loadDB(listName);
    }

    function removeSelected()
    {
        var num = listModel.count;
        for(var i = num-1; i >= 0; --i)
        {
            if(listModel.get(i).itemSelected == "true")
            {
                DbConnection.removeRecord(listModel.get(i).itemIndex);
            }
        }
        DbConnection.populateModel();
        updateButtonStatus();
    }

    function loadTheme()
    {
        DbConnection.loadTheme();
        backgroundColor = DbConnection.getValue("BACKGROUND_COLOR");
        headerBackgroundColor = DbConnection.getValue("HEADER_BACKGROUND_COLOR");
        headerTextColor = DbConnection.getValue("HEADER_TEXT_COLOR");
        divisionLineColor = DbConnection.getValue("DIVISION_LINE_COLOR");
        divisionLineTextColor = DbConnection.getValue("DIVISION_LINE_TEXT_COLOR");
        textColor = DbConnection.getValue("TEXT_COLOR");
        listItemBackgroundColor = DbConnection.getValue("LIST_ITEM_BACKGROUND_COLOR");
        hoverColor = DbConnection.getValue("HOVER_COLOR");
        myEditPage.loadTheme();
    }

    function sync()
    {
        var syncUrl = DbConnection.getProperty(DbConnection.propSyncUrl);
        var syncUsername = DbConnection.getProperty(DbConnection.propSyncUsername);
        var syncPassword = DbConnection.getProperty(DbConnection.propSyncPassword);
        if(syncUsername.length > 0 && syncPassword.length > 0)
        {
            var synced = false;
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED)
                {
                    //showRequestInfo("Headers -->");
                    //showRequestInfo(doc.getAllResponseHeaders ());
                    //showRequestInfo("Last modified -->");
                    //showRequestInfo(doc.getResponseHeader ("Last-Modified"));
                }
                else if (doc.readyState == XMLHttpRequest.DONE)
                {
                    var response = doc.responseXML;
                    if(response !== null)
                    {
                        var a = response.documentElement;
                        if(a !== null)
                        {
                            if(a.nodeName == "ezList")
                            {
                                for (var ii = 0; ii < a.childNodes.length; ++ii) {
                                    if(a.childNodes[ii].nodeName == "#cdata-section")
                                    {
                                        myEditPage.saveText(mainPage.listName, a.childNodes[ii].nodeValue);
                                        synced = true;
                                        break;
                                    }
                                }
                                mainPage.reloadDb();
                            }
                            //showRequestInfo("Headers -->");
                            //showRequestInfo(doc.getAllResponseHeaders ());
                            //showRequestInfo("Last modified -->");
                            //showRequestInfo(doc.getResponseHeader ("Last-Modified"));
                        }
                    }
                    if(synced === false)
                    {
                        unableToSyncDialog.open();
                    }
                }
            }
            doc.open("GET", syncUrl + "?username=" + syncUsername + "&password=" + syncPassword + "&xml=true");
            doc.send();
        }
        else
        {
            unableToSyncDialog.open();
        }
    }
    function showRequestInfo(text) {
        console.log(text)
    }


    function updateButtonStatus()
    {
        var itemsCount = listModel.count;
        var selectedItems = false;
        for(var i = 0; i < itemsCount; ++i)
        {
            if(listModel.get(i).itemSelected == "true")
            {
                selectedItems = true;
                break;
            }
        }

        //console.log("Updating button status ", itemsCount, ", ", selectedItems);

        removeSelectedMenuItem.visible = selectedItems;
        if (selectedItems)
        {
            deleteToolIcon.iconId = "toolbar-delete";;
        }
        else
        {
            deleteToolIcon.iconId = "toolbar-delete-dimmed";;
        }

        deleteToolIcon.enabled = selectedItems;
    }
}
