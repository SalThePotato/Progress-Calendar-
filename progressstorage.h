#ifndef PROGRESSSTORAGE_H
#define PROGRESSSTORAGE_H

#include <QObject>
#include <QColor>
#include <QVector>
#include <QVariant>
#include <QMetaType>
#include <QtSql>
#include "dayModel.h"

Q_DECLARE_METATYPE(achievementType);
Q_DECLARE_METATYPE(Day);

class ProgressStorage : public QObject
{
    Q_OBJECT

public:

    std::array<QString, 12> monthStrings{"January","February","March","April","May","June","July","August","September","October","November","December"};

    ProgressStorage();
    Q_INVOKABLE DayModel* getDayModel(int year, int month, int day);
    Q_INVOKABLE void addAchievement(int year, int month, int day, QString in_name, achievementDataType in_dataType, QString color, int numberValue = 0);

    QVariant getItemFromAchievementTypes(int index, int role);
    int getSizeAchievementTypes();
    Q_INVOKABLE void saveAchievementType(QString achievementName, achievementDataType in_dataType, float r, float g, float b);

    void setupDatabase();
    int getSizeOfTable(QString tableName);
    bool isDuplicateAchievement(QString tableName, int day, QString achievementName);

signals:
    void preAchievementTypesItemAppended();
    void postAchievementTypesItemAppended();

    void preDayTypesItemAppended(int year, int month, int day, achievement achieve);
    void postDayTypesItemAppended(int year, int month, int day);

private:
    QSqlDatabase db;
};

#endif // PROGRESSSTORAGE_H
