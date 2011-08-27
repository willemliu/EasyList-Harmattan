import com.meego 1.0
import QtQuick 1.0
import "ezConsts.js" as Consts
import "settingsDb.js" as SettingsDb
import "listsDb.js" as ListsDb

Page {
    id: listsPage
    orientationLock: SettingsDb.getOrientationLock();
    signal settingsView
    signal aboutView
    property string listName: SettingsDb.getListName()
    signal hideToolbar(bool hideToolbar)

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: Consts.HEADER_BACKGROUND_COLOR
        z: 1
        Label {
            id: title
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            text: "EasyList - Lists"
            font.pixelSize: 32
            color: Consts.HEADER_TEXT_COLOR
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
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listsPage.listName = listsItem.listName;
                    listView.currentIndex = model.index;
                    SettingsDb.setListName(listsPage.listName);
                    listsItem.backgroundColor = Consts.BACKGROUND_COLOR;
                    pageStack.pop();
                }
                onPressAndHold: {
                    listsPage.listName = listsItem.listName;
                    contextMenu.open();
                    listsItem.backgroundColor = Consts.BACKGROUND_COLOR;
                }
                onHoveredChanged: {
                    if(containsMouse)
                    {
                        listsItem.backgroundColor = Consts.HOVER_COLOR;
                    }
                    else
                    {
                        listsItem.backgroundColor = Consts.BACKGROUND_COLOR;
                    }
                }
                onReleased: {
                    listsItem.backgroundColor = Consts.BACKGROUND_COLOR;
                }
            }
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: listView.width;
            height: 60
            color: Consts.HIGHLIGHT_COLOR;
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
            radius: 5
            Rectangle {
                id: divisionLine
                color: Consts.DIVISION_LINE
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
                text: "Rename";
                onClicked: {
                    renameListSheet.oldListName = listsPage.listName;
                    renameListSheet.open();
                }
            }
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
        focus: true
        content: Flickable {
            id: flick
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            contentWidth: listNameRect.implicitWidth
            contentHeight: listNameRect.implicitHeight
            clip: true
            focus: true

            Rectangle {
                id: listNameRect
                width: Math.max (flick.width, implicitWidth);
                height: Math.max (flick.height, implicitHeight)
                color: Consts.BACKGROUND_COLOR
                focus: true
                Label {
                    id: newListLabel
                    text: "New list name:"
                    anchors.topMargin: 5
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pixelSize: 24
                }
                TextField {
                    id: textField
                    anchors.topMargin: 5
                    anchors.top: newListLabel.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    focus: true
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
                textField.selectAll();
                textField.platformOpenSoftwareInputPanel();
                listsPage.hideToolbar(true);
            }
            else
            {
                listsPage.hideToolbar(false);
            }
        }
    }

    Sheet {
        id: renameListSheet
        property string oldListName:  ""
        visualParent: listsPage
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        z: 2
        acceptButtonText: "Rename"
        rejectButtonText: "Cancel"
        focus: true
        content: Flickable {
            id: renameFlick
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            contentWidth: renameListNameRect.implicitWidth
            contentHeight: renameListNameRect.implicitHeight
            clip: true
            focus: true

            Rectangle {
                id: renameListNameRect
                width: Math.max (renameFlick.width, implicitWidth);
                height: Math.max (renameFlick.height, implicitHeight)
                color: Consts.BACKGROUND_COLOR
                focus: true
                Label {
                    id: renameNewListLabel
                    text: "New list name:"
                    anchors.topMargin: 5
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pixelSize: 24
                }
                TextField {
                    id: renameTextField
                    text: renameListSheet.oldListName
                    anchors.topMargin: 5
                    anchors.top: renameNewListLabel.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    focus: true
                    maximumLength: 20
                    inputMethodHints: Qt.ImhNoPredictiveText
                }
            }
        }
        onAccepted: {
            ListsDb.renameList(renameListSheet.oldListName, renameTextField.text);
            SettingsDb.setListName(renameTextField.text);
            listsPage.reloadDb();
        }
        onRejected: {
        }
        onVisibleChanged: {
            if(visible)
            {
                renameTextField.selectAll();
                renameTextField.platformOpenSoftwareInputPanel();
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
