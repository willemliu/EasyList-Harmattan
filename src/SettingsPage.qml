import com.meego 1.0
import QtQuick 1.1
import "settingsDb.js" as SettingsDb

Page {
    id: settingsPage
    signal aboutView
    signal themeChanged
    property color backgroundColor: SettingsDb.getValue("BACKGROUND_COLOR")
    property color headerBackgroundColor: SettingsDb.getValue("HEADER_BACKGROUND_COLOR")
    property color headerTextColor: SettingsDb.getValue("HEADER_TEXT_COLOR")
    property color divisionLineColor: SettingsDb.getValue("DIVISION_LINE_COLOR")
    property color divisionLineTextColor: SettingsDb.getValue("DIVISION_LINE_TEXT_COLOR")
    property color textColor: SettingsDb.getValue("TEXT_COLOR")
    orientationLock: SettingsDb.getOrientationLock();

    tools: ToolBarLayout {
        id: myToolbar
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                settingsPage.save();
            }
        }
        ToolIcon {
            iconId: "invitation-pending";
            onClicked: {
                helpDialog.open();
            }
        }
    }

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
                text: "EasyList - Settings"
                font.pixelSize: 32
                color: headerTextColor
            }
        }

        onHeightChanged: {
            flick.height = height;
        }

        ListModel {
            id: listModel
        }

        SelectionDialog {
            id: singleSelectionDialog
            titleText: "Themes"

            model: {
                listModel.clear();
                for(var i = 0; i < SettingsDb.THEME_NAMES.length; ++i)
                {
                    listModel.append({name: SettingsDb.THEME_NAMES[i]});
                }
                return listModel;
            }
            onSelectedIndexChanged: {
                if(SettingsDb.THEME != listModel.get(selectedIndex).name)
                {
                    SettingsDb.THEME = listModel.get(selectedIndex).name;
                    SettingsDb.setProperty(SettingsDb.propTheme, SettingsDb.THEME);
                    themeChanged();
                }
            }
            onVisibleChanged: {
                if(visible)
                {
                    for(var i = 0; i < listModel.count; ++i)
                    {
                        if(listModel.get(i).name == SettingsDb.THEME)
                        {
                            singleSelectionDialog.selectedIndex = i;
                            break;
                        }
                    }
                }
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
            clip: true

            Rectangle {
                id: optionsRectangle
                implicitWidth: flick.width
                implicitHeight: 710
                color: backgroundColor

                // Division line
                Rectangle {
                    id: sortingDivisionLine
                    color: divisionLineColor
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
                    color: divisionLineTextColor
                }

                // Sort alphabetically
                Label {
                    id: sortLabel
                    text: "Alphabetically:"
                    font.pointSize: 26
                    anchors.verticalCenter: sortSwitch.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    color: textColor
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
                    color: textColor
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
                    color: divisionLineColor
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
                    color: divisionLineTextColor
                }

                ButtonRow {
                    id: orientationButtonRow
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

                // Division line
                Rectangle {
                    id: themeDivisionLine
                    color: divisionLineColor
                    height: 1
                    anchors.verticalCenter: themeLabel.verticalCenter
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                    anchors.rightMargin: 5
                    anchors.right: themeLabel.left
                }
                Label {
                    id: themeLabel
                    text: "Theme"
                    font.pointSize: 26
                    anchors.right: parent.right
                    anchors.top: orientationButtonRow.bottom
                    anchors.topMargin: 10;
                    anchors.rightMargin: 10
                    color: divisionLineTextColor
                }

                Button {
                    id: themeButton
                    anchors.left: parent.left
                    anchors.leftMargin: 10;
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.top: themeLabel.bottom
                    anchors.topMargin: 10;
                    text: "Select Theme..."
                    onClicked: {
                        singleSelectionDialog.open();
                    }
                }
                // Division line
                Rectangle {
                    id: syncDivisionLine
                    color: divisionLineColor
                    height: 1
                    anchors.verticalCenter: syncLabel.verticalCenter
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                    anchors.rightMargin: 5
                    anchors.right: syncLabel.left
                }
                Label {
                    id: syncLabel
                    text: "Sync"
                    font.pointSize: 26
                    anchors.right: parent.right
                    anchors.top: themeButton.bottom
                    anchors.topMargin: 10;
                    anchors.rightMargin: 10
                    color: divisionLineTextColor
                }

                Label {
                    id: syncSourceLabel
                    text: "Source:"
                    font.pointSize: 26
                    anchors.topMargin: 10
                    anchors.top: syncLabel.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    color: textColor
                }
                TextField {
                    id: syncSourceTextField
                    text: SettingsDb.getProperty(SettingsDb.propSyncUrl);
                    anchors.topMargin: 5
                    anchors.top: syncSourceLabel.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 10;
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    focus: true
                    inputMethodHints: Qt.ImhNoPredictiveText
                }

                Label {
                    id: usernameLabel
                    text: "Username:"
                    font.pointSize: 26
                    anchors.topMargin: 10
                    anchors.top: syncSourceTextField.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    color: textColor
                }
                TextField {
                    id: syncUsernameTextField
                    text: SettingsDb.getProperty(SettingsDb.propSyncUsername);
                    anchors.topMargin: 5
                    anchors.top: usernameLabel.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 10;
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    focus: true
                    inputMethodHints: Qt.ImhNoPredictiveText
                }

                Label {
                    id: passwordLabel
                    text: "Password:"
                    font.pointSize: 26
                    anchors.topMargin: 10
                    anchors.top: syncUsernameTextField.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    color: textColor
                }
                TextField {
                    id: syncPasswordTextField
                    echoMode: TextInput.Password
                    anchors.topMargin: 10
                    anchors.top: passwordLabel.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 10;
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    focus: true
                    inputMethodHints: Qt.ImhNoPredictiveText
                }
                Button {
                    id: saveSettingsButton
                    text: "Save";
                    anchors.topMargin: 10
                    anchors.top: syncPasswordTextField.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 10;
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    onClicked: {
                        settingsPage.save();
                    }
                }
            }
        }
        ScrollDecorator {
            flickableItem: flick
        }
    }

    QueryDialog {
        id: helpDialog
        titleText: "Synchronization"
        message: "When you've setup your synchronization account then you'll be able to synchronize your list with your online list.\n\nYou can create your online account on http://easylist.willemliu.nl.\nDefault sync URL is: http://easylist.willemliu.nl/getList.php"
        acceptButtonText: "Ok"
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

    function loadTheme()
    {
        SettingsDb.loadTheme();
        backgroundColor = SettingsDb.getValue("BACKGROUND_COLOR");
        headerBackgroundColor = SettingsDb.getValue("HEADER_BACKGROUND_COLOR");
        headerTextColor = SettingsDb.getValue("HEADER_TEXT_COLOR");
        divisionLineColor = SettingsDb.getValue("DIVISION_LINE_COLOR");
        divisionLineTextColor = SettingsDb.getValue("DIVISION_LINE_TEXT_COLOR");
        textColor = SettingsDb.getValue("TEXT_COLOR");
    }

    function save()
    {
        SettingsDb.setProperty(SettingsDb.propSyncUrl, syncSourceTextField.text);
        SettingsDb.setProperty(SettingsDb.propSyncUsername, syncUsernameTextField.text);
        if(syncPasswordTextField.text.length > 0)
        {
            SettingsDb.setProperty(SettingsDb.propSyncPassword, Qt.md5(syncPasswordTextField.text));
        }
        pageStack.pop();
    }

    onVisibleChanged: {
        if(visible)
        {
            reloadDb();
        }
    }
}
