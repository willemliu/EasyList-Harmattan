import com.meego 1.0
import QtQuick 1.1

Item {
    id: listItem
    signal checkChanged
    property string itemIndex: "0"
    property string itemText: "No text"
    property string itemSelected: "false"
    height: 55

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
    Text {
        id: checkBoxText
        text: getText()
        font.family: "Helvetica"
        font.pointSize: 22
        anchors.left: checkBox.right
        anchors.verticalCenter: checkBox.verticalCenter
    }

    Rectangle {
        id: divisionLine
        color: "#ccc"
        height: 1
        anchors.top: checkBox.bottom
        anchors.left: parent.left
        anchors.right: parent.right
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
