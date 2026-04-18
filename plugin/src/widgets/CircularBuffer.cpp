#include "CircularBuffer.hpp"
#include <algorithm>

qreal CircularBuffer::maximum() const {
    if (m_data.isEmpty()) return 0;
    return *std::max_element(m_data.cbegin(), m_data.cend());
}

void CircularBuffer::setCapacity(int cap) {
    if (m_capacity == cap || cap < 1) return;
    m_capacity = cap;
    while (m_data.size() > m_capacity)
        m_data.removeFirst();
    emit capacityChanged();
    emit valuesChanged();
}

void CircularBuffer::push(qreal value) {
    if (m_data.size() >= m_capacity)
        m_data.removeFirst();
    m_data.append(value);
    emit valuesChanged();
    if (m_data.size() == 1) emit countChanged();
}

void CircularBuffer::clear() {
    if (m_data.isEmpty()) return;
    m_data.clear();
    emit countChanged();
    emit valuesChanged();
}

qreal CircularBuffer::at(int index) const {
    if (index < 0 || index >= m_data.size()) return 0;
    return m_data.at(index);
}
