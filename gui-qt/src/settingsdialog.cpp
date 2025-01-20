#include "settingsdialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QFileDialog>
#include <QStandardPaths>
#include <QMessageBox>
#include <QHeaderView>
#include <QSettings>
#include <QDir>
#include <QFile>

SettingsDialog::SettingsDialog(const QString &loaderPath, QWidget *parent)
    : QDialog(parent)
    , loaderPath(loaderPath)
{
    setWindowTitle(tr("Game Settings"));
    resize(800, 600);

    QVBoxLayout *layout = new QVBoxLayout(this);

    // Create game table
    gameTable = new QTableWidget(this);
    gameTable->setColumnCount(4);
    gameTable->setHorizontalHeaderLabels({
        tr("Game"), 
        tr("Path"), 
        tr("Setup"), 
        tr("Install")
    });
    gameTable->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    gameTable->horizontalHeader()->setSectionResizeMode(1, QHeaderView::Stretch);
    gameTable->horizontalHeader()->setSectionResizeMode(2, QHeaderView::ResizeToContents);
    gameTable->horizontalHeader()->setSectionResizeMode(3, QHeaderView::ResizeToContents);
    gameTable->setSelectionBehavior(QAbstractItemView::SelectRows);
    gameTable->setSelectionMode(QAbstractItemView::SingleSelection);
    gameTable->verticalHeader()->setVisible(false);

    // Buttons
    QHBoxLayout *buttonLayout = new QHBoxLayout();
    QPushButton *okButton = new QPushButton(tr("Save"), this);
    QPushButton *cancelButton = new QPushButton(tr("Cancel"), this);
    buttonLayout->addStretch();
    buttonLayout->addWidget(okButton);
    buttonLayout->addWidget(cancelButton);

    layout->addWidget(gameTable);
    layout->addLayout(buttonLayout);

    connect(okButton, &QPushButton::clicked, this, &SettingsDialog::saveSettings);
    connect(cancelButton, &QPushButton::clicked, this, &QDialog::reject);

    // Initialize with default games and load settings
    configuredGames = GameDatabase::getDefaultGames();
    loadSettings();
    updateGameTable();
}

void SettingsDialog::loadSettings()
{
    QSettings settings("LindberghLoader", "GUI");
    settings.beginGroup("GamePaths");
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it) {
        it.value().path = settings.value(it.key()).toString();
    }
    settings.endGroup();
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

void SettingsDialog::updateGameTable()
{
    gameTable->setRowCount(configuredGames.size());
    int row = 0;

    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it, ++row) {
        const GameInfo &game = it.value();

        // Game name
        QTableWidgetItem *nameItem = new QTableWidgetItem(game.displayName);
        nameItem->setData(Qt::UserRole, it.key());
        gameTable->setItem(row, 0, nameItem);

        // Path
        QTableWidgetItem *pathItem = new QTableWidgetItem(game.path);
        pathItem->setData(Qt::UserRole, it.key());
        gameTable->setItem(row, 1, pathItem);

        // Setup button
        QPushButton *setupButton = new QPushButton(tr("Set Path"), this);
        setupButton->setProperty("gameKey", it.key());
        setupButton->setProperty("row", row);
        connect(setupButton, &QPushButton::clicked, this, &SettingsDialog::selectGamePath);
        gameTable->setCellWidget(row, 2, setupButton);

        // Install button
        QPushButton *installButton = new QPushButton(tr("Install"), this);
        installButton->setProperty("gameKey", it.key());
        installButton->setEnabled(!game.path.isEmpty());
        connect(installButton, &QPushButton::clicked, this, &SettingsDialog::installGame);
        gameTable->setCellWidget(row, 3, installButton);
    }
}

void SettingsDialog::selectGamePath()
{
    QPushButton *button = qobject_cast<QPushButton*>(sender());
    if (!button) return;

    QString gameKey = button->property("gameKey").toString();
    int row = button->property("row").toInt();
    if (!configuredGames.contains(gameKey)) return;

    QString path = QFileDialog::getExistingDirectory(
        this,
        tr("Select Game Directory"),
        QStandardPaths::writableLocation(QStandardPaths::HomeLocation),
        QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks
    );

    if (!path.isEmpty()) {
        configuredGames[gameKey].path = path;
        gameTable->item(row, 1)->setText(path);
        QTableWidgetItem* pathItem = gameTable->item(row, 1);
        if (pathItem) {
            pathItem->setText(path);
        }
        
        // Enable install button
        if (QWidget *widget = gameTable->cellWidget(row, 3)) {
            if (QPushButton *installButton = qobject_cast<QPushButton*>(widget)) {
                installButton->setEnabled(true);
            }
        }
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

QMap<QString, GameInfo> SettingsDialog::getConfiguredGames() const
{
    return configuredGames;
}
