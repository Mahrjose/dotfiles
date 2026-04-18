#include "Config.hpp"
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QLoggingCategory>

Q_LOGGING_CATEGORY(lcConfig, "nyxde.config")

NyxConfig* NyxConfig::s_instance = nullptr;

// ── BarConfig ─────────────────────────────────────────────────────────────────
void BarConfig::loadJson(const QJsonObject& obj) {
    if (obj.contains("height"))    setHeight(obj["height"].toInt(m_height));
    if (obj.contains("showTitle")) setShowTitle(obj["showTitle"].toBool(m_showTitle));
    if (obj.contains("showTray"))  setShowTray(obj["showTray"].toBool(m_showTray));
    if (obj.contains("showMedia")) setShowMedia(obj["showMedia"].toBool(m_showMedia));
}

QJsonObject BarConfig::toJson() const {
    return {
        {"height",    m_height},
        {"showTitle", m_showTitle},
        {"showTray",  m_showTray},
        {"showMedia", m_showMedia},
    };
}

// ── AppearanceConfig ──────────────────────────────────────────────────────────
void AppearanceConfig::loadJson(const QJsonObject& obj) {
    if (obj.contains("rounding")) setRounding(obj["rounding"].toInt(m_rounding));
    if (obj.contains("spacing"))  setSpacing(obj["spacing"].toInt(m_spacing));
    if (obj.contains("font"))     setFont(obj["font"].toString(m_font));
}

QJsonObject AppearanceConfig::toJson() const {
    return {
        {"rounding", m_rounding},
        {"spacing",  m_spacing},
        {"font",     m_font},
    };
}

// ── NyxConfig ─────────────────────────────────────────────────────────────────
NyxConfig::NyxConfig(QObject* parent)
    : QObject(parent)
    , m_bar(new BarConfig(this))
    , m_appearance(new AppearanceConfig(this))
{
    s_instance = this;
    load();

    connect(&m_watcher, &QFileSystemWatcher::fileChanged, this, [this]() {
        load();
        emit loaded();
    });
}

NyxConfig* NyxConfig::create(QQmlEngine*, QJSEngine*) {
    return instance();
}

NyxConfig* NyxConfig::instance() {
    if (!s_instance)
        s_instance = new NyxConfig();
    return s_instance;
}

QString NyxConfig::configPath() const {
    const QString configDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
    return configDir + "/nyxde/nyxde.json";
}

void NyxConfig::load() {
    const QString path = configPath();
    QFile file(path);

    if (!file.exists()) {
        qCInfo(lcConfig) << "No config file found, using defaults. Will create on first save.";
        return;
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qCWarning(lcConfig) << "Failed to open config:" << path;
        return;
    }

    QJsonParseError err;
    const auto doc = QJsonDocument::fromJson(file.readAll(), &err);
    if (err.error != QJsonParseError::NoError) {
        qCWarning(lcConfig) << "Config parse error:" << err.errorString();
        return;
    }

    const auto root = doc.object();
    if (root.contains("theme")) m_theme = root["theme"].toString(m_theme);
    if (root.contains("mode"))  m_mode  = root["mode"].toString(m_mode);
    if (root.contains("bar"))        m_bar->loadJson(root["bar"].toObject());
    if (root.contains("appearance")) m_appearance->loadJson(root["appearance"].toObject());

    if (!m_watcher.files().contains(path))
        m_watcher.addPath(path);

    qCInfo(lcConfig) << "Config loaded from" << path;
    emit loaded();
}

void NyxConfig::save() {
    const QString path = configPath();
    QDir().mkpath(QFileInfo(path).dir().absolutePath());

    QJsonObject root {
        {"theme",      m_theme},
        {"mode",       m_mode},
        {"bar",        m_bar->toJson()},
        {"appearance", m_appearance->toJson()},
    };

    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        qCWarning(lcConfig) << "Failed to write config:" << path;
        return;
    }

    file.write(QJsonDocument(root).toJson(QJsonDocument::Indented));
    qCInfo(lcConfig) << "Config saved to" << path;
    emit saved();
}

void NyxConfig::reload() {
    load();
}
