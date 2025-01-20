#ifndef SETUPDIALOG_H
#define SETUPDIALOG_H

#include <QDialog>
#include <QLineEdit>
#include <QPushButton>
#include <QLabel>
#include <QProcess>

class SetupDialog : public QDialog {
    Q_OBJECT

public:
    explicit SetupDialog(QWidget *parent = nullptr);
    QString getLoaderPath() const { return loaderPathEdit->text(); }

private slots:
    void selectLoaderPath();
    void installDependencies();
    void buildLoader();
    void checkSetup();

private:
    void setupUI();
    void loadSettings();
    void saveSettings();
    void updateStatus();
    bool runCommand(const QString &command, const QString &workingDir = QString());

    QLineEdit *loaderPathEdit;
    QPushButton *selectPathButton;
    QPushButton *installDepsButton;
    QPushButton *buildButton;
    QPushButton *saveButton;
    QLabel *statusLabel;
    QProcess *process;
    bool depsInstalled;
    bool loaderBuilt;
};

#endif // SETUPDIALOG_H
