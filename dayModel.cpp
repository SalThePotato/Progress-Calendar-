#include "dayModel.h"

DayModel::DayModel(Day in_day, QObject* parent)
    : QAbstractListModel(parent), m_day{in_day}
{

}

int DayModel::rowCount(const QModelIndex &parent) const
{
    return m_day.achievements.size();
}

QVariant DayModel::data(const QModelIndex &index, int role) const
{
    const achievement* temp = &m_day.achievements[index.row()];

    switch (role) {
        case name: return QVariant(temp->type.name);
        case dataType: return QVariant(temp->type.dataType);
        case color: return QVariant(temp->type.colorValue.name());
        case numberValue: return QVariant(temp->value);
    }

    return QVariant();
}

QHash<int, QByteArray> DayModel::roleNames() const
{
    QHash<int, QByteArray> roleHash;

    roleHash[name] = "name";
    roleHash[dataType] = "dataType";
    roleHash[color] = "color";
    roleHash[numberValue] = "numberValue";

    return roleHash;
}

void DayModel::preItemAdded(int year, int month, int day, achievement achieve)
{
    if (year == m_day.year && month == m_day.month && day == m_day.day) {
        int index = m_day.achievements.size();
        beginInsertRows(QModelIndex(), index, index);
        m_day.achievements.append(achieve);
    } else
        return;
}

void DayModel::postItemAdded(int year, int month, int day)
{
    if (year == m_day.year && month == m_day.month && day == m_day.day) {
        endInsertRows();
    } else
        return;
}
