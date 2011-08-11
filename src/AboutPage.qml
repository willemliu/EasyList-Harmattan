import com.meego 1.0
import QtQuick 1.1

Page {
    id: aboutPage

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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "EasyList - About"
            font.pointSize: 30
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
        font.pointSize: 24
        text: "Created with Qt"
    }
    Text {
        id: text3
        anchors.top: text2.bottom
        anchors.horizontalCenter: text2.horizontalCenter
        font.family: "Helvetica"
        font.pointSize: 24
        text: "Created by <a href='http://willemliu.nl/donate/'>Willem Liu</a>"
        onLinkActivated: {
            Qt.openUrlExternally(link);
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
    }
}
