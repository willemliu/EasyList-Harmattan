import com.nokia.meego 1.0
import QtQuick 1.0

PageStackWindow {
    id: pageStackWindow

    MainPage {
        id: myMainPage
        onHideToolbar: {
            pageStackWindow.showToolBar = !hideToolbar;
        }
    }

    initialPage: myMainPage
}
