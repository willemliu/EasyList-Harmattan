import com.meego 1.0
import QtQuick 1.0
import "settingsDb.js" as SettingsDb
import "listsDb.js" as ListsDb

Page {
    id: listsPage
    orientationLock: SettingsDb.getOrientationLock();
    signal settingsView
    signal aboutView
    property string listName: SettingsDb.getListName()
    signal hideToolbar(bool hideToolbar)
    property int index: -1
    property int modelIndex: -1

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
            text: "EasyList - Lists"
            font.pixelSize: 32
            color: "#fff"
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
        model: ListsDb.getListsModel()
        delegate: itemComponent
        highlight: highlight
        MouseArea {
            id: listViewMouseArea
            anchors.fill: parent
            onClicked: {
                listsPage.modelIndex = listView.indexAt(mouse.x, mouse.y);
                var item = listModel.get(listsPage.modelIndex);
                listView.currentIndex = listsPage.modelIndex;
                if(item !== undefined)
                {
                    listsPage.listName = item.listName;
                    SettingsDb.setListName(item.listName);
                }
            }
            onPressAndHold: {
                listsPage.modelIndex = listView.indexAt(mouse.x, mouse.y);
                listView.currentIndex = listsPage.modelIndex;
                var item = listModel.get(listsPage.modelIndex);
                if(item !== undefined)
                {
                    listsPage.listName = item.listName;
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
        ListsItemDelegate {
            id: listsItem
            listName: model.listName
            height: 60
            width: listView.width
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: listView.width;
            height: 60
            color: "lightsteelblue";
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
            radius: 5
            Rectangle {
                id: divisionLine
                color: "#ccc"
                height: 1
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }

    ContextMenu {
        id: contextMenu
        MenuLayout {
            MenuItem {
                text: "Remove";
                onClicked: {
                    removeDialog.open();
                }
            }
        }
    }

    Menu {
        id: myMenu
        MenuLayout {
            MenuItem {
                text: "Settings";
                onClicked: {
                    listsPage.settingsView();
                }
            }
            MenuItem {
                text: "About";
                onClicked: {
                    onClicked: listsPage.aboutView()
                }
            }
        }
    }

    function reloadDb()
    {
        ListsDb.getListsModel();
        listName = SettingsDb.getListName();
        var num = listModel.count;
        for(var i = 0; i < num; ++i)
        {
            textField.text = listName;
            if(listModel.get(i).listName == listName)
            {
                listView.currentIndex = i;
                break;
            }
        }
    }

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
        ToolIcon {
            iconId: "toolbar-add";
            onClicked: {
                addListSheet.open();
            }
        }
        ToolIcon {
            iconId: "toolbar-delete";
            onClicked: {
                removeDialog.open();
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

    Sheet {
        id: addListSheet
        visualParent: listsPage
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        z: 2
        acceptButtonText: "Save"
        rejectButtonText: "Cancel"
        content: Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: listNameRect.width
            contentHeight: listNameRect.height
            Rectangle {
                id: listNameRect
                width: Math.max (flick.width, implicitWidth);
                height: Math.max (flick.height, implicitHeight)
                Label {
                    id: listNameLabel
                    text: "List name: "
                    anchors.verticalCenter: textField.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pixelSize: 26
                }
                TextField {
                    id: textField
                    anchors.topMargin: 5
                    anchors.top: parent.top
                    anchors.left: listNameLabel.right
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    maximumLength: 20
                    inputMethodHints: Qt.ImhNoPredictiveText
                }
            }
        }
        onAccepted: {
            ListsDb.addList(textField.text);
            SettingsDb.setListName(textField.text);
            listsPage.reloadDb();
        }
        onRejected: {
        }
        onVisibleChanged: {
            if(visible)
            {
                listsPage.hideToolbar(true);
            }
            else
            {
                listsPage.hideToolbar(false);
            }
        }
    }

    QueryDialog {
        id: removeDialog
        titleText: "Remove list?"
        message: "Do you really want to remove [" + listsPage.listName + "] and all its items?"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        onAccepted: {
            ListsDb.removeList(listsPage.listName);
            SettingsDb.setListName(ListsDb.getFirstListName());
            reloadDb();
        }
    }

    onVisibleChanged: {
        if(visible)
        {
            reloadDb();
        }
    }
}
