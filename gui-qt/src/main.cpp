#include "mainwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setStyle("Fusion");  // Use Fusion style for better look
    
    MainWindow window;
    window.show();
    
    return app.exec();
}
