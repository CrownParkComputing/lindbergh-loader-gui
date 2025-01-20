#include "mainwindow.h"
#include "settingsdialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QStyle>
#include <QApplication>
#include <QProcess>
#include <QSettings>
#include <QMessageBox>
#include <QInputDialog>
#include <QFileInfo>
#include <QDir>
#include <QMouseEvent>

MainWindow::MainWindow(const QString &loaderPath, QWidget *parent)
    : QMainWindow(parent)
    , loaderPath(loaderPath)
    , gameProcess(nullptr)
{
    // Initialize game data
    configuredGames = GameDatabase::getDefaultGames();
    loadSettings();

    // Set window properties for chromeless design
    setWindowFlags(Qt::Window | Qt::FramelessWindowHint);
    setAttribute(Qt::WA_TranslucentBackground);
    
    // Create central widget and layout
    QWidget *centralWidget = new QWidget(this);
    setCentralWidget(centralWidget);
    QVBoxLayout *mainLayout = new QVBoxLayout(centralWidget);
    mainLayout->setContentsMargins(1, 1, 1, 1);
    mainLayout->setSpacing(0);
    
    // Create title bar
    QWidget *titleBar = new QWidget(this);
    titleBar->setObjectName("titleBar");
    QHBoxLayout *titleLayout = new QHBoxLayout(titleBar);
    titleLayout->setContentsMargins(10, 5, 10, 5);
    
    // Title label
    QLabel *titleLabel = new QLabel("Lindbergh Loader", this);
    titleLabel->setObjectName("titleLabel");
    
    // Settings button
    QPushButton *settingsButton = new QPushButton(this);
    settingsButton->setIcon(style()->standardIcon(QStyle::SP_FileDialogDetailedView));
    settingsButton->setToolTip(tr("Settings"));
    settingsButton->setObjectName("titleBarButton");
    
    // Exit button
    QPushButton *exitButton = new QPushButton(this);
    exitButton->setIcon(style()->standardIcon(QStyle::SP_TitleBarCloseButton));
    exitButton->setToolTip(tr("Exit"));
    exitButton->setObjectName("titleBarButton");
    
    titleLayout->addWidget(titleLabel);
    titleLayout->addStretch();
    titleLayout->addWidget(settingsButton);
    titleLayout->addWidget(exitButton);
    
    // Create game table
    gameTable = new QTableWidget(this);
    gameTable->setColumnCount(2);
    gameTable->setHorizontalHeaderLabels({tr("Game"), tr("Actions")});
    gameTable->horizontalHeader()->setSectionResizeMode(0, QHeaderView::Stretch);
    gameTable->horizontalHeader()->setSectionResizeMode(1, QHeaderView::Fixed);
    gameTable->verticalHeader()->setVisible(false);
    gameTable->setShowGrid(false);
    gameTable->setSelectionMode(QAbstractItemView::NoSelection);
    gameTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    gameTable->setAlternatingRowColors(true);
    gameTable->setStyleSheet(
        "QTableWidget { background-color: #2b2b2b; color: #ffffff; border: none; }"
        "QTableWidget::item { padding: 5px; }"
        "QTableWidget::item:alternate { background-color: #323232; }"
        "QHeaderView::section { background-color: #1e1e1e; color: #ffffff; padding: 5px; border: none; }"
        "QPushButton { background-color: #3d3d3d; color: #ffffff; border: none; padding: 5px; border-radius: 3px; }"
        "QPushButton:hover { background-color: #4d4d4d; }"
    );
    
    // Create console output
    consoleOutput = new QPlainTextEdit(this);
    consoleOutput->setReadOnly(true);
    consoleOutput->setMaximumHeight(150);
    consoleOutput->setStyleSheet(
        "QPlainTextEdit { background-color: #1b1b1b; color: #00ff00; border: none; font-family: monospace; }"
    );
    
    // Add widgets to main layout
    mainLayout->addWidget(titleBar);
    mainLayout->addWidget(gameTable);
    mainLayout->addWidget(consoleOutput);
    
    // Connect signals
    connect(exitButton, &QPushButton::clicked, this, &QMainWindow::close);
    connect(settingsButton, &QPushButton::clicked, this, &MainWindow::showSettings);
    
    // Set window style
    setStyleSheet(
        "QMainWindow { background-color: #1b1b1b; }"
        "#titleBar { background-color: #1e1e1e; }"
        "#titleLabel { color: #ffffff; font-size: 14px; font-weight: bold; }"
        "#titleBarButton { background-color: transparent; border: none; padding: 5px; }"
        "#titleBarButton:hover { background-color: #4d4d4d; }"
    );
    
    // Enable dragging the window by clicking anywhere on the title bar
    titleBar->installEventFilter(this);
    
    // Update game table
    updateGameTable();
    
    // Set window size
    resize(800, 600);
}

MainWindow::~MainWindow()
{
    if (gameProcess) {
        gameProcess->kill();
        gameProcess->waitForFinished();
        delete gameProcess;
    }
}

bool MainWindow::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::MouseButtonPress) {
        QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event);
        if (mouseEvent->button() == Qt::LeftButton) {
            dragPosition = mouseEvent->globalPosition().toPoint() - frameGeometry().topLeft();
            return true;
        }
    } else if (event->type() == QEvent::MouseMove) {
        QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event);
        if (mouseEvent->buttons() & Qt::LeftButton) {
            move(mouseEvent->globalPosition().toPoint() - dragPosition);
            return true;
        }
    }
    return QMainWindow::eventFilter(obj, event);
}

void MainWindow::loadSettings()
{
    QSettings settings("LindberghLoader", "GUI");
    settings.beginGroup("GamePaths");
    for (auto it = configuredGames.begin(); it != configuredGames.end(); ++it) {
        it.value().path = settings.value(it.key()).toString();
    }
    settings.endGroup();
}

void MainWindow::showSettings()
{
    SettingsDialog dialog(loaderPath, this);
    if (dialog.exec() == QDialog::Accepted) {
        configuredGames = dialog.getConfiguredGames();
        updateGameTable();
    }
}

void MainWindow::updateGameTable()
{
    gameTable->setRowCount(0);
    int row = 0;
    
    QMap<QString, GameInfo> games = configuredGames;
    
    for (auto it = games.begin(); it != games.end(); ++it) {
        const GameInfo &game = it.value();
        
        // Only show games that have a path configured
        if (game.path.isEmpty()) {
            continue;
        }
        
        gameTable->insertRow(row);
        
        // Game name
        QTableWidgetItem *nameItem = new QTableWidgetItem(game.displayName);
        nameItem->setFlags(nameItem->flags() & ~Qt::ItemIsEditable);
        gameTable->setItem(row, 0, nameItem);
        
        // Actions widget
        QWidget *actionsWidget = new QWidget(gameTable);
        QHBoxLayout *actionsLayout = new QHBoxLayout(actionsWidget);
        actionsLayout->setContentsMargins(4, 4, 4, 4);
        actionsLayout->setSpacing(4);
        
        // Play button
        QPushButton *playButton = new QPushButton(actionsWidget);
        playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
        playButton->setToolTip(tr("Launch %1").arg(game.displayName));
        playButton->setProperty("gameKey", it.key());
        playButton->setStyleSheet("QPushButton { padding: 5px; }");
        connect(playButton, &QPushButton::clicked, this, [this, key = it.key()]() {
            launchGame(key, false);
        });
        
        // Test button
        QPushButton *testButton = new QPushButton(actionsWidget);
        testButton->setIcon(style()->standardIcon(QStyle::SP_MediaSeekForward));
        testButton->setToolTip(tr("Launch %1 (Test Mode)").arg(game.displayName));
        testButton->setProperty("gameKey", it.key());
        testButton->setStyleSheet("QPushButton { padding: 5px; }");
        connect(testButton, &QPushButton::clicked, this, [this, key = it.key()]() {
            launchGame(key, true);
        });
        
        // Edit config button
        QPushButton *editButton = new QPushButton(actionsWidget);
        editButton->setIcon(style()->standardIcon(QStyle::SP_FileDialogDetailedView));
        editButton->setToolTip(tr("Edit %1 Configuration").arg(game.displayName));
        editButton->setProperty("gameKey", it.key());
        editButton->setStyleSheet("QPushButton { padding: 5px; }");
        connect(editButton, &QPushButton::clicked, this, [this, key = it.key()]() {
            editConfig(key);
        });
        
        actionsLayout->addWidget(playButton);
        actionsLayout->addWidget(testButton);
        actionsLayout->addWidget(editButton);
        actionsLayout->addStretch();
        
        gameTable->setCellWidget(row, 1, actionsWidget);
        row++;
    }
    
    gameTable->setColumnWidth(1, 150); // Fixed width for actions column
}

void MainWindow::editConfig(const QString &gameKey)
{
    if (!configuredGames.contains(gameKey)) return;
    
    const GameInfo &game = configuredGames[gameKey];
    QString configPath = QDir(game.path).filePath("lindbergh.conf");
    
    QString content;
    QFile file(configPath);
    if (file.exists() && file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        content = QString::fromUtf8(file.readAll());
        file.close();
    }
    
    bool ok;
    QString newContent = QInputDialog::getMultiLineText(
        this,
        tr("Edit Configuration"),
        tr("Configuration for %1:").arg(game.displayName),
        content,
        &ok
    );
    
    if (ok && newContent != content) {
        QFile file(configPath);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            file.write(newContent.toUtf8());
            file.close();
            appendToConsole(tr("Configuration saved for '%1'").arg(game.displayName));
        }
    }
}

void MainWindow::clearConsole()
{
    consoleOutput->clear();
}

void MainWindow::handleProcessOutput()
{
    QProcess *process = qobject_cast<QProcess*>(sender());
    if (!process) return;
    
    // Read standard output
    QByteArray stdoutData = process->readAllStandardOutput();
    if (!stdoutData.isEmpty()) {
        appendToConsole(QString::fromUtf8(stdoutData));
    }
    
    // Read standard error
    QByteArray stderrData = process->readAllStandardError();
    if (!stderrData.isEmpty()) {
        appendToConsole(QString::fromUtf8(stderrData), true);
    }
}

void MainWindow::handleProcessError(QProcess::ProcessError error)
{
    const GameInfo &game = configuredGames[currentGameKey];
    
    switch (error) {
        case QProcess::FailedToStart:
            appendToConsole(tr("Failed to start game '%1'").arg(game.displayName), true);
            break;
        case QProcess::Crashed:
            appendToConsole(tr("Game '%1' crashed").arg(game.displayName), true);
            break;
        default:
            appendToConsole(tr("Error running game '%1': %2").arg(game.displayName).arg(error), true);
            break;
    }
    
    currentGameKey.clear();
}

void MainWindow::appendToConsole(const QString &text, bool error)
{
    QTextCharFormat format;
    format.setForeground(error ? Qt::red : Qt::green);
    
    QTextCursor cursor = consoleOutput->textCursor();
    cursor.movePosition(QTextCursor::End);
    cursor.insertText(text + "\n", format);
    consoleOutput->setTextCursor(cursor);
    consoleOutput->ensureCursorVisible();
}

void MainWindow::launchGame(const QString &gameKey, bool testMode)
{
    if (!configuredGames.contains(gameKey)) return;
    
    const GameInfo &game = configuredGames[gameKey];
    if (game.path.isEmpty()) {
        QMessageBox::warning(this, tr("Error"),
                           tr("Please configure the game path first."));
        return;
    }
    
    if (gameProcess) {
        QMessageBox::warning(this, tr("Error"),
                           tr("A game is already running."));
        return;
    }
    
    // Create and configure the process
    gameProcess = new QProcess(this);
    currentGameKey = gameKey;
    
    // Set working directory
    gameProcess->setWorkingDirectory(game.path);
    
    // Connect signals for output handling
    connect(gameProcess, &QProcess::readyReadStandardOutput, this, &MainWindow::handleProcessOutput);
    connect(gameProcess, &QProcess::readyReadStandardError, this, &MainWindow::handleProcessOutput);
    connect(gameProcess, &QProcess::errorOccurred, this, &MainWindow::handleProcessError);
    connect(gameProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this, gameKey](int exitCode, QProcess::ExitStatus exitStatus) {
        const GameInfo &game = configuredGames[gameKey];
        if (exitStatus == QProcess::NormalExit) {
            appendToConsole(tr("Game '%1' exited with code %2").arg(game.displayName).arg(exitCode));
        } else {
            appendToConsole(tr("Game '%1' crashed!").arg(game.displayName), true);
        }
        currentGameKey.clear();
        delete gameProcess;
        gameProcess = nullptr;
    });
    
    // Clear the console
    clearConsole();
    
    // Prepare command and arguments
    QString command = QDir(game.path).filePath("lindbergh");
    QStringList args;
    if (testMode) {
        args << "-t";
    }
    
    // Log the launch
    appendToConsole(tr("Launching game '%1'%2...")
                   .arg(game.displayName)
                   .arg(testMode ? tr(" (Test Mode)") : ""));
    
    // Start the process
    gameProcess->start(command, args);
}
