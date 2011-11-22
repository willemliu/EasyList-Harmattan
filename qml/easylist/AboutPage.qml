import com.nokia.meego 1.0
import QtQuick 1.1
import "settingsDb.js" as SettingsDb

Page {
    id: aboutPage
    property color backgroundColor: SettingsDb.getValue("BACKGROUND_COLOR")
    property color headerBackgroundColor: SettingsDb.getValue("HEADER_BACKGROUND_COLOR")
    property color headerTextColor: SettingsDb.getValue("HEADER_TEXT_COLOR")
    property color textColor: SettingsDb.getValue("TEXT_COLOR")
    orientationLock: SettingsDb.getOrientationLock();
    property string version: "0.0.21";

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
                text: qsTr("EasyList - About")
                font.pixelSize: 32
                color: headerTextColor
            }
        }

        onHeightChanged: {
            flick.height = height;
        }

        Flickable {
            id: flick
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            contentHeight: content.implicitHeight
            contentWidth: content.implicitWidth
            flickableDirection: Flickable.VerticalFlick
            //clip: true

            Rectangle {
                id: content
                implicitWidth: flick.width
                implicitHeight: 600
                color: backgroundColor
                Text {
                    id: text1
                    anchors.top: parent.top
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
                    text: qsTr("Created with Qt")
                    color: textColor
                }
                Text {
                    id: text4
                    anchors.top: text3.bottom
                    anchors.horizontalCenter: text3.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: qsTr("Created by <a href='http://willemliu.nl/donate/'>Willem Liu</a>")
                    onLinkActivated: {
                        Qt.openUrlExternally(link);
                    }
                    color: textColor
                }
                Text {
                    id: text5
                    anchors.top: text4.bottom
                    anchors.horizontalCenter: text4.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: qsTr("Thanks to:")
                    color: textColor
                }
                Text {
                    id: text6
                    anchors.top: text5.bottom
                    anchors.horizontalCenter: text5.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: "Oytun Eren Şengül"
                    color: textColor
                }
                Text {
                    id: text7
                    anchors.top: text6.bottom
                    anchors.horizontalCenter: text6.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: "Stanislav"
                    color: textColor
                }
                Text {
                    id: text8
                    anchors.top: text7.bottom
                    anchors.horizontalCenter: text7.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: "Romu"
                    color: textColor
                }
                Text {
                    id: text9
                    anchors.top: text8.bottom
                    anchors.horizontalCenter: text8.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: "Stephan Beyerle"
                    color: textColor
                }
                Text {
                    id: text10
                    anchors.top: text9.bottom
                    anchors.horizontalCenter: text9.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: "Giovanni Grammatico"
                    color: textColor
                }
                Text {
                    id: text11
                    anchors.top: text10.bottom
                    anchors.horizontalCenter: text10.horizontalCenter
                    font.family: "Helvetica"
                    font.pointSize: 24
                    text: "Arto Jalkanen"
                    color: textColor
                }
            }
        }
    }

    QueryDialog {
        id: removeDialog
        titleText: qsTr("Drop tables?")
        message: qsTr("Do you really want to remove all tables used by EasyList?")
        acceptButtonText: qsTr("Ok")
        rejectButtonText: qsTr("Cancel")
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
