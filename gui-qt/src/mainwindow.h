#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTableWidget>
#include <QPushButton>
#include <QLabel>
#include <QProcess>
#include <QSettings>
#include <QCheckBox>
#include <QMap>
#include <QPlainTextEdit>
#include "gamedata.h"

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void showSetup();
    void showSettings();
    void removeGame(const QString &gameKey);
    void launchGame(const QString &gameKey, bool testMode);
    void editConfig(const QString &gameKey);
    void handleProcessOutput();
    void handleProcessError(QProcess::ProcessError error);
    void clearConsole();

private:
    void setupUI();
    void loadGames();
    void saveGames();
    void updateGameTable();
    bool checkSetup();
    void appendToConsole(const QString &text, bool error = false);

    QTableWidget *gameTable;
    QPushButton *setupButton;
    QPushButton *settingsButton;
    QPushButton *clearConsoleButton;
    QLabel *statusLabel;
    QPlainTextEdit *consoleOutput;
    QProcess *gameProcess;
    QMap<QString, GameInfo> configuredGames;
    QString loaderPath;
    QString currentGameKey;
};

#endif // MAINWINDOW_H
