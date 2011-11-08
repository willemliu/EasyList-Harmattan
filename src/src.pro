QT += core declarative
TEMPLATE = app
CONFIG += meegotouch
TARGET = "easylist"
DEPENDPATH += .
INCLUDEPATH += .

# Input
HEADERS += mainwindow.h
SOURCES += main.cpp mainwindow.cpp
#FORMS#

unix {
  #VARIABLES
  isEmpty(PREFIX) {
    PREFIX = /usr
  }
  BINDIR = $$PREFIX/bin
  DATADIR =$$PREFIX/share

  DEFINES += DATADIR=\\\"$$DATADIR\\\" PKGDATADIR=\\\"$$PKGDATADIR\\\"

  #MAKE INSTALL

  INSTALLS += target qmlgui js splash desktop service iconxpm icon26 icon48 icon64

  target.path =$$BINDIR

  qmlgui.path = $$DATADIR/easylist
  qmlgui.files += easylist.qml
  qmlgui.files += MainPage.qml
  qmlgui.files += EditPage.qml
  qmlgui.files += ListItem.qml
  qmlgui.files += AboutPage.qml
  qmlgui.files += ListsPage.qml
  qmlgui.files += ListsItemDelegate.qml
  qmlgui.files += ListItemDelegate.qml
  qmlgui.files += SettingsPage.qml

  js.path = $$DATADIR/easylist
  js.files += mainPageDb.js
  js.files += editPageDb.js
  js.files += settingsDb.js
  js.files += listsDb.js
  js.files += db.js
  js.files += ezConsts.js

  splash.path = $$DATADIR/easylist
  splash.files += splash.jpg
  splash.files += splash-p.jpg

  desktop.path = $$DATADIR/applications
  desktop.files += $${TARGET}.desktop

  service.path = $$DATADIR/dbus-1/services/
  service.files += com.meego.$${TARGET}.service

  iconxpm.path = $$DATADIR/pixmap
  iconxpm.files += ../data/maemo/$${TARGET}.xpm

  icon26.path = $$DATADIR/icons/hicolor/26x26/apps
  icon26.files += ../data/26x26/$${TARGET}.png

  icon48.path = $$DATADIR/icons/hicolor/48x48/apps
  icon48.files += ../data/48x48/$${TARGET}.png

  icon64.path = $$DATADIR/icons/hicolor/64x64/apps
  icon64.files += ../data/64x64/$${TARGET}.png
}


unix:!symbian:!maemo5 {
    target.path = /opt/easylist/bin
    INSTALLS += target
}

unix:!symbian:!maemo5 {
    icon.files = easylist.png
    icon.path = $$DATADIR/icons/hicolor/64x64/apps
    INSTALLS += icon
}

RESOURCES += \
    resources.qrc

TRANSLATIONS += \
    qml-translations.de.ts \
    qml-translations.en.ts \
    qml-translations.fr.ts \
    qml-translations.nl.ts \
    qml-translations.ru.ts \
    qml-translations.tr.ts 
