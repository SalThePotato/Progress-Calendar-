#ifndef DAYMODEL_H
#define DAYMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "achievementStructs.cpp"

class DayModel : public QAbstractListModel
{
public:
    enum roles {
        name, dataType, color, numberValue
    };

    DayModel(Day in_day, QObject* parent = nullptr);
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void begin() {
        beginResetModel();
    }

    void end() {
        endResetModel();
    }

public slots:
    void preItemAdded(int year, int month, int day, achievement achieve);
    void postItemAdded(int year, int month, int day);

private:
    Day m_day;
};

#endif // DAYMODEL_H
