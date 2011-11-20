import com.nokia.meego 1.0
import QtQuick 1.0
import "ezConsts.js" as Consts

Item {
    id: listsItem
    property string listIndex: "0"
    property string listName: "No text"
    property color backgroundColor: Consts.getValue("LIST_ITEM_BACKGROUND_COLOR")

    Rectangle {
        id: backgroundRect
        color: backgroundColor
        anchors.fill: parent
        Label {
            id: checkBoxText
            text: listName
            color: Consts.getValue("LIST_ITEM_TEXT_COLOR");
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: 26
        }

        Rectangle {
            id: divisionLine
            color: Consts.getValue("DIVISION_LINE_COLOR")
            height: 1
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    function loadTheme()
    {
        Consts.loadTheme();
        backgroundColor = Consts.getValue("BACKGROUND_COLOR");
    }
}
