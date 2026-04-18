#pragma once
#include <QObject>
#include <QColor>
#include <QString>
#include <QJsonObject>
#include <QFileSystemWatcher>
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

// ── Bar config ────────────────────────────────────────────────────────────────
class BarConfig : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(int height       READ height       WRITE setHeight       NOTIFY heightChanged)
    Q_PROPERTY(bool showTitle   READ showTitle    WRITE setShowTitle    NOTIFY showTitleChanged)
    Q_PROPERTY(bool showTray    READ showTray     WRITE setShowTray     NOTIFY showTrayChanged)
    Q_PROPERTY(bool showMedia   READ showMedia    WRITE setShowMedia    NOTIFY showMediaChanged)

public:
    explicit BarConfig(QObject* parent = nullptr) : QObject(parent) {}

    int  height()    const { return m_height; }
    bool showTitle() const { return m_showTitle; }
    bool showTray()  const { return m_showTray; }
    bool showMedia() const { return m_showMedia; }

    void setHeight(int v)      { if (m_height    != v) { m_height    = v; emit heightChanged(); } }
    void setShowTitle(bool v)  { if (m_showTitle  != v) { m_showTitle  = v; emit showTitleChanged(); } }
    void setShowTray(bool v)   { if (m_showTray   != v) { m_showTray   = v; emit showTrayChanged(); } }
    void setShowMedia(bool v)  { if (m_showMedia  != v) { m_showMedia  = v; emit showMediaChanged(); } }

    void loadJson(const QJsonObject& obj);
    QJsonObject toJson() const;

signals:
    void heightChanged();
    void showTitleChanged();
    void showTrayChanged();
    void showMediaChanged();

private:
    int  m_height    = 36;
    bool m_showTitle = true;
    bool m_showTray  = true;
    bool m_showMedia = true;
};

// ── Appearance config ─────────────────────────────────────────────────────────
class AppearanceConfig : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(int    rounding  READ rounding  WRITE setRounding  NOTIFY roundingChanged)
    Q_PROPERTY(int    spacing   READ spacing   WRITE setSpacing   NOTIFY spacingChanged)
    Q_PROPERTY(QString font     READ font      WRITE setFont      NOTIFY fontChanged)

public:
    explicit AppearanceConfig(QObject* parent = nullptr) : QObject(parent) {}

    int     rounding() const { return m_rounding; }
    int     spacing()  const { return m_spacing; }
    QString font()     const { return m_font; }

    void setRounding(int v)     { if (m_rounding != v) { m_rounding = v; emit roundingChanged(); } }
    void setSpacing(int v)      { if (m_spacing  != v) { m_spacing  = v; emit spacingChanged(); } }
    void setFont(const QString& v) { if (m_font  != v) { m_font     = v; emit fontChanged(); } }

    void loadJson(const QJsonObject& obj);
    QJsonObject toJson() const;

signals:
    void roundingChanged();
    void spacingChanged();
    void fontChanged();

private:
    int     m_rounding = 8;
    int     m_spacing  = 8;
    QString m_font     = "JetBrainsMono Nerd Font";
};

// ── Root config singleton ─────────────────────────────────────────────────────
class NyxConfig : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(BarConfig*        bar        READ bar        CONSTANT)
    Q_PROPERTY(AppearanceConfig* appearance READ appearance CONSTANT)
    Q_PROPERTY(QString           theme      READ theme      WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(QString           mode       READ mode       WRITE setMode  NOTIFY modeChanged)

public:
    explicit NyxConfig(QObject* parent = nullptr);

    static NyxConfig* create(QQmlEngine*, QJSEngine*);
    static NyxConfig* instance();

    BarConfig*        bar()        const { return m_bar; }
    AppearanceConfig* appearance() const { return m_appearance; }
    QString           theme()      const { return m_theme; }
    QString           mode()       const { return m_mode; }

    void setTheme(const QString& v) { if (m_theme != v) { m_theme = v; emit themeChanged(); save(); } }
    void setMode(const QString& v)  { if (m_mode  != v) { m_mode  = v; emit modeChanged();  save(); } }

    Q_INVOKABLE void save();
    Q_INVOKABLE void reload();

signals:
    void themeChanged();
    void modeChanged();
    void loaded();
    void saved();

private:
    void load();
    QString configPath() const;

    BarConfig*        m_bar;
    AppearanceConfig* m_appearance;
    QString           m_theme = "CyberVoid";
    QString           m_mode  = "normal";
    QFileSystemWatcher m_watcher;

    static NyxConfig* s_instance;
};
