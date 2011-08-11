import com.meego 1.0
import QtQuick 1.1

PageStackWindow {
    id: pageStackWindow

    MainPage {
        id: myMainPage
        onChangeView: {
            pageStackWindow.pageStack.push(myEditPage);
            myEditPage.reloadDb();
        }
        onAboutView: {
            pageStackWindow.pageStack.push(aboutPage);
        }
    }

    EditPage {
        id: myEditPage
        onChangeView: {
            pageStackWindow.pageStack.pop(myMainPage);
            myMainPage.reloadDb();
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
