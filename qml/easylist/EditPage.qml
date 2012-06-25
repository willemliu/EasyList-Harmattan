import com.nokia.meego 1.0
import QtQuick 1.0
import "editPageDb.js" as EditDb

Sheet {
    id: editPage
    property string listName: "default"
    property color backgroundColor: EditDb.getValue("BACKGROUND_COLOR")
    acceptButtonText: qsTr("Save")
    rejectButtonText: qsTr("Cancel")
    buttons: [
        SheetButton {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Paste")
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
            //clip: true

            TextArea {
                id: textEdit
                width: Math.max (flick.width, implicitWidth);
                height: Math.max (flick.height, implicitHeight)
                placeholderText: qsTr("Enter text to create your list.\nEach new line or comma delimits\na new item.\n\nTip: You can copy text from other apps\nand paste it here as well.")
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

    function saveText(listName, text)
    {
        EditDb.listName = listName
        EditDb.populateEditDb(text);
    }

    function saveList(listName, text, timestamp)
    {
        EditDb.setListDb(listName, text, timestamp);
    }
}
