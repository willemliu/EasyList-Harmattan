import com.meego 1.0
import QtQuick 1.0
import "settingsDb.js" as SettingsDb

Page {
    id: aboutPage
    property color backgroundColor: SettingsDb.getValue("BACKGROUND_COLOR")
    property color headerBackgroundColor: SettingsDb.getValue("HEADER_BACKGROUND_COLOR")
    property color headerTextColor: SettingsDb.getValue("HEADER_TEXT_COLOR")
    property color textColor: SettingsDb.getValue("TEXT_COLOR")
    orientationLock: SettingsDb.getOrientationLock();
    property string version: "0.0.16";

    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent
        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 70
            color: headerBackgroundColor
            z: 10
            Label {
                id: title
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 20
                text: "EasyList - About"
                font.pixelSize: 32
                color: headerTextColor
            }
        }

        Text {
            id: text1
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Helvetica"
            font.pointSize: 48
            text: "<a href='http://willemliu.nl/donate/'>EasyList</a>"
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
            color: textColor
        }
        Text {
            id: text2
            anchors.top: text1.bottom
            anchors.horizontalCenter: text1.horizontalCenter
            font.family: "Helvetica"
            font.pointSize: 16
            text: version
            color: textColor
        }
        Text {
            id: text3
            anchors.top: text2.bottom
            anchors.horizontalCenter: text2.horizontalCenter
            font.family: "Helvetica"
            font.pointSize: 24
            text: "Created with Qt"
            color: textColor
        }
        Text {
            id: text4
            anchors.top: text3.bottom
            anchors.horizontalCenter: text3.horizontalCenter
            font.family: "Helvetica"
            font.pointSize: 24
            text: "Created by <a href='http://willemliu.nl/donate/'>Willem Liu</a>"
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
            color: textColor
        }
    }

    QueryDialog {
        id: removeDialog
        titleText: "Drop tables?"
        message: "Do you really want to remove all tables used by EasyList?"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        onAccepted: {
            SettingsDb.removeTables();
        }
    }

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
        ToolIcon {
            iconId: "toolbar-delete";
            onClicked: {
                removeDialog.open();
            }
        }
    }

    function loadTheme()
    {
        SettingsDb.loadTheme();
        backgroundColor = SettingsDb.getValue("BACKGROUND_COLOR");
        headerBackgroundColor = SettingsDb.getValue("HEADER_BACKGROUND_COLOR");
        headerTextColor = SettingsDb.getValue("HEADER_TEXT_COLOR");
        textColor = SettingsDb.getValue("TEXT_COLOR");
    }
}
