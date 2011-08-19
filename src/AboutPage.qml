import com.meego 1.0
import QtQuick 1.0
import "settingsDb.js" as SettingsDb

Page {
    id: aboutPage
    orientationLock: SettingsDb.getOrientationLock();
    property string version: "0.0.7";

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: "#333"
        z: 1
        Text {
            id: title
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            text: "EasyList - About"
            font.pointSize: 26
            color: "#fff"
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
    }
    Text {
        id: text2
        anchors.top: text1.bottom
        anchors.horizontalCenter: text1.horizontalCenter
        font.family: "Helvetica"
        font.pointSize: 16
        text: version
    }
    Text {
        id: text3
        anchors.top: text2.bottom
        anchors.horizontalCenter: text2.horizontalCenter
        font.family: "Helvetica"
        font.pointSize: 24
        text: "Created with Qt"
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
}
