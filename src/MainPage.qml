import com.meego 1.0
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

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-edit";
            onClicked: {
                myEditPage.open();
            }
        }
        ToolIcon {
            id: deleteIcon
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
                text: "Deselect all";
                onClicked: {
                    DbConnection.deselectAll()
                    DbConnection.loadDB(listName);
                }
            }
            MenuItem {
                text: "Remove checked";
                onClicked: {
                    removeDialog.open();
                }
            }
            MenuItem {
                text: "Sync";
                onClicked: {
                    syncDialog.open();
                }
            }
            MenuItem {
                text: "Settings";
                onClicked: {
                    mainPage.settingsView();
                }
            }
            MenuItem {
                text: "About";
                onClicked: {
                    onClicked: mainPage.aboutView()
                }
            }
        }
    }

    QueryDialog {
        id: removeDialog
        titleText: "Remove checked items?"
        message: "Do you really want to remove all checked items?"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        onAccepted: {
            removeSelected();
        }
    }

    QueryDialog {
        id: syncDialog
        titleText: "Sync with online list?"
        message: "Do you really want sync your current list with the online list?\n\nAll your current items will be overwritten."
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        onAccepted: {
            mainPage.sync();
        }
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
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
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
                text: "Remove";
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
                var a = doc.responseXML.documentElement;
                if(a.nodeName == "ezList")
                {
                    for (var ii = 0; ii < a.childNodes.length; ++ii) {
                        if(a.childNodes[ii].nodeName == "#cdata-section")
                        {
                            myEditPage.saveText(mainPage.listName, a.childNodes[ii].nodeValue);
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
        var syncUrl = DbConnection.getProperty(DbConnection.propSyncUrl);
        var syncUsername = DbConnection.getProperty(DbConnection.propSyncUsername);
        var syncPassword = DbConnection.getProperty(DbConnection.propSyncPassword);
        doc.open("GET", syncUrl + "?username=" + syncUsername + "&password=" + syncPassword + "&xml=true");
        doc.send();
    }
    function showRequestInfo(text) {
        console.log(text)
    }
}
