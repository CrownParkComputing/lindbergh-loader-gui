#include "mainwindow.h"
#include <QApplication>
#include <QDir>
#include <QFileInfo>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // Get the loader path (directory containing the executable)
    QString loaderPath = QFileInfo(argv[0]).absolutePath();
    loaderPath = QDir(loaderPath).absolutePath();
    
    // Go up one directory since we're in the build directory
    QDir dir(loaderPath);
    dir.cdUp();
    loaderPath = dir.absolutePath();
    
    MainWindow window(loaderPath);
    window.show();
    
    return app.exec();
}
