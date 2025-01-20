#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTableWidget>
#include <QPlainTextEdit>
#include <QPushButton>
#include <QLabel>
#include <QProcess>
#include <QHeaderView>
#include "gamedata.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(const QString &loaderPath, QWidget *parent = nullptr);
    ~MainWindow();

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;

private slots:
    void showSettings();
    void launchGame(const QString &gameKey, bool testMode);
    void editConfig(const QString &gameKey);
    void clearConsole();
    void handleProcessOutput();
    void handleProcessError(QProcess::ProcessError error);

private:
    void loadSettings();
    void updateGameTable();
    bool checkSetup();
    void appendToConsole(const QString &text, bool error = false);

    QString loaderPath;
    QTableWidget *gameTable;
    QPlainTextEdit *consoleOutput;
    QMap<QString, GameInfo> configuredGames;
    QProcess *gameProcess;
    QString currentGameKey;
    QPoint dragPosition;
};

#endif // MAINWINDOW_H
