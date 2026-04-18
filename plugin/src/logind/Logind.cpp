#include "Logind.hpp"
#include <QDBusConnection>
#include <QDBusInterface>
#include <QLoggingCategory>

Q_LOGGING_CATEGORY(lcLogind, "nyxde.logind")

LogindManager::LogindManager(QObject* parent) : QObject(parent) {
    auto bus = QDBusConnection::systemBus();

    // PrepareForSleep(bool) — true = going to sleep, false = waking up
    bus.connect(
        "org.freedesktop.login1",
        "/org/freedesktop/login1",
        "org.freedesktop.login1.Manager",
        "PrepareForSleep",
        this,
        SLOT(onPrepareForSleep(bool))
    );

    // Lock / Unlock on the session object
    const QString session = qEnvironmentVariable("XDG_SESSION_ID", "auto");
    const QString sessionPath = "/org/freedesktop/login1/session/" + session;

    bus.connect(
        "org.freedesktop.login1",
        sessionPath,
        "org.freedesktop.login1.Session",
        "Lock",
        this,
        SIGNAL(lockRequested())
    );
    bus.connect(
        "org.freedesktop.login1",
        sessionPath,
        "org.freedesktop.login1.Session",
        "Unlock",
        this,
        SIGNAL(unlockRequested())
    );

    qCInfo(lcLogind) << "Logind connected, session:" << session;
}

LogindManager* LogindManager::create(QQmlEngine*, QJSEngine*) {
    return new LogindManager();
}

// Private slot — not in header to keep QML API clean
// We use a QMetaObject trick via connectSlotsByName instead
// Actually connect via lambda in constructor is cleaner for this:
// (The SLOT macro above works because QDBus can call slots by signature)
