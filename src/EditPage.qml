import com.meego 1.0
import QtQuick 1.1
import "editPageDb.js" as EditDb

Page {
    id: editPage
    property string listName: "default"
    property bool textChanged: false
    signal changeView
    signal aboutView

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-save";
            onClicked: {
                textEdit.closeSoftwareInputPanel();
                EditDb.populateDB(textEdit.text);
                editPage.changeView();
            }
        }
        ToolIcon {
            iconId: "toolbar-view-menu";
            onClicked: {
                textEdit.closeSoftwareInputPanel();
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
                    textEdit.closeSoftwareInputPanel();
                    EditDb.populateDB(textEdit.text);
                    editPage.changeView();
                }
            }
            MenuItem {
                text: "Cancel";
                onClicked: {
                    textEdit.closeSoftwareInputPanel();
                    editPage.pageStack.pop();
                }
            }
            MenuItem {
                text: "About";
                onClicked: {
                    textEdit.closeSoftwareInputPanel();
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "EasyList - Edit"
            font.pointSize: 30
            color: "#fff"
        }
    }

    Flickable {
        id: flick
        anchors.top: header.bottom
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: textEdit.paintedHeight
        contentWidth: textEdit.paintedWidth
        clip: true

        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: textEdit
            width: flick.width
            height: flick.height
            font.family: "Helvetica"
            font.pointSize: 22
            focus: true
            color: "#333"
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textEdit.forceActiveFocus();
                    textEdit.openSoftwareInputPanel();
                    textEdit.cursorPosition = textEdit.positionAt(mouse.x, mouse.y);
                }
                onPressAndHold: {
                    textEdit.closeSoftwareInputPanel();
                    myMenu.open();
                }
                onDoubleClicked: textEdit.selectWord();
            }
        }
    }
    ScrollDecorator {
        flickableItem: flick
    }
    
    function reloadDb()
    {
      textEdit.text = EditDb.loadDB(editPage.listName);
    }
}
