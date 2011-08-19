import com.meego 1.0
import QtQuick 1.0
import "editPageDb.js" as EditDb
import "settingsDb.js" as SettingsDb

Page {
    id: editPage
    orientationLock: SettingsDb.getOrientationLock();
    property string listName: "default"
    property bool textChanged: false
    signal changeView
    signal settingsView
    signal aboutView

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                textEdit.platformCloseSoftwareInputPanel();
                pageStack.pop();
            }
        }
        ToolIcon {
            iconId: "toolbar-done";
            onClicked: {
                textEdit.platformCloseSoftwareInputPanel();
                EditDb.populateDB(textEdit.text);
                editPage.changeView();
            }
        }
        ToolIcon {
            iconId: "toolbar-view-menu";
            onClicked: {
                textEdit.platformCloseSoftwareInputPanel();
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

    Menu {
        id: myMenu
        MenuLayout {
            MenuItem {
                text: "Save";
                onClicked: {
                    textEdit.platformCloseSoftwareInputPanel();
                    EditDb.populateDB(textEdit.text);
                    editPage.changeView();
                }
            }
            MenuItem {
                text: "Paste";
                onClicked: {
                    textEdit.platformCloseSoftwareInputPanel();
                    textEdit.paste();
                }
            }
            MenuItem {
                text: "Cancel";
                onClicked: {
                    textEdit.platformCloseSoftwareInputPanel();
                    editPage.pageStack.pop();
                }
            }
            MenuItem {
                text: "Settings";
                onClicked: {
                    textEdit.platformCloseSoftwareInputPanel();
                    editPage.settingsView();
                }
            }
            MenuItem {
                text: "About";
                onClicked: {
                    textEdit.platformCloseSoftwareInputPanel();
                    editPage.aboutView();
                }
            }
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
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            text: "EasyList - Edit"
            font.pointSize: 26
            color: "#fff"
        }
        ToolIcon {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            iconId: "textinput-combobox-arrow";
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                textEdit.platformCloseSoftwareInputPanel();
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

    Flickable {
        id: flick
        anchors.top: header.bottom
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: textEdit.implicitHeight
        contentWidth: textEdit.implicitWidth
        clip: true

        TextArea {
            id: textEdit
            width: Math.max (flick.width, implicitWidth);
            height: Math.max (flick.height, implicitHeight)
            placeholderText: "Enter text to create your list.\nEach new line represents a new item."
            focus: true
            inputMethodHints: Qt.ImhNoPredictiveText
            onCursorPositionChanged: {
                textEdit.positionToRectangle(cursorPosition);
            }
        }
    }
    ScrollDecorator {
        flickableItem: flick
    }
    
    function reloadDb()
    {
        listName = SettingsDb.getListName();
        textEdit.text = EditDb.loadDB(listName);
    }

    onVisibleChanged: {
        if(visible)
        {
            reloadDb();
        }
    }
}
