import com.meego 1.0
import QtQuick 1.0
import "mainPageDb.js" as DbConnection
import "settingsDb.js" as SettingsDb

Page {
    id: mainPage
    orientationLock: SettingsDb.getOrientationLock();
    property string listName: SettingsDb.getListName()
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

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: "#333"
        z: 1
        Label {
            id: title
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            text: "EasyList"
            font.pixelSize: 32
            color: "#fff"
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

        MouseArea {
            id: listViewMouseArea
            anchors.fill: parent
            onClicked: {
                mainPage.modelIndex = listView.indexAt(mouse.x, mouse.y);
                var item = listModel.get(mainPage.modelIndex);
                if(item !== undefined)
                {
                    if(item.itemSelected == "true")
                    {
                        DbConnection.saveRecord(item.itemIndex, "false");
                    }
                    else
                    {
                        DbConnection.saveRecord(item.itemIndex, "true");
                    }
                }
                DbConnection.loadDB(listName);
            }
            onPressAndHold: {
                mainPage.modelIndex = listView.indexAt(mouse.x, mouse.y);
                var item = listModel.get(mainPage.modelIndex);
                if(item !== undefined)
                {
                    mainPage.index = item.itemIndex;
                    contextMenu.open();
                }
            }
        }
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
        }
    }

    ContextMenu {
        id: contextMenu
        MenuLayout {
            MenuItem {
                text: "Remove checked";
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
        listName = SettingsDb.getListName();
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
}
