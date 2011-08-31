import com.meego 1.0
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
        CheckBox {
            id: checkBox
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            checked: {
                if(itemSelected == "true")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            onClicked: {
                if(checkBox.checked)
                {
                    itemSelected = "true";
                }
                else
                {
                    itemSelected = "false";
                }
                checkBoxText.text = getText();
                checkChanged();
            }
        }
        Label {
            id: checkBoxText
            text: getText()
            font.pixelSize: 26
            color: Consts.getValue("LIST_ITEM_TEXT_COLOR")
            anchors.left: checkBox.right
            anchors.verticalCenter: checkBox.verticalCenter
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

    function getText()
    {
        if(itemSelected == "true")
        {
            checkBoxText.font.strikeout = true;
            return itemText;
        }
        else
        {
            return itemText;
        }
    }
}
