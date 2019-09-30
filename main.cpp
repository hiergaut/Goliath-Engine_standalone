#include <gui/MainWindow.h>

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    w.loadLastSession();
    return a.exec();
}
