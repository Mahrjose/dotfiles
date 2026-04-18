#pragma once
#include <QObject>
#include <QList>
#include <QtQml/qqmlregistration.h>

class CircularBuffer : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int         capacity READ capacity WRITE setCapacity NOTIFY capacityChanged)
    Q_PROPERTY(int         count    READ count                      NOTIFY countChanged)
    Q_PROPERTY(QList<qreal> values  READ values                     NOTIFY valuesChanged)
    Q_PROPERTY(qreal       maximum  READ maximum                    NOTIFY valuesChanged)

public:
    explicit CircularBuffer(QObject* parent = nullptr) : QObject(parent) {}

    int          capacity() const { return m_capacity; }
    int          count()    const { return m_data.size(); }
    QList<qreal> values()   const { return m_data; }
    qreal        maximum()  const;

    void setCapacity(int cap);

    Q_INVOKABLE void push(qreal value);
    Q_INVOKABLE void clear();
    Q_INVOKABLE qreal at(int index) const;

signals:
    void capacityChanged();
    void countChanged();
    void valuesChanged();

private:
    int          m_capacity = 60;
    QList<qreal> m_data;
};
