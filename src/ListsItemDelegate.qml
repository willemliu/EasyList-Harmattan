import com.meego 1.0
import QtQuick 1.0

Item {
    id: listsItem
    property string listName: "No text"
    height: 55

    Text {
        id: checkBoxText
        text: listName
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.family: "Helvetica"
        font.pointSize: 22
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
