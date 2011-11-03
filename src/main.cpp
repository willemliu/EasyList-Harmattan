#include <QApplication>
#include <QDeclarativeContext>
#include <QDeclarativeView>
#include <QTranslator>
#include <QLocale>
#include <QtGui/QApplication>
#include "mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QString locale = QLocale::system().name();

    QTranslator translator;

    /* the ":/" is a special directory Qt uses to
     * distinguish resources;
     * NB this will look for a filename matching locale + ".qm";
     * if that's not found, it will truncate the locale to
     * the first two characters (e.g. "en_GB" to "en") and look
     * for that + ".qm"; if not found, it will look for a
     * qml-translations.qm file; if not found, no translation is done
     */
    if (translator.load("qml-translations." + locale, ":/"))
      app.installTranslator(&translator);

    QDeclarativeView view;
    view.setSource(QUrl::fromLocalFile("/usr/share/easylist/easylist.qml"));
    QObject *rootObject = (QObject*)(view.rootObject());
    MainWindow p(rootObject);
    view.rootContext()->setContextProperty("MainWindow", &p);
    view.showFullScreen();
    return app.exec();
}
