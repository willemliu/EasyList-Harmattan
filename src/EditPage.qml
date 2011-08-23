import com.meego 1.0
import QtQuick 1.0
import "editPageDb.js" as EditDb
import "settingsDb.js" as SettingsDb

Sheet {
    id: editPage
    property string listName: "default"
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    onAccepted: {
        textEdit.platformCloseSoftwareInputPanel();
        EditDb.populateDB(textEdit.text);
    }

    content: Flickable {
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
            placeholderText: "Enter text to create your list.\nEach new line represents a new item."
            focus: true
            inputMethodHints: Qt.ImhNoPredictiveText
            onCursorPositionChanged: {
                textEdit.positionToRectangle(cursorPosition);
            }
        }
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
