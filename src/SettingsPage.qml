import com.meego 1.0
import QtQuick 1.0
import "settingsDb.js" as SettingsDb

Page {
    id: settingsPage
    signal aboutView
    orientationLock: SettingsDb.getOrientationLock();

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
        ToolIcon {
            iconId: "invitation-pending";
            onClicked: {
                helpDialog.open();
            }
        }
        ToolIcon {
            iconId: "toolbar-view-menu";
            onClicked: {
                if(myMenu.status == DialogStatus.Closed)
                {
                    myMenu.open();
                }
                else {
                    myMenu.close();
                }
            }
        }
    }

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: "#333"
        z: 1
        Label {
            id: title
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            text: "EasyList - Settings"
            font.pixelSize: 32
            color: "#fff"
        }
    }

    Flickable {
        id: flick
        anchors.top: header.bottom
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: optionsRectangle.implicitHeight
        contentWidth: optionsRectangle.implicitWidth
        flickableDirection: Flickable.VerticalFlick

        Rectangle {
            id: optionsRectangle
            width: flick.width

            // Division line
            Rectangle {
                id: sortingDivisionLine
                color: "#666"
                height: 1
                anchors.rightMargin: 5
                anchors.verticalCenter: sortingLabel.verticalCenter
                anchors.left: parent.left
                anchors.right: sortingLabel.left
            }
            Label {
                id: sortingLabel
                text: "Sort"
                font.pointSize: 26
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 20
                color: "#666";
            }

            // Sort alphabetically
            Label {
                id: sortLabel
                text: "Sort alphabetically:"
                font.pointSize: 26
                anchors.verticalCenter: sortSwitch.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            Switch {
                id: sortSwitch
                anchors.topMargin: 10
                anchors.top: sortingLabel.bottom
                anchors.right: parent.right
                anchors.rightMargin: 20
                checked: {getBooleanProperty(SettingsDb.propSort);}
                onCheckedChanged: {
                    saveBooleanProperty(SettingsDb.propSort, checked);
                }
            }

            // Sort selected items
            Label {
                id: sortSelectedLabel
                text: "Sort selected items to bottom:"
                font.pointSize: 26
                anchors.verticalCenter: sortSelectedSwitch.verticalCenter
                anchors.left: sortLabel.left
            }
            Switch {
                id: sortSelectedSwitch
                anchors.topMargin: 10;
                anchors.top: sortSwitch.bottom
                anchors.right: sortSwitch.right
                checked: {getBooleanProperty(SettingsDb.propSortSelected);}
                onCheckedChanged: {
                    saveBooleanProperty(SettingsDb.propSortSelected, checked);
                }
            }

            // Division line
            Rectangle {
                id: orientationDivisionLine
                color: "#666"
                height: 1
                anchors.verticalCenter: orientationLabel.verticalCenter
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.right: orientationLabel.left
            }
            Label {
                id: orientationLabel
                text: "Orientation"
                font.pointSize: 26
                anchors.right: parent.right
                anchors.top: sortSelectedSwitch.bottom
                anchors.topMargin: 10;
                anchors.rightMargin: 20
                color: "#666"
            }

            // Orientation lock portrait
            Label {
                id: lockPortraitLabel
                text: "Lock portrait:"
                font.pointSize: 26
                anchors.verticalCenter: lockPortraitSwitch.verticalCenter
                anchors.left: sortLabel.left
            }
            Switch {
                id: lockPortraitSwitch
                anchors.topMargin: 10;
                anchors.top: orientationLabel.bottom
                anchors.right: sortSwitch.right
                checked: {
                    if(SettingsDb.getProperty(SettingsDb.propOrientationLock) == "Portrait")
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                onCheckedChanged: {
                    if(checked)
                    {
                        lockLandscapeSwitch.checked = false;
                        settingsPage.orientationLock = PageOrientation.LockPortrait;
                        SettingsDb.setProperty(SettingsDb.propOrientationLock, "Portrait");
                    }
                    else
                    {
                        settingsPage.orientationLock = PageOrientation.Automatic;
                        SettingsDb.setProperty(SettingsDb.propOrientationLock, "Automatic");
                    }
                }
            }

            // Orientation lock landscape
            Label {
                id: lockLandscapeLabel
                text: "Lock landscape:"
                font.pointSize: 26
                anchors.verticalCenter: lockLandscapeSwitch.verticalCenter
                anchors.left: sortLabel.left
            }
            Switch {
                id: lockLandscapeSwitch
                anchors.topMargin: 10;
                anchors.top: lockPortraitSwitch.bottom
                anchors.right: sortSwitch.right
                checked: {
                    if(SettingsDb.getProperty(SettingsDb.propOrientationLock) == "Landscape")
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                onCheckedChanged: {
                    if(checked)
                    {
                        lockPortraitSwitch.checked = false;
                        settingsPage.orientationLock = PageOrientation.LockLandscape;
                        SettingsDb.setProperty(SettingsDb.propOrientationLock, "Landscape");
                    }
                    else
                    {
                        settingsPage.orientationLock = PageOrientation.Automatic;
                        SettingsDb.setProperty(SettingsDb.propOrientationLock, "Automatic");
                    }
                }
            }
        }
    }
    ScrollDecorator {
        flickableItem: flick
    }

    QueryDialog {
        id: helpDialog
        titleText: "Help"
        message: "Auto-orientation can be obtained by turning all orientation locks off!"
        acceptButtonText: "Ok"
    }

    Menu {
        id: myMenu
        MenuLayout {
            MenuItem {
                text: "Back";
                onClicked: {
                    pageStack.pop();
                }
            }
            MenuItem {
                text: "About";
                onClicked: {
                    onClicked: settingsPage.aboutView()
                }
            }
        }
    }

    function saveBooleanProperty(propertyName, booleanValue)
    {
        if(booleanValue)
        {
            SettingsDb.setProperty(propertyName, "true");
        }
        else
        {
            SettingsDb.setProperty(propertyName, "false");
        }
    }

    function getBooleanProperty(propertyName)
    {
        if(SettingsDb.getProperty(propertyName) == "true")
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    function reloadDb()
    {
        SettingsDb.loadSettingsDb();
    }

    function saveSettings()
    {
    }

    onVisibleChanged: {
        if(visible)
        {
            reloadDb();
        }
    }
}
