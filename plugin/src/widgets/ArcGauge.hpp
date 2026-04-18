#pragma once
#include <QQuickPaintedItem>
#include <QColor>
#include <QtQml/qqmlregistration.h>

// Circular arc progress gauge — battery, CPU, etc.
class ArcGauge : public QQuickPaintedItem {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(qreal  value       READ value       WRITE setValue       NOTIFY valueChanged)
    Q_PROPERTY(qreal  minimum     READ minimum     WRITE setMinimum     NOTIFY minimumChanged)
    Q_PROPERTY(qreal  maximum     READ maximum     WRITE setMaximum     NOTIFY maximumChanged)
    Q_PROPERTY(QColor arcColor   READ arcColor    WRITE setArcColor    NOTIFY arcColorChanged)
    Q_PROPERTY(QColor trackColor  READ trackColor  WRITE setTrackColor  NOTIFY trackColorChanged)
    Q_PROPERTY(qreal  lineWidth   READ lineWidth   WRITE setLineWidth   NOTIFY lineWidthChanged)
    Q_PROPERTY(qreal  startAngle  READ startAngle  WRITE setStartAngle  NOTIFY startAngleChanged)
    Q_PROPERTY(qreal  spanAngle   READ spanAngle   WRITE setSpanAngle   NOTIFY spanAngleChanged)

public:
    explicit ArcGauge(QQuickItem* parent = nullptr);

    qreal  value()      const { return m_value; }
    qreal  minimum()    const { return m_minimum; }
    qreal  maximum()    const { return m_maximum; }
    QColor arcColor()   const { return m_arcColor; }
    QColor trackColor() const { return m_trackColor; }
    qreal  lineWidth()  const { return m_lineWidth; }
    qreal  startAngle() const { return m_startAngle; }
    qreal  spanAngle()  const { return m_spanAngle; }

    void setValue(qreal v)          { if (m_value      != v) { m_value      = v; emit valueChanged();      update(); } }
    void setMinimum(qreal v)        { if (m_minimum     != v) { m_minimum     = v; emit minimumChanged();    update(); } }
    void setMaximum(qreal v)        { if (m_maximum     != v) { m_maximum     = v; emit maximumChanged();    update(); } }
    void setArcColor(const QColor& c)  { if (m_arcColor   != c) { m_arcColor   = c; emit arcColorChanged();   update(); } }
    void setTrackColor(const QColor& c){ if (m_trackColor  != c) { m_trackColor  = c; emit trackColorChanged(); update(); } }
    void setLineWidth(qreal w)      { if (m_lineWidth   != w) { m_lineWidth   = w; emit lineWidthChanged();  update(); } }
    void setStartAngle(qreal a)     { if (m_startAngle  != a) { m_startAngle  = a; emit startAngleChanged(); update(); } }
    void setSpanAngle(qreal a)      { if (m_spanAngle   != a) { m_spanAngle   = a; emit spanAngleChanged();  update(); } }

    void paint(QPainter* painter) override;

signals:
    void valueChanged();
    void minimumChanged();
    void maximumChanged();
    void arcColorChanged();
    void trackColorChanged();
    void lineWidthChanged();
    void startAngleChanged();
    void spanAngleChanged();

private:
    qreal  m_value      { 0.0 };
    qreal  m_minimum    { 0.0 };
    qreal  m_maximum    { 100.0 };
    QColor m_arcColor   { "#cba6f7" };
    QColor m_trackColor { "#313244" };
    qreal  m_lineWidth  { 4.0 };
    qreal  m_startAngle { 225.0 };   // degrees, Qt convention: 0=3 o'clock, CCW
    qreal  m_spanAngle  { 270.0 };   // total sweep
};
