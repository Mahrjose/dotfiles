#pragma once
#include <QObject>
#include <QColor>
#include <QString>
#include <QFuture>
#include <QtQml/qqmlregistration.h>

// Extracts dominant color and luminance from an image path.
// Runs in a QThreadPool thread — no blocking the UI.
class ImageAnalyser : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString source         READ source         WRITE setSource         NOTIFY sourceChanged)
    Q_PROPERTY(QColor  dominantColor  READ dominantColor                          NOTIFY dominantColorChanged)
    Q_PROPERTY(double  luminance      READ luminance                              NOTIFY luminanceChanged)
    Q_PROPERTY(bool    busy           READ busy                                   NOTIFY busyChanged)

public:
    explicit ImageAnalyser(QObject* parent = nullptr);

    QString source()        const { return m_source; }
    QColor  dominantColor() const { return m_dominantColor; }
    double  luminance()     const { return m_luminance; }
    bool    busy()          const { return m_busy; }

    void setSource(const QString& path);

    Q_INVOKABLE void requestUpdate();

signals:
    void sourceChanged();
    void dominantColorChanged();
    void luminanceChanged();
    void busyChanged();

private:
    struct Result { QColor color; double luminance; };
    static Result analyse(const QString& path);

    QString m_source;
    QColor  m_dominantColor { "#cba6f7" };
    double  m_luminance     { 0.3 };
    bool    m_busy          { false };
    QFuture<Result> m_future;
};
