#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QObject>

class MainWindow : public QObject
{
    Q_OBJECT

public:
    MainWindow(QObject *rootObject);
    ~MainWindow();
};

#endif // MAINWINDOW_H
