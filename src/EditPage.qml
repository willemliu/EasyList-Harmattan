import com.meego 1.0
import QtQuick 1.0
import "editPageDb.js" as EditDb

Sheet {
    id: editPage
    property string listName: "default"
    property color backgroundColor: EditDb.getValue("BACKGROUND_COLOR")
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"
    buttons: [
        SheetButton {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Paste"
            onClicked: {
                textEdit.paste();
            }
        }
    ]

    onAccepted: {
        textEdit.platformCloseSoftwareInputPanel();
        EditDb.populateEditDb(textEdit.text);
    }

    content: Rectangle{
        id: background
        color: backgroundColor
        anchors.fill: parent
        Flickable {
            id: flick
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            contentHeight: textEdit.implicitHeight
            contentWidth: textEdit.implicitWidth
            clip: true

            TextArea {
                id: textEdit
                width: Math.max (flick.width, implicitWidth);
                height: Math.max (flick.height, implicitHeight)
                placeholderText: "Enter text to create your list.\nEach new line represents a new item.\n\nTip: You can copy text from other apps\nand paste it here as well."
                focus: true
                //inputMethodHints: Qt.ImhNoPredictiveText
                onCursorPositionChanged: {
                    textEdit.positionToRectangle(cursorPosition);
                }
            }
        }
    }

    function reloadDb()
    {
        listName = EditDb.getListName();
        textEdit.text = EditDb.loadEditDb(listName);
    }

    onVisibleChanged: {
        if(visible)
        {
            reloadDb();
        }
    }

    function loadTheme()
    {
        EditDb.loadTheme();
        backgroundColor = EditDb.getValue("BACKGROUND_COLOR");
    }
}
