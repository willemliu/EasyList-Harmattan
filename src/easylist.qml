import com.meego 1.0
import QtQuick 1.0
import "settingsDb.js" as SettingsDb

PageStackWindow {
    id: pageStackWindow

    ListsPage {
        id: listsPage
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
        onSettingsView: {
            pageStackWindow.pageStack.push(settingsPage);
        }
        onHideToolbar: {
            pageStackWindow.showToolBar = !hideToolbar;
        }
    }

    SettingsPage {
        id: settingsPage
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
        onOrientationLockChanged: {
            listsPage.orientationLock = orientationLock;
            myMainPage.orientationLock = orientationLock;
            aboutPage.orientationLock = orientationLock;
        }
    }

    MainPage {
        id: myMainPage
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
        onListsView: {
            pageStackWindow.pageStack.push(listsPage);
        }
        onSettingsView: {
            pageStackWindow.pageStack.push(settingsPage);
        }
        onHideToolbar: {
            pageStackWindow.showToolBar = !hideToolbar;
        }
    }

    AboutPage {
        id: aboutPage
    }

    initialPage: myMainPage
}
