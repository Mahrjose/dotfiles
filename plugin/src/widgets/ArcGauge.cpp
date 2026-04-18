#include "ArcGauge.hpp"
#include <QPainter>
#include <QPainterPath>
#include <QtMath>

ArcGauge::ArcGauge(QQuickItem* parent) : QQuickPaintedItem(parent) {
    setAntialiasing(true);
}

void ArcGauge::paint(QPainter* painter) {
    const qreal W     = width();
    const qreal H     = height();
    const qreal lw    = m_lineWidth;
    const qreal pad   = lw / 2.0 + 1.0;
    const QRectF rect(pad, pad, W - pad * 2, H - pad * 2);

    const qreal range    = m_maximum - m_minimum;
    const qreal fraction = range > 0 ? qBound(0.0, (m_value - m_minimum) / range, 1.0) : 0.0;

    // Qt drawArc: angles in 1/16th degrees, CCW from 3 o'clock
    const int startQt = qRound(m_startAngle * 16);
    const int spanQt  = qRound(m_spanAngle  * 16);
    const int fillQt  = qRound(fraction * m_spanAngle * 16);

    QPen pen;
    pen.setCapStyle(Qt::RoundCap);
    pen.setWidth(qRound(lw));

    // Track (background arc)
    pen.setColor(m_trackColor);
    painter->setPen(pen);
    painter->drawArc(rect, startQt, -spanQt);

    // Value arc
    if (fillQt > 0) {
        pen.setColor(m_arcColor);
        painter->setPen(pen);
        painter->drawArc(rect, startQt, -fillQt);
    }
}
