#include "setupdialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QFileDialog>
#include <QMessageBox>
#include <QSettings>
#include <QDir>
#include <QProcess>
#include <QStyle>

SetupDialog::SetupDialog(QWidget *parent)
    : QDialog(parent)
    , process(nullptr)
    , depsInstalled(false)
    , loaderBuilt(false)
{
    setupUI();
    loadSettings();
    checkSetup();
}

void SetupDialog::setupUI()
{
    setWindowTitle(tr("Lindbergh Loader Setup"));
    setMinimumWidth(600);

    QVBoxLayout *mainLayout = new QVBoxLayout(this);

    // Loader path selection
    QHBoxLayout *pathLayout = new QHBoxLayout();
    QLabel *pathLabel = new QLabel(tr("Lindbergh Loader Source Path:"), this);
    loaderPathEdit = new QLineEdit(this);
    selectPathButton = new QPushButton(tr("Browse"), this);
    selectPathButton->setIcon(style()->standardIcon(QStyle::SP_DirIcon));
    
    pathLayout->addWidget(pathLabel);
    pathLayout->addWidget(loaderPathEdit);
    pathLayout->addWidget(selectPathButton);

    // Action buttons
    installDepsButton = new QPushButton(tr("Install Dependencies"), this);
    installDepsButton->setIcon(style()->standardIcon(QStyle::SP_DialogApplyButton));
    
    buildButton = new QPushButton(tr("Build Loader"), this);
    buildButton->setIcon(style()->standardIcon(QStyle::SP_DialogApplyButton));
    
    saveButton = new QPushButton(tr("Save"), this);
    saveButton->setIcon(style()->standardIcon(QStyle::SP_DialogSaveButton));

    // Status label
    statusLabel = new QLabel(this);
    statusLabel->setWordWrap(true);

    // Add widgets to layout
    mainLayout->addLayout(pathLayout);
    mainLayout->addWidget(installDepsButton);
    mainLayout->addWidget(buildButton);
    mainLayout->addWidget(statusLabel);
    
    QHBoxLayout *buttonLayout = new QHBoxLayout();
    buttonLayout->addStretch();
    buttonLayout->addWidget(saveButton);
    buttonLayout->addWidget(new QPushButton(tr("Cancel"), this));
    mainLayout->addLayout(buttonLayout);

    // Connect signals
    connect(selectPathButton, &QPushButton::clicked, this, &SetupDialog::selectLoaderPath);
    connect(installDepsButton, &QPushButton::clicked, this, &SetupDialog::installDependencies);
    connect(buildButton, &QPushButton::clicked, this, &SetupDialog::buildLoader);
    connect(saveButton, &QPushButton::clicked, this, &SetupDialog::accept);
    connect(loaderPathEdit, &QLineEdit::textChanged, this, &SetupDialog::checkSetup);
}

void SetupDialog::loadSettings()
{
    QSettings settings("LindberghLoader", "GUI");
    loaderPathEdit->setText(settings.value("loaderPath").toString());
}

void SetupDialog::saveSettings()
{
    QSettings settings("LindberghLoader", "GUI");
    settings.setValue("loaderPath", loaderPathEdit->text());
}

void SetupDialog::selectLoaderPath()
{
    QString dir = QFileDialog::getExistingDirectory(this, tr("Select Lindbergh Loader Source Directory"));
    if (!dir.isEmpty()) {
        loaderPathEdit->setText(dir);
    }
}

void SetupDialog::installDependencies()
{
    QString loaderPath = loaderPathEdit->text();
    if (loaderPath.isEmpty() || !QDir(loaderPath).exists()) {
        QMessageBox::warning(this, tr("Error"), tr("Please select a valid Lindbergh Loader source directory."));
        return;
    }

    installDepsButton->setEnabled(false);
    statusLabel->setText(tr("Installing dependencies..."));

    // Run the install-dependencies.sh script
    if (runCommand("sudo ./install-dependencies.sh", loaderPath)) {
        depsInstalled = true;
        statusLabel->setText(tr("Dependencies installed successfully."));
    } else {
        statusLabel->setText(tr("Failed to install dependencies."));
    }
    installDepsButton->setEnabled(true);
}

void SetupDialog::buildLoader()
{
    QString loaderPath = loaderPathEdit->text();
    if (loaderPath.isEmpty() || !QDir(loaderPath).exists()) {
        QMessageBox::warning(this, tr("Error"), tr("Please select a valid Lindbergh Loader source directory."));
        return;
    }

    buildButton->setEnabled(false);
    statusLabel->setText(tr("Building loader..."));

    // Run make clean && make
    if (runCommand("make clean && make", loaderPath)) {
        loaderBuilt = true;
        statusLabel->setText(tr("Loader built successfully."));
    } else {
        statusLabel->setText(tr("Failed to build loader."));
    }
    buildButton->setEnabled(true);
}

bool SetupDialog::runCommand(const QString &command, const QString &workingDir)
{
    if (process) {
        delete process;
    }

    process = new QProcess(this);
    if (!workingDir.isEmpty()) {
        process->setWorkingDirectory(workingDir);
    }

    process->start("bash", QStringList() << "-c" << command);
    process->waitForFinished(-1);

    bool success = process->exitCode() == 0;
    delete process;
    process = nullptr;
    return success;
}

void SetupDialog::checkSetup()
{
    QString path = loaderPathEdit->text();
    if (path.isEmpty()) {
        statusLabel->setText(tr("Please select the Lindbergh Loader source directory."));
        return;
    }

    QDir dir(path);
    if (!dir.exists()) {
        statusLabel->setText(tr("Selected directory does not exist."));
        return;
    }

    if (!QFile::exists(dir.filePath("install-dependencies.sh"))) {
        statusLabel->setText(tr("Invalid Lindbergh Loader source directory (install-dependencies.sh not found)."));
        return;
    }

    if (QFile::exists(dir.filePath("build/lindbergh"))) {
        loaderBuilt = true;
        statusLabel->setText(tr("Loader is built and ready."));
    } else {
        statusLabel->setText(tr("Loader needs to be built."));
    }
}
