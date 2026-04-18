#pragma once
#include <QQuickPaintedItem>
#include <QColor>
#include <QtQml/qqmlregistration.h>
#include "CircularBuffer.hpp"

// Renders a smooth filled sparkline graph from a CircularBuffer.
class SparklineItem : public QQuickPaintedItem {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(CircularBuffer* buffer     READ buffer     WRITE setBuffer     NOTIFY bufferChanged)
    Q_PROPERTY(QColor          lineColor  READ lineColor  WRITE setLineColor  NOTIFY lineColorChanged)
    Q_PROPERTY(QColor          fillColor  READ fillColor  WRITE setFillColor  NOTIFY fillColorChanged)
    Q_PROPERTY(qreal           lineWidth  READ lineWidth  WRITE setLineWidth  NOTIFY lineWidthChanged)
    Q_PROPERTY(qreal           maxValue   READ maxValue   WRITE setMaxValue   NOTIFY maxValueChanged)

public:
    explicit SparklineItem(QQuickItem* parent = nullptr);

    CircularBuffer* buffer()    const { return m_buffer; }
    QColor  lineColor()         const { return m_lineColor; }
    QColor  fillColor()         const { return m_fillColor; }
    qreal   lineWidth()         const { return m_lineWidth; }
    qreal   maxValue()          const { return m_maxValue; }

    void setBuffer(CircularBuffer* buf);
    void setLineColor(const QColor& c)  { if (m_lineColor != c) { m_lineColor = c; emit lineColorChanged(); update(); } }
    void setFillColor(const QColor& c)  { if (m_fillColor != c) { m_fillColor = c; emit fillColorChanged(); update(); } }
    void setLineWidth(qreal w)          { if (m_lineWidth != w) { m_lineWidth = w; emit lineWidthChanged(); update(); } }
    void setMaxValue(qreal v)           { if (m_maxValue  != v) { m_maxValue  = v; emit maxValueChanged();  update(); } }

    void paint(QPainter* painter) override;

signals:
    void bufferChanged();
    void lineColorChanged();
    void fillColorChanged();
    void lineWidthChanged();
    void maxValueChanged();

private:
    CircularBuffer* m_buffer    = nullptr;
    QColor          m_lineColor { "#89b4fa" };
    QColor          m_fillColor { "#2089b4fa" };
    qreal           m_lineWidth { 1.5 };
    qreal           m_maxValue  { 100.0 };
};
