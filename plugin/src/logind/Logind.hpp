#pragma once
#include <QObject>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

// Listens to systemd-logind DBus signals for sleep/wake/lock events.
class LogindManager : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit LogindManager(QObject* parent = nullptr);
    static LogindManager* create(QQmlEngine*, QJSEngine*);

public slots:
    void onPrepareForSleep(bool sleeping) {
        if (sleeping) emit aboutToSleep();
        else          emit resumed();
    }

signals:
    void aboutToSleep();
    void resumed();
    void lockRequested();
    void unlockRequested();
};
