import com.meego 1.0
import QtQuick 1.0
import "mainPageDb.js" as DbConnection
import "settingsDb.js" as SettingsDb

Page {
    id: mainPage
    property string listName: SettingsDb.getListName()
    signal changeView
    signal aboutView
    signal listsView

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-back-dimmed";
            enabled: false
            onClicked: {
                myMenu.close();
            }
        }
        ToolIcon {
            iconId: "toolbar-edit";
            onClicked: {
                mainPage.changeView()
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
                text: "Edit";
                onClicked: {
                    mainPage.changeView()
                }
            }
            MenuItem {
                text: "Deselect all";
                onClicked: {
                    DbConnection.deselectAll()
                    DbConnection.loadDB(listName);
                }
            }
            MenuItem {
                text: "Remove selected";
                onClicked: {
                    removeDialog.open();
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
        titleText: "Remove selected items?"
        message: "Do you really want to remove all selected items?"
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
        Text {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "EasyList"
            font.pointSize: 30
            color: "#fff"
        }
        ToolIcon {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: title.right
            iconId: "toolbar-down-white";
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(myMenu.status == DialogStatus.Closed)
                {
                    myMenu.open()
                }
                else
                {
                    myMenu.close()
                }
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
            height: 55
            width: listView.width

            onCheckChanged: {
                DbConnection.saveRecord(itemIndex, itemSelected);
                DbConnection.loadDB(listName);
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    if(listItem.itemSelected == "true")
                    {
                        DbConnection.saveRecord(listItem.itemIndex, "false");
                    }
                    else
                    {
                        DbConnection.saveRecord(listItem.itemIndex, "true");
                    }
                    DbConnection.loadDB(listName);
                }
            }

            ListView.onAdd: ParallelAnimation {
                NumberAnimation {target: listItem; property: "opacity"; to: 1.0; duration: 300;}
            }

            ListView.onRemove: ParallelAnimation {
                PropertyAction {target: listItem; property: "ListView.delayRemove"; value: true;}
                NumberAnimation {target: listItem; property: "y"; to: 0; duration: 1000;}
                NumberAnimation {target: listItem; property: "opacity"; to: 0.0; duration: 500;}
                PropertyAction {target: listItem; property: "ListView.delayRemove"; value: false;}
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
