import com.meego 1.0
import QtQuick 1.0
import "ezConsts.js" as Consts

Item {
    id: listsItem
    property string listIndex: "0"
    property string listName: "No text"
    property color backgroundColor: Consts.BACKGROUND_COLOR

    Rectangle {
        id: backgroundRect
        color: backgroundColor
        anchors.fill: parent
        Label {
            id: checkBoxText
            text: listName
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: 26
        }

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
