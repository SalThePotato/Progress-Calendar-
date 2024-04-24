#ifndef ACHIEVEMENTTYPESMODEL_H
#define ACHIEVEMENTTYPESMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "progressstorage.h"

class AchievementTypesModel : public QAbstractListModel
{

public:
    enum roles {
      name, dataType, color
    };

    AchievementTypesModel(ProgressStorage* storage);
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    ProgressStorage* storage;
};

#endif // ACHIEVEMENTTYPESMODEL_H
