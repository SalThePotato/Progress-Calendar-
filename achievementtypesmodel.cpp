#include "achievementtypesmodel.h"
#include <iostream>

AchievementTypesModel::AchievementTypesModel(ProgressStorage* in_storage)
    : storage{in_storage}
{
    beginResetModel();

    if (storage) {
        connect(storage, &ProgressStorage::preAchievementTypesItemAppended, this, [=]() {
            int index = this->storage->getSizeAchievementTypes();
            this->beginInsertRows(QModelIndex(), index, index);
        });

        connect(storage, &ProgressStorage::postAchievementTypesItemAppended, this, [=]() {
            endInsertRows();
        });
    }

    endResetModel();
}

int AchievementTypesModel::rowCount(const QModelIndex &parent) const
{
    return storage->getSizeAchievementTypes();
}

QVariant AchievementTypesModel::data(const QModelIndex &index, int role) const
{
    return storage->getItemFromAchievementTypes(index.row(), role);
}

QHash<int, QByteArray> AchievementTypesModel::roleNames() const
{
    QHash<int, QByteArray> roleHash;

    roleHash[name] = "name";
    roleHash[dataType] = "dataType";
    roleHash[color] = "color";

    return roleHash;
}
