#ifndef SETTINGSDIALOG_H
#define SETTINGSDIALOG_H

#include <QDialog>
#include <QTableWidget>
#include <QPushButton>
#include <QMap>
#include "gamedata.h"

class SettingsDialog : public QDialog
{
    Q_OBJECT

public:
    explicit SettingsDialog(const QString &loaderPath, QWidget *parent = nullptr);
    QMap<QString, GameInfo> getConfiguredGames() const;

private slots:
    void selectGamePath();
    void installGame();
    void saveSettings();

private:
    void loadSettings();
    void updateGameTable();
    bool copyGameFiles(const QString &gamePath);

    QTableWidget *gameTable;
    QString loaderPath;
    QMap<QString, GameInfo> configuredGames;
};

#endif // SETTINGSDIALOG_H
