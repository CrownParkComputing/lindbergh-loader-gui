#include "mainwindow.h"
#include "settingsdialog.h"
#include "setupdialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QFileDialog>
#include <QMessageBox>
#include <QStandardPaths>
#include <QDir>
#include <QStyle>
#include <QSplitter>
#include <QDateTime>
#include <QTextEdit>
#include <QHeaderView>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , gameProcess(nullptr)
{
    setupUI();
    loadGames();
    
    if (!checkSetup()) {
        showSetup();
    }
}

MainWindow::~MainWindow()
{
    if (gameProcess) {
        gameProcess->kill();
        gameProcess->waitForFinished();
        delete gameProcess;
    }
}

void MainWindow::setupUI()
{
    setWindowTitle(tr("Lindbergh Loader GUI"));
    setMinimumSize(1024, 768);

    QWidget *centralWidget = new QWidget(this);
    setCentralWidget(centralWidget);
    
    QVBoxLayout *mainLayout = new QVBoxLayout(centralWidget);
    
    // Create a splitter for game table and console
    QSplitter *splitter = new QSplitter(Qt::Vertical);
    
    // Top widget for game table
    QWidget *topWidget = new QWidget;
    QVBoxLayout *topLayout = new QVBoxLayout(topWidget);
    
    // Game table
    gameTable = new QTableWidget(this);
    gameTable->setColumnCount(3);
    gameTable->setHorizontalHeaderLabels({tr("Game"), tr("Path"), tr("Actions")});
    gameTable->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    gameTable->horizontalHeader()->setSectionResizeMode(1, QHeaderView::Stretch);
    gameTable->horizontalHeader()->setSectionResizeMode(2, QHeaderView::Fixed);
    gameTable->setSelectionBehavior(QAbstractItemView::SelectRows);
    gameTable->setSelectionMode(QAbstractItemView::SingleSelection);
    gameTable->verticalHeader()->setVisible(false);
    gameTable->setShowGrid(false);
    gameTable->setAlternatingRowColors(true);
    
    // Top buttons
    QHBoxLayout *buttonLayout = new QHBoxLayout();
    
    setupButton = new QPushButton(this);
    setupButton->setIcon(style()->standardIcon(QStyle::SP_FileDialogDetailedView));
    setupButton->setToolTip(tr("Setup Lindbergh Loader"));
    connect(setupButton, &QPushButton::clicked, this, &MainWindow::showSetup);
    
    settingsButton = new QPushButton(this);
    settingsButton->setIcon(style()->standardIcon(QStyle::SP_DialogOpenButton));
    settingsButton->setToolTip(tr("Game Settings"));
    connect(settingsButton, &QPushButton::clicked, this, &MainWindow::showSettings);
    
    buttonLayout->addWidget(setupButton);
    buttonLayout->addWidget(settingsButton);
    buttonLayout->addStretch();
    
    // Add widgets to top layout
    topLayout->addLayout(buttonLayout);
    topLayout->addWidget(gameTable);
    
    // Bottom widget for console output
    QWidget *bottomWidget = new QWidget;
    QVBoxLayout *bottomLayout = new QVBoxLayout(bottomWidget);
    
    // Console header with clear button
    QHBoxLayout *consoleHeaderLayout = new QHBoxLayout();
    consoleHeaderLayout->addWidget(new QLabel(tr("Console Output:")));
    clearConsoleButton = new QPushButton(this);
    clearConsoleButton->setIcon(style()->standardIcon(QStyle::SP_DialogResetButton));
    clearConsoleButton->setToolTip(tr("Clear Console"));
    connect(clearConsoleButton, &QPushButton::clicked, this, &MainWindow::clearConsole);
    consoleHeaderLayout->addWidget(clearConsoleButton);
    
    // Console output
    consoleOutput = new QPlainTextEdit(this);
    consoleOutput->setReadOnly(true);
    consoleOutput->setMaximumBlockCount(1000);
    QFont consoleFont("Monospace");
    consoleFont.setStyleHint(QFont::TypeWriter);
    consoleOutput->setFont(consoleFont);
    
    // Status label
    statusLabel = new QLabel(this);
    
    // Add widgets to bottom layout
    bottomLayout->addLayout(consoleHeaderLayout);
    bottomLayout->addWidget(consoleOutput);
    bottomLayout->addWidget(statusLabel);
    
    // Add widgets to splitter
    splitter->addWidget(topWidget);
    splitter->addWidget(bottomWidget);
    splitter->setStretchFactor(0, 1);
    splitter->setStretchFactor(1, 1);
    
    // Add splitter to main layout
    mainLayout->addWidget(splitter);
}

void MainWindow::updateGameTable()
{
    gameTable->setRowCount(configuredGames.size());
    int row = 0;
    
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it, ++row) {
        const GameInfo &game = it.value();
        
        // Game name
        QTableWidgetItem *nameItem = new QTableWidgetItem(game.name);
        nameItem->setData(Qt::UserRole, it.key());
        gameTable->setItem(row, 0, nameItem);
        
        // Path
        gameTable->setItem(row, 1, new QTableWidgetItem(game.path));
        
        // Actions widget
        QWidget *actionsWidget = new QWidget(gameTable);
        QHBoxLayout *actionsLayout = new QHBoxLayout(actionsWidget);
        actionsLayout->setContentsMargins(4, 4, 4, 4);
        actionsLayout->setSpacing(4);
        
        // Play button
        QPushButton *playButton = new QPushButton(actionsWidget);
        playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
        playButton->setToolTip(tr("Launch Game"));
        playButton->setProperty("gameKey", it.key());
        connect(playButton, &QPushButton::clicked, this, [this, key = it.key()]() {
            launchGame(key, false);
        });
        
        // Test button
        QPushButton *testButton = new QPushButton(actionsWidget);
        testButton->setIcon(style()->standardIcon(QStyle::SP_MediaSeekForward));
        testButton->setToolTip(tr("Launch Test Mode"));
        testButton->setProperty("gameKey", it.key());
        connect(testButton, &QPushButton::clicked, this, [this, key = it.key()]() {
            launchGame(key, true);
        });
        
        // Edit config button
        QPushButton *editButton = new QPushButton(actionsWidget);
        editButton->setIcon(style()->standardIcon(QStyle::SP_FileDialogDetailedView));
        editButton->setToolTip(tr("Edit Configuration"));
        editButton->setProperty("gameKey", it.key());
        connect(editButton, &QPushButton::clicked, this, [this, key = it.key()]() {
            editConfig(key);
        });
        
        // Delete button
        QPushButton *deleteButton = new QPushButton(actionsWidget);
        deleteButton->setIcon(style()->standardIcon(QStyle::SP_TrashIcon));
        deleteButton->setToolTip(tr("Remove Game"));
        deleteButton->setProperty("gameKey", it.key());
        connect(deleteButton, &QPushButton::clicked, this, [this, key = it.key()]() {
            removeGame(key);
        });
        
        actionsLayout->addWidget(playButton);
        actionsLayout->addWidget(testButton);
        actionsLayout->addWidget(editButton);
        actionsLayout->addWidget(deleteButton);
        actionsLayout->addStretch();
        
        gameTable->setCellWidget(row, 2, actionsWidget);
    }
    
    gameTable->setColumnWidth(2, 200); // Fixed width for actions column
}

void MainWindow::editConfig(const QString &gameKey)
{
    if (!configuredGames.contains(gameKey)) return;
    
    const GameInfo &game = configuredGames[gameKey];
    QString configPath = QDir(game.path).filePath("lindbergh.conf");
    
    if (!QFile::exists(configPath)) {
        QMessageBox::critical(this, tr("Error"),
                            tr("Configuration file not found: %1").arg(configPath));
        return;
    }
    
    // Create and show config editor dialog
    QDialog dialog(this);
    dialog.setWindowTitle(tr("Edit Configuration - %1").arg(game.name));
    dialog.resize(800, 600);
    
    QVBoxLayout *layout = new QVBoxLayout(&dialog);
    
    QTextEdit *editor = new QTextEdit(&dialog);
    editor->setFont(QFont("Monospace"));
    
    // Load config file
    QFile file(configPath);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        editor->setPlainText(QString::fromUtf8(file.readAll()));
        file.close();
    }
    
    // Dialog buttons
    QHBoxLayout *buttonLayout = new QHBoxLayout();
    QPushButton *saveButton = new QPushButton(tr("Save"), &dialog);
    QPushButton *cancelButton = new QPushButton(tr("Cancel"), &dialog);
    buttonLayout->addStretch();
    buttonLayout->addWidget(saveButton);
    buttonLayout->addWidget(cancelButton);
    
    layout->addWidget(editor);
    layout->addLayout(buttonLayout);
    
    connect(saveButton, &QPushButton::clicked, &dialog, [&dialog, editor, configPath, this]() {
        QFile file(configPath);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            file.write(editor->toPlainText().toUtf8());
            file.close();
            dialog.accept();
        } else {
            QMessageBox::critical(this, tr("Error"),
                                tr("Failed to save configuration file: %1").arg(configPath));
        }
    });
    
    connect(cancelButton, &QPushButton::clicked, &dialog, &QDialog::reject);
    
    dialog.exec();
}

void MainWindow::removeGame(const QString &gameKey)
{
    if (!configuredGames.contains(gameKey)) return;
    
    const GameInfo &game = configuredGames[gameKey];
    if (QMessageBox::question(this, tr("Remove Game"),
                            tr("Remove %1 from the list?").arg(game.name)) == QMessageBox::Yes) {
        configuredGames[gameKey].path.clear();
        saveGames();
        updateGameTable();
    }
}

void MainWindow::launchGame(const QString &gameKey, bool testMode)
{
    if (!checkSetup()) {
        QMessageBox::warning(this, tr("Setup Required"),
                           tr("Please complete the Lindbergh Loader setup first."));
        showSetup();
        return;
    }

    if (!configuredGames.contains(gameKey)) {
        QMessageBox::critical(this, tr("Error"),
                            tr("Invalid game selection!"));
        return;
    }
    
    const GameInfo &game = configuredGames[gameKey];
    if (!QDir(game.path).exists()) {
        QMessageBox::critical(this, tr("Error"),
                            tr("Game directory not found: %1").arg(game.path));
        return;
    }
    
    // Kill any existing process
    if (gameProcess) {
        gameProcess->kill();
        gameProcess->waitForFinished();
        delete gameProcess;
    }
    
    // Create new process
    gameProcess = new QProcess(this);
    gameProcess->setWorkingDirectory(game.path);
    currentGameKey = gameKey;
    
    // Set environment variables
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("LD_LIBRARY_PATH", QString("%1:/usr/lib32:$LD_LIBRARY_PATH").arg(loaderPath + "/build"));
    env.insert("LD_PRELOAD", QString("%1/lindbergh.so").arg(loaderPath + "/build"));
    gameProcess->setProcessEnvironment(env);
    
    // Connect signals for output handling
    connect(gameProcess, &QProcess::readyReadStandardOutput, this, &MainWindow::handleProcessOutput);
    connect(gameProcess, &QProcess::readyReadStandardError, this, &MainWindow::handleProcessOutput);
    connect(gameProcess, &QProcess::errorOccurred, this, &MainWindow::handleProcessError);
    
    connect(gameProcess, &QProcess::started, this, [this, game, testMode]() {
        statusLabel->setText(tr("%1 running in %2 mode...")
                           .arg(game.name)
                           .arg(testMode ? "test" : "normal"));
        appendToConsole(tr("Starting %1 in %2 mode...")
                       .arg(game.name)
                       .arg(testMode ? "test" : "normal"));
    });
    
    connect(gameProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this](int exitCode, QProcess::ExitStatus exitStatus) {
        const GameInfo &game = configuredGames[currentGameKey];
        statusLabel->setText(tr("Game finished."));
        QString exitMsg = tr("%1 finished with exit code: %2").arg(game.name).arg(exitCode);
        appendToConsole(exitMsg, exitCode != 0);
        currentGameKey.clear();
    });
    
    // Start the game
    QStringList arguments;
    arguments << QString("%1/build/lindbergh").arg(loaderPath);
    if (testMode) {
        arguments << "-t";
    }
    gameProcess->start("linux32", arguments);
}

void MainWindow::loadGames()
{
    QSettings settings("LindberghLoader", "GUI");
    configuredGames = GameDatabase::getDefaultGames();
    
    // Load saved paths
    settings.beginGroup("GamePaths");
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it) {
        it.value().path = settings.value(it.key()).toString();
    }
    settings.endGroup();
    
    updateGameTable();
}

void MainWindow::saveGames()
{
    QSettings settings("LindberghLoader", "GUI");
    settings.beginGroup("GamePaths");
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it) {
        if (!it.value().path.isEmpty()) {
            settings.setValue(it.key(), it.value().path);
        }
    }
    settings.endGroup();
}

void MainWindow::showSetup()
{
    SetupDialog dialog(this);
    if (dialog.exec() == QDialog::Accepted) {
        loaderPath = dialog.getLoaderPath();
        QSettings settings("LindberghLoader", "GUI");
        settings.setValue("loaderPath", loaderPath);
    }
}

void MainWindow::showSettings()
{
    if (!checkSetup()) {
        QMessageBox::warning(this, tr("Setup Required"),
                           tr("Please complete the Lindbergh Loader setup first."));
        showSetup();
        return;
    }

    SettingsDialog dialog(loaderPath, this);
    if (dialog.exec() == QDialog::Accepted) {
        configuredGames = dialog.getConfiguredGames();
        updateGameTable();
    }
}

void MainWindow::appendToConsole(const QString &text, bool error)
{
    QString timestamp = QDateTime::currentDateTime().toString("hh:mm:ss");
    QString coloredText;
    if (error) {
        coloredText = QString("<span style='color:red'>[%1] %2</span>").arg(timestamp, text.toHtmlEscaped());
    } else {
        coloredText = QString("[%1] %2").arg(timestamp, text.toHtmlEscaped());
    }
    consoleOutput->appendHtml(coloredText);
}

void MainWindow::handleProcessOutput()
{
    QProcess *process = qobject_cast<QProcess*>(sender());
    if (!process) return;

    // Handle stdout
    while (process->canReadLine()) {
        QString line = QString::fromUtf8(process->readLine()).trimmed();
        if (!line.isEmpty()) {
            appendToConsole(line);
        }
    }

    // Handle stderr
    QString errorOutput = QString::fromUtf8(process->readAllStandardError()).trimmed();
    if (!errorOutput.isEmpty()) {
        appendToConsole(errorOutput, true);
    }
}

void MainWindow::handleProcessError(QProcess::ProcessError error)
{
    QString errorMessage;
    switch (error) {
        case QProcess::FailedToStart:
            errorMessage = tr("Failed to start the game process.");
            break;
        case QProcess::Crashed:
            errorMessage = tr("Game process crashed.");
            break;
        case QProcess::Timedout:
            errorMessage = tr("Process timed out.");
            break;
        case QProcess::WriteError:
            errorMessage = tr("Write error occurred.");
            break;
        case QProcess::ReadError:
            errorMessage = tr("Read error occurred.");
            break;
        default:
            errorMessage = tr("Unknown error occurred.");
            break;
    }
    appendToConsole(errorMessage, true);
}

void MainWindow::clearConsole()
{
    consoleOutput->clear();
}

bool MainWindow::checkSetup()
{
    QSettings settings("LindberghLoader", "GUI");
    loaderPath = settings.value("loaderPath").toString();
    
    if (loaderPath.isEmpty()) {
        return false;
    }

    QDir dir(loaderPath);
    if (!dir.exists() || !QFile::exists(dir.filePath("build/lindbergh"))) {
        return false;
    }

    return true;
}
