import com.meego 1.0
import QtQuick 1.0
import "settingsDb.js" as SettingsDb
import "ezConsts.js" as Consts

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
    }

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: Consts.HEADER_BACKGROUND_COLOR
        z: 1
        Label {
            id: title
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            text: "EasyList - Settings"
            font.pixelSize: 32
            color: Consts.HEADER_TEXT_COLOR
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
                color: Consts.DIVISION_LINE
                height: 1
                anchors.verticalCenter: sortingLabel.verticalCenter
                anchors.leftMargin: 10
                anchors.left: parent.left
                anchors.rightMargin: 5
                anchors.right: sortingLabel.left
            }
            Label {
                id: sortingLabel
                text: "Sort"
                font.pointSize: 26
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 10
                color: Consts.DIVISION_LINE_TEXT
            }

            // Sort alphabetically
            Label {
                id: sortLabel
                text: "Alphabetically:"
                font.pointSize: 26
                anchors.verticalCenter: sortSwitch.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            Switch {
                id: sortSwitch
                anchors.topMargin: 10
                anchors.top: sortingLabel.bottom
                anchors.right: parent.right
                anchors.rightMargin: 10
                checked: {getBooleanProperty(SettingsDb.propSort);}
                onCheckedChanged: {
                    saveBooleanProperty(SettingsDb.propSort, checked);
                }
            }

            // Sort selected items
            Label {
                id: sortSelectedLabel
                text: "Checked items to bottom:"
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
                color: Consts.DIVISION_LINE
                height: 1
                anchors.verticalCenter: orientationLabel.verticalCenter
                anchors.leftMargin: 10
                anchors.left: parent.left
                anchors.rightMargin: 5
                anchors.right: orientationLabel.left
            }
            Label {
                id: orientationLabel
                text: "Orientation"
                font.pointSize: 26
                anchors.right: parent.right
                anchors.top: sortSelectedSwitch.bottom
                anchors.topMargin: 10;
                anchors.rightMargin: 10
                color: Consts.DIVISION_LINE_TEXT
            }

            ButtonRow {
                anchors.topMargin: 10;
                anchors.top: orientationLabel.bottom
                anchors.leftMargin: 10;
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 10
                Button {
                    id: lockPortraitButton
                    text: "Portrait"
                    checkable: true
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
                    onClicked: {
                        lockLandscapeButton.checked = false;
                        autoOrientationButton.checked = false;
                        settingsPage.orientationLock = PageOrientation.LockPortrait;
                        SettingsDb.setProperty(SettingsDb.propOrientationLock, "Portrait");
                    }
                }
                Button {
                    id: lockLandscapeButton
                    text: "Landscape"
                    checkable: true
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
                    onClicked: {
                        lockPortraitButton.checked = false;
                        autoOrientationButton.checked = false;
                        settingsPage.orientationLock = PageOrientation.LockLandscape;
                        SettingsDb.setProperty(SettingsDb.propOrientationLock, "Landscape");
                    }
                }
                Button {
                    id: autoOrientationButton
                    text: "Auto"
                    checkable: true
                    checked: {
                        if(SettingsDb.getProperty(SettingsDb.propOrientationLock) == "Automatic")
                        {
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                    onClicked: {
                        lockPortraitButton.checked = false;
                        lockLandscapeButton.checked = false;
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
