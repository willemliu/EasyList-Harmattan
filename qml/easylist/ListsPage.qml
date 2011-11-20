import com.nokia.meego 1.0
import QtQuick 1.0
import "listsDb.js" as ListsDb

Page {
    id: listsPage
    property color backgroundColor: ListsDb.getValue("BACKGROUND_COLOR")
    property color headerBackgroundColor: ListsDb.getValue("HEADER_BACKGROUND_COLOR")
    property color headerTextColor: ListsDb.getValue("HEADER_TEXT_COLOR")
    property color divisionLineColor: ListsDb.getValue("DIVISION_LINE_COLOR")
    property color divisionLineTextColor: ListsDb.getValue("DIVISION_LINE_TEXT_COLOR")
    property color textColor: ListsDb.getValue("TEXT_COLOR")
    property color listItemBackgroundColor: ListsDb.getValue("LIST_ITEM_BACKGROUND_COLOR")
    property color hoverColor: ListsDb.getValue("HOVER_COLOR");
    property color highlightColor: ListsDb.getValue("HIGHLIGHT_COLOR")
    orientationLock: ListsDb.getOrientationLock();
    signal settingsView
    signal aboutView
    property string listName: ListsDb.getListName()
    signal hideToolbar(bool hideToolbar)

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
                text: qsTr("EasyList - Lists")
                font.pixelSize: 32
                color: headerTextColor
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
                backgroundColor: listItemBackgroundColor
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listsPage.listName = listsItem.listName;
                        listView.currentIndex = model.index;
                        ListsDb.setListName(listsPage.listName);
                        listsItem.backgroundColor = listItemBackgroundColor;
                        pageStack.pop();
                    }
                    onPressAndHold: {
                        listsPage.listName = listsItem.listName;
                        contextMenu.open();
                        listsItem.backgroundColor = listItemBackgroundColor;
                    }
                    onHoveredChanged: {
                        if(containsMouse)
                        {
                            listsItem.backgroundColor = hoverColor;
                        }
                        else
                        {
                            listsItem.backgroundColor = listItemBackgroundColor;
                        }
                    }
                    onReleased: {
                        listsItem.backgroundColor = listItemBackgroundColor;
                    }
                }
            }
        }

        Component {
            id: highlight
            Rectangle {
                z: 1
                width: listView.width;
                height: 60
                color: highlightColor;
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
                radius: 5
                Rectangle {
                    id: divisionLine
                    color: divisionLineColor
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
                    text: qsTr("Rename");
                    onClicked: {
                        renameListSheet.oldListName = listsPage.listName;
                        renameListSheet.open();
                    }
                }
                MenuItem {
                    text: qsTr("Remove");
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
                    text: qsTr("Settings");
                    onClicked: {
                        listsPage.settingsView();
                    }
                }
                MenuItem {
                    text: qsTr("About");
                    onClicked: {
                        onClicked: listsPage.aboutView()
                    }
                }
            }
        }

        Sheet {
            id: addListSheet
            visualParent: listsPage
            anchors.fill: parent
//            anchors.top: header.bottom
//            anchors.right: parent.right
//            anchors.left: parent.left
//            height: parent.height - header.height
            z: 2
            acceptButtonText: qsTr("Save")
            rejectButtonText: qsTr("Cancel")
            focus: true
            content: Rectangle {
                id: newListBackground
                anchors.fill: parent
                color: backgroundColor
                Flickable {
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
                        color: backgroundColor
                        focus: true
                        Label {
                            id: newListLabel
                            text: qsTr("New list name:")
                            anchors.topMargin: 5
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            font.pixelSize: 24
                            color: textColor
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
            }
            onAccepted: {
                ListsDb.addList(textField.text);
                ListsDb.setListName(textField.text);
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
            anchors.fill: parent
//            anchors.top: header.bottom
//            anchors.right: parent.right
//            anchors.left: parent.left
//            height: parent.height - header.height
            z: 2
            acceptButtonText: qsTr("Rename")
            rejectButtonText: qsTr("Cancel")
            focus: true
            content: Rectangle {
                id: renameListBackground
                anchors.fill: parent
                color: backgroundColor
                Flickable {
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
                        color: backgroundColor
                        focus: true
                        Label {
                            id: renameNewListLabel
                            text: qsTr("New list name:")
                            anchors.topMargin: 5
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            font.pixelSize: 24
                            color: textColor
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
            }
            onAccepted: {
                ListsDb.renameList(renameListSheet.oldListName, renameTextField.text);
                ListsDb.setListName(renameTextField.text);
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
    }

    function reloadDb()
    {
        loadTheme();
        ListsDb.getListsModel();
        listName = ListsDb.getListName();
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

    QueryDialog {
        id: removeDialog
        titleText: qsTr("Remove list?")
        message: qsTr("Do you really want to remove [") + listsPage.listName + qsTr("] and all its items?")
        acceptButtonText: qsTr("Ok")
        rejectButtonText: qsTr("Cancel")
        onAccepted: {
            ListsDb.removeList(listsPage.listName);
            ListsDb.setListName(ListsDb.getFirstListName());
            reloadDb();
        }
    }

    onVisibleChanged: {
        if(visible)
        {
            reloadDb();
        }
    }

    function loadTheme()
    {
        ListsDb.loadTheme();
        backgroundColor = ListsDb.getValue("BACKGROUND_COLOR");
        headerBackgroundColor = ListsDb.getValue("HEADER_BACKGROUND_COLOR");
        headerTextColor = ListsDb.getValue("HEADER_TEXT_COLOR");
        divisionLineColor = ListsDb.getValue("DIVISION_LINE_COLOR");
        divisionLineTextColor = ListsDb.getValue("DIVISION_LINE_TEXT_COLOR");
        textColor = ListsDb.getValue("TEXT_COLOR");
        listItemBackgroundColor = ListsDb.getValue("LIST_ITEM_BACKGROUND_COLOR");
        hoverColor = ListsDb.getValue("HOVER_COLOR");
        highlightColor = ListsDb.getValue("HIGHLIGHT_COLOR");
    }
}
