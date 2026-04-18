#include "HyprExtras.hpp"
#include <QLocalSocket>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QProcess>
#include <QLoggingCategory>

Q_LOGGING_CATEGORY(lcHypr, "nyxde.hyprextras")

// ── HyprKeyboard ──────────────────────────────────────────────────────────────
void HyprKeyboard::update(const QString& name, const QString& layout,
                          const QString& keymap, bool caps, bool num) {
    if (m_name != name)               { m_name = name;               emit nameChanged(); }
    if (m_layout != layout)           { m_layout = layout;           emit layoutChanged(); }
    if (m_activeKeymap != keymap)     { m_activeKeymap = keymap;     emit activeKeymapChanged(); }
    if (m_capsLock != caps)           { m_capsLock = caps;           emit capsLockChanged(); }
    if (m_numLock != num)             { m_numLock = num;             emit numLockChanged(); }
}

// ── HyprExtras ────────────────────────────────────────────────────────────────
HyprExtras::HyprExtras(QObject* parent) : QObject(parent) {
    // Find Hyprland IPC socket
    const QString his = qEnvironmentVariable("HYPRLAND_INSTANCE_SIGNATURE");
    const QString xdgRuntime = qEnvironmentVariable("XDG_RUNTIME_DIR", "/run/user/1000");
    m_socketPath = xdgRuntime + "/hypr/" + his + "/.socket.sock";

    refresh();
}

HyprExtras* HyprExtras::create(QQmlEngine*, QJSEngine*) {
    return new HyprExtras();
}

QList<QObject*> HyprExtras::keyboards() const {
    QList<QObject*> list;
    for (auto* kb : m_keyboards) list << kb;
    return list;
}

void HyprExtras::dispatch(const QString& cmd) {
    QLocalSocket socket;
    socket.connectToServer(m_socketPath);
    if (!socket.waitForConnected(500)) {
        qCWarning(lcHypr) << "Cannot connect to Hyprland socket";
        return;
    }
    socket.write(("dispatch " + cmd).toUtf8());
    socket.waitForBytesWritten(500);
}

void HyprExtras::batchDispatch(const QStringList& cmds) {
    dispatch("[[BATCH]]" + cmds.join(";dispatch "));
}

void HyprExtras::refresh() {
    // Ask Hyprland for device info via hyprctl
    QProcess proc;
    proc.start("hyprctl", {"devices", "-j"});
    proc.waitForFinished(2000);

    const auto doc = QJsonDocument::fromJson(proc.readAllStandardOutput());
    if (!doc.isObject()) return;

    const auto keyboards = doc.object()["keyboards"].toArray();
    bool anyCaps = false;

    for (const auto& kbVal : keyboards) {
        const auto kb = kbVal.toObject();
        const QString name   = kb["name"].toString();
        const QString layout = kb["active_keymap"].toString();
        const bool caps      = kb["capsLock"].toBool();
        const bool num       = kb["numLock"].toBool();

        // Find or create keyboard entry
        HyprKeyboard* existing = nullptr;
        for (auto* k : m_keyboards) {
            if (k->name() == name) { existing = k; break; }
        }
        if (!existing) {
            existing = new HyprKeyboard(this);
            m_keyboards.append(existing);
            emit keyboardsChanged();
        }
        existing->update(name, layout, layout, caps, num);
        if (caps) anyCaps = true;
    }

    if (m_capsLock != anyCaps) {
        m_capsLock = anyCaps;
        emit capsLockChanged();
    }
}
