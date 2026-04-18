#include "ImageAnalyser.hpp"
#include <QImage>
#include <QtConcurrent>
#include <QFutureWatcher>
#include <QLoggingCategory>
#include <cmath>
#include <unordered_map>

Q_LOGGING_CATEGORY(lcImage, "nyxde.imageanalyser")

ImageAnalyser::ImageAnalyser(QObject* parent) : QObject(parent) {}

void ImageAnalyser::setSource(const QString& path) {
    if (m_source == path) return;
    m_source = path;
    emit sourceChanged();
    requestUpdate();
}

void ImageAnalyser::requestUpdate() {
    if (m_source.isEmpty() || m_busy) return;

    m_busy = true;
    emit busyChanged();

    const QString path = m_source;
    auto* watcher = new QFutureWatcher<Result>(this);

    connect(watcher, &QFutureWatcher<Result>::finished, this, [this, watcher]() {
        const auto result = watcher->result();
        watcher->deleteLater();

        m_busy = false;
        emit busyChanged();

        if (m_dominantColor != result.color) {
            m_dominantColor = result.color;
            emit dominantColorChanged();
        }
        if (std::abs(m_luminance - result.luminance) > 0.01) {
            m_luminance = result.luminance;
            emit luminanceChanged();
        }
    });

    watcher->setFuture(QtConcurrent::run(&ImageAnalyser::analyse, path));
}

ImageAnalyser::Result ImageAnalyser::analyse(const QString& path) {
    QImage img(path);
    if (img.isNull()) {
        qCWarning(lcImage) << "Failed to load image:" << path;
        return { QColor("#cba6f7"), 0.3 };
    }

    // Scale down for speed — we only need color, not detail
    img = img.scaled(64, 64, Qt::KeepAspectRatio, Qt::FastTransformation)
              .convertToFormat(QImage::Format_RGB888);

    // K-means style: bucket colors into 8x8x8 grid, pick most frequent bucket
    std::unordered_map<int, int> buckets;
    buckets.reserve(512);

    const int w = img.width();
    const int h = img.height();

    for (int y = 0; y < h; ++y) {
        const auto* line = reinterpret_cast<const uchar*>(img.scanLine(y));
        for (int x = 0; x < w; ++x) {
            const int r = line[x * 3]     >> 5;  // 3 bits each → 8 buckets per channel
            const int g = line[x * 3 + 1] >> 5;
            const int b = line[x * 3 + 2] >> 5;
            ++buckets[(r << 6) | (g << 3) | b];
        }
    }

    int bestKey = 0, bestCount = 0;
    for (const auto& [key, count] : buckets) {
        if (count > bestCount) { bestCount = count; bestKey = key; }
    }

    // Reconstruct color from bucket center
    const int r = (((bestKey >> 6) & 7) << 5) | 16;
    const int g = (((bestKey >> 3) & 7) << 5) | 16;
    const int b = (( bestKey       & 7) << 5) | 16;

    const QColor dominant(r, g, b);

    // Relative luminance (sRGB)
    auto linearize = [](double c) {
        c /= 255.0;
        return c <= 0.04045 ? c / 12.92 : std::pow((c + 0.055) / 1.055, 2.4);
    };
    const double lum = 0.2126 * linearize(r) + 0.7152 * linearize(g) + 0.0722 * linearize(b);

    return { dominant, lum };
}
