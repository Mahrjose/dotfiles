#pragma once
#include <QObject>
#include <QString>
#include <QStringList>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

// Exposes Hyprland IPC extras not covered by Quickshell.Hyprland:
// keyboard layout, caps lock state, batch dispatch.
class HyprKeyboard : public QObject {
    Q_OBJECT
    QML_UNCREATABLE("Created by HyprExtras")

    Q_PROPERTY(QString name        READ name        NOTIFY nameChanged)
    Q_PROPERTY(QString layout      READ layout      NOTIFY layoutChanged)
    Q_PROPERTY(QString activeKeymap READ activeKeymap NOTIFY activeKeymapChanged)
    Q_PROPERTY(bool    capsLock    READ capsLock    NOTIFY capsLockChanged)
    Q_PROPERTY(bool    numLock     READ numLock     NOTIFY numLockChanged)

public:
    explicit HyprKeyboard(QObject* parent = nullptr) : QObject(parent) {}

    QString name()         const { return m_name; }
    QString layout()       const { return m_layout; }
    QString activeKeymap() const { return m_activeKeymap; }
    bool    capsLock()     const { return m_capsLock; }
    bool    numLock()      const { return m_numLock; }

    void update(const QString& name, const QString& layout,
                const QString& keymap, bool caps, bool num);

signals:
    void nameChanged();
    void layoutChanged();
    void activeKeymapChanged();
    void capsLockChanged();
    void numLockChanged();

private:
    QString m_name, m_layout, m_activeKeymap;
    bool m_capsLock = false, m_numLock = false;
};

class HyprExtras : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QList<QObject*> keyboards READ keyboards NOTIFY keyboardsChanged)
    Q_PROPERTY(bool            capsLock  READ capsLock  NOTIFY capsLockChanged)

public:
    explicit HyprExtras(QObject* parent = nullptr);
    static HyprExtras* create(QQmlEngine*, QJSEngine*);

    QList<QObject*> keyboards() const;
    bool            capsLock()  const { return m_capsLock; }

    Q_INVOKABLE void dispatch(const QString& cmd);
    Q_INVOKABLE void batchDispatch(const QStringList& cmds);

signals:
    void keyboardsChanged();
    void capsLockChanged();

private:
    void refresh();
    void connectSocket();

    QList<HyprKeyboard*> m_keyboards;
    bool m_capsLock = false;
    QString m_socketPath;
};
