import com.meego 1.0
import QtQuick 1.0

PageStackWindow {
    id: pageStackWindow

    ListsPage {
        id: listsPage
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
    }

    EditPage {
        id: myEditPage
        onChangeView: {
            pageStackWindow.pageStack.pop(myMainPage);
        }
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
    }

    AboutPage {
        id: aboutPage
    }

    initialPage: myMainPage
}
