#include "SparklineItem.hpp"
#include <QPainter>
#include <QPainterPath>

SparklineItem::SparklineItem(QQuickItem* parent) : QQuickPaintedItem(parent) {
    setAntialiasing(true);
}

void SparklineItem::setBuffer(CircularBuffer* buf) {
    if (m_buffer == buf) return;
    if (m_buffer) disconnect(m_buffer, nullptr, this, nullptr);
    m_buffer = buf;
    if (m_buffer) connect(m_buffer, &CircularBuffer::valuesChanged, this, [this]{ update(); });
    emit bufferChanged();
    update();
}

void SparklineItem::paint(QPainter* painter) {
    if (!m_buffer || m_buffer->count() < 2) return;

    const auto values = m_buffer->values();
    const int  n      = values.size();
    const qreal W     = width();
    const qreal H     = height();
    const qreal max   = m_maxValue > 0 ? m_maxValue : 1.0;

    auto xAt = [&](int i) { return (qreal(i) / (n - 1)) * W; };
    auto yAt = [&](qreal v) { return H - (v / max) * H; };

    QPainterPath path;
    path.moveTo(xAt(0), yAt(values[0]));
    for (int i = 1; i < n; ++i)
        path.lineTo(xAt(i), yAt(values[i]));

    // Fill under line
    QPainterPath fill = path;
    fill.lineTo(W, H);
    fill.lineTo(0, H);
    fill.closeSubpath();

    painter->setPen(Qt::NoPen);
    painter->setBrush(m_fillColor);
    painter->drawPath(fill);

    // Line on top
    painter->setPen(QPen(m_lineColor, m_lineWidth, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    painter->setBrush(Qt::NoBrush);
    painter->drawPath(path);
}
