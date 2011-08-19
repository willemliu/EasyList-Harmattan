import com.meego 1.0
import QtQuick 1.0
import "settingsDb.js" as SettingsDb

PageStackWindow {
    id: pageStackWindow

    ListsPage {
        id: listsPage
    }

    SettingsPage {
        id: settingsPage
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
        onOrientationLockChanged: {
            listsPage.orientationLock = orientationLock;
            myMainPage.orientationLock = orientationLock;
            myEditPage.orientationLock = orientationLock;
            aboutPage.orientationLock = orientationLock;
        }
    }

    MainPage {
        id: myMainPage
        onChangeView: {
            pageStackWindow.pageStack.push(myEditPage);
        }
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
        onListsView: {
            pageStackWindow.pageStack.push(listsPage);
        }
        onSettingsView: {
            pageStackWindow.pageStack.push(settingsPage);
        }
    }

    EditPage {
        id: myEditPage
        onChangeView: {
            pageStackWindow.pageStack.pop(myMainPage);
        }
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
        onSettingsView: {
            pageStackWindow.pageStack.push(settingsPage);
        }
    }

    AboutPage {
        id: aboutPage
    }

    initialPage: myMainPage
}
