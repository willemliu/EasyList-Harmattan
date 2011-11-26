import com.nokia.meego 1.0
import QtQuick 1.0
import "ezConsts.js" as Consts

Item {
    id: listItem
    signal checkChanged
    property string itemIndex: "0"
    property string itemText: "No text"
    property string itemSelected: "false"
    property string backgroundColor: Consts.getValue("LIST_ITEM_BACKGROUND_COLOR")

    Rectangle {
        id: backgroundRect
        color: backgroundColor
        anchors.fill: parent

        Rectangle {
            id: divisionLine
            color: Consts.getValue("DIVISION_LINE_COLOR")
            height: 1
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }
}
