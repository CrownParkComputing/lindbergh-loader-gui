#ifndef SETTINGSDIALOG_H
#define SETTINGSDIALOG_H

#include <QDialog>
#include <QTableWidget>
#include <QPushButton>
#include <QMap>
#include "gamedata.h"

class SettingsDialog : public QDialog {
    Q_OBJECT

public:
    explicit SettingsDialog(const QString &loaderPath, QWidget *parent = nullptr);
    QMap<QString, GameInfo> getConfiguredGames() const { return configuredGames; }

private slots:
    void selectGamePath();
    void installGame();
    void saveSettings();

private:
    void setupUI();
    void loadSettings();
    void updateTable();
    bool copyGameFiles(const QString &gamePath);

    QTableWidget *gamesTable;
    QPushButton *saveButton;
    QPushButton *cancelButton;
    QMap<QString, GameInfo> configuredGames;
    QString loaderPath;
};

#endif // SETTINGSDIALOG_H
