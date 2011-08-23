import com.meego 1.0
import QtQuick 1.0

Item {
    id: listsItem
    property string listName: "No text"

    Label {
        id: checkBoxText
        text: listName
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.family: "Helvetica"
        font.pixelSize: 26
    }

    Rectangle {
        id: divisionLine
        color: "#ccc"
        height: 1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
