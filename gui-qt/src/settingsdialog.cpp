#include "settingsdialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QHeaderView>
#include <QFileDialog>
#include <QSettings>
#include <QMessageBox>
#include <QFile>
#include <QDir>

SettingsDialog::SettingsDialog(const QString &sourcePath, QWidget *parent)
    : QDialog(parent)
    , loaderPath(sourcePath)
{
    setupUI();
    loadSettings();
}

void SettingsDialog::setupUI()
{
    setWindowTitle(tr("Lindbergh Game Settings"));
    setMinimumSize(800, 600);

    QVBoxLayout *mainLayout = new QVBoxLayout(this);

    // Create games table
    gamesTable = new QTableWidget(this);
    gamesTable->setColumnCount(6);
    gamesTable->setHorizontalHeaderLabels({
        tr("Game Name"),
        tr("Code"),
        tr("DVP Code"),
        tr("Path"),
        tr("Configure"),
        tr("Install")
    });
    gamesTable->horizontalHeader()->setSectionResizeMode(0, QHeaderView::Stretch);
    gamesTable->horizontalHeader()->setSectionResizeMode(1, QHeaderView::ResizeToContents);
    gamesTable->horizontalHeader()->setSectionResizeMode(2, QHeaderView::ResizeToContents);
    gamesTable->horizontalHeader()->setSectionResizeMode(3, QHeaderView::Stretch);
    gamesTable->horizontalHeader()->setSectionResizeMode(4, QHeaderView::ResizeToContents);
    gamesTable->horizontalHeader()->setSectionResizeMode(5, QHeaderView::ResizeToContents);
    gamesTable->setSelectionBehavior(QAbstractItemView::SelectRows);
    gamesTable->setEditTriggers(QAbstractItemView::NoEditTriggers);

    // Buttons
    QHBoxLayout *buttonLayout = new QHBoxLayout();
    saveButton = new QPushButton(tr("Save"), this);
    cancelButton = new QPushButton(tr("Cancel"), this);
    buttonLayout->addStretch();
    buttonLayout->addWidget(saveButton);
    buttonLayout->addWidget(cancelButton);

    mainLayout->addWidget(gamesTable);
    mainLayout->addLayout(buttonLayout);

    // Connect signals
    connect(saveButton, &QPushButton::clicked, this, &SettingsDialog::saveSettings);
    connect(cancelButton, &QPushButton::clicked, this, &QDialog::reject);
}

void SettingsDialog::loadSettings()
{
    QSettings settings("LindberghLoader", "GUI");
    configuredGames = GameDatabase::getDefaultGames();

    // Load saved paths
    settings.beginGroup("GamePaths");
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it) {
        it.value().path = settings.value(it.key()).toString();
    }
    settings.endGroup();

    updateTable();
}

void SettingsDialog::updateTable()
{
    gamesTable->setRowCount(configuredGames.size());
    int row = 0;
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it, ++row) {
        const GameInfo &game = it.value();
        
        gamesTable->setItem(row, 0, new QTableWidgetItem(game.name));
        gamesTable->setItem(row, 1, new QTableWidgetItem(game.code));
        gamesTable->setItem(row, 2, new QTableWidgetItem(game.dvpCode));
        gamesTable->setItem(row, 3, new QTableWidgetItem(game.path));

        // Path selection button
        QPushButton *selectButton = new QPushButton(tr("Select Path"), this);
        selectButton->setProperty("gameKey", it.key());
        connect(selectButton, &QPushButton::clicked, this, &SettingsDialog::selectGamePath);
        gamesTable->setCellWidget(row, 4, selectButton);

        // Install button
        QPushButton *installButton = new QPushButton(tr("Install"), this);
        installButton->setProperty("gameKey", it.key());
        installButton->setEnabled(!game.path.isEmpty());
        connect(installButton, &QPushButton::clicked, this, &SettingsDialog::installGame);
        gamesTable->setCellWidget(row, 5, installButton);
    }
}

void SettingsDialog::selectGamePath()
{
    QPushButton *button = qobject_cast<QPushButton*>(sender());
    if (!button) return;

    QString gameKey = button->property("gameKey").toString();
    if (!configuredGames.contains(gameKey)) return;

    QString dir = QFileDialog::getExistingDirectory(this, tr("Select Game Directory"));
    if (!dir.isEmpty()) {
        configuredGames[gameKey].path = dir;
        updateTable();
    }
}

void SettingsDialog::installGame()
{
    QPushButton *button = qobject_cast<QPushButton*>(sender());
    if (!button) return;

    QString gameKey = button->property("gameKey").toString();
    if (!configuredGames.contains(gameKey)) return;

    const GameInfo &game = configuredGames[gameKey];
    if (game.path.isEmpty()) {
        QMessageBox::warning(this, tr("Error"), tr("Please select a game path first."));
        return;
    }

    if (copyGameFiles(game.path)) {
        QMessageBox::information(this, tr("Success"), 
            tr("Game files installed successfully to %1").arg(game.path));
    } else {
        QMessageBox::critical(this, tr("Error"), 
            tr("Failed to install game files to %1").arg(game.path));
    }
}

bool SettingsDialog::copyGameFiles(const QString &gamePath)
{
    QDir gameDir(gamePath);
    if (!gameDir.exists()) {
        return false;
    }

    // Copy lindbergh.conf
    QFile confSrc(loaderPath + "/docs/lindbergh.conf");
    QFile confDst(gameDir.filePath("lindbergh.conf"));
    if (!confSrc.exists() || (confDst.exists() && !confDst.remove())) {
        return false;
    }
    if (!confSrc.copy(confDst.fileName())) {
        return false;
    }

    // Copy build files
    QDir buildDir(loaderPath + "/build");
    if (!buildDir.exists()) {
        return false;
    }

    // Copy lindbergh executable and .so file
    QStringList files = {"lindbergh", "lindbergh.so"};
    for (const QString &file : files) {
        QFile src(buildDir.filePath(file));
        QFile dst(gameDir.filePath(file));
        if (dst.exists()) {
            dst.remove();
        }
        if (!src.copy(dst.fileName())) {
            return false;
        }
    }

    return true;
}

void SettingsDialog::saveSettings()
{
    QSettings settings("LindberghLoader", "GUI");
    settings.beginGroup("GamePaths");
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it) {
        if (!it.value().path.isEmpty()) {
            settings.setValue(it.key(), it.value().path);
        }
    }
    settings.endGroup();

    accept();
}
