#include <QApplication>
#include <QDeclarativeContext>
#include <QDeclarativeView>

#include "mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;
    view.setSource(QUrl::fromLocalFile("/usr/share/easylist/easylist.qml"));
    QObject *rootObject = (QObject*)(view.rootObject());
    MainWindow p(rootObject);
    view.rootContext()->setContextProperty("MainWindow", &p);
    view.showFullScreen();
    return app.exec();
}
