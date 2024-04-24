#include "progressstorage.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <QStandardPaths>

ProgressStorage::ProgressStorage()
{
    setupDatabase();
}

QVariant ProgressStorage::getItemFromAchievementTypes(int index, int role)
{
    QVariant value;
    achievementType type;

    QSqlQuery query;

    if (!query.exec("SELECT Name, DataType, Color FROM AchievementTypes")) {
        std::cout << "ERROR | ProgressStorage::getItemFromAchievementTypes | Couldn't Select From AchievementTypes" << std::endl;
        return value;
    }

    query.first();

    for (int i = 0; i <= index; i++) {
        if (i != index)
            query.next();
        else {
            value = query.value(role);
            break;
        }
    }

    return value;
}

int ProgressStorage::getSizeAchievementTypes()
{
    return getSizeOfTable("AchievementTypes");
}

std::ostream& operator<<(std::ostream& stream, const achievementType& type) {
    stream << type.name.toStdString() << std::endl << type.dataType << std::endl << type.colorValue.name().toStdString();
    return stream;
}

void ProgressStorage::saveAchievementType(QString in_name, achievementDataType in_dataType, float r, float g, float b)
{
    emit preAchievementTypesItemAppended();

    if (!db.tables().contains("AchievementTypes")) {
        QSqlQuery query;
        query.prepare("CREATE TABLE AchievementTypes (Name VARCHAR(16), DataType int, Color VARCHAR(7));");

        if (!query.exec()) {
            std::cout << "ERROR | ProgressStorage::saveAchievementType | Could Not create table" << std::endl;
            return;
        }
    }

    QSqlQuery query;
    query.prepare("INSERT INTO AchievementTypes (Name, DataType, Color) VALUES (:name, :dataType, :color)");

    query.bindValue(":name", in_name);
    query.bindValue(":dataType", in_dataType);
    query.bindValue(":color", QColor(r * 255, g * 255, b * 255).name());

    if (!query.exec()) {
        std::cout << "ERROR | ProgressStorage::saveAchievementType | Could Not Add AchievementType" << std::endl;
    }

    emit postAchievementTypesItemAppended();
}

void ProgressStorage::setupDatabase()
{
    db = QSqlDatabase::addDatabase("QSQLITE");

    if (!QDir("SaveFolder").exists())
        QDir().mkdir("SaveFolder");

    db.setDatabaseName(QDir().absolutePath() + "/SaveFolder/savefile.sqlite");

    if (!db.open()) {
        std::cout << "ERROR | ProgressStorage::setupDatabase | database can't open" << std::endl;
    }
}

int ProgressStorage::getSizeOfTable(QString tableName)
{
    QSqlQuery query;
    query.exec("SELECT * FROM " + tableName);
    query.last();
    return query.at() + 1;
}

bool ProgressStorage::isDuplicateAchievement(QString tableName, int day, QString achievementName)
{
    QSqlQuery query;
    query.prepare("SELECT Day, AchievementName FROM " + tableName + " WHERE Day = " + QString::number(day));

    if (!query.exec()) {
        std::cout << "ERROR | ProgressStorage::checkDuplicateAchievement | Couldn't execute query" << std::endl;
    }


    if (!query.first()) {
        return false;
    }

    do {
        if (query.value(1).toString() == achievementName)
            return true;
    } while (query.next());

    return false;
}

DayModel* ProgressStorage::getDayModel(int year, int month, int day)
{
    QString tableName = monthStrings[month] + QString::number(year);
    Day temp(year, month, day);

    if (!db.tables().contains(tableName)) {
        std::cout << tableName << std::endl;
        std::cout << "ERROR | ProgressStorage::getDayModel | Could Not Find Table" << std::endl;

        DayModel* model = new DayModel(temp, this);

        connect(this, &ProgressStorage::preDayTypesItemAppended, model, &DayModel::preItemAdded);
        connect(this, &ProgressStorage::postDayTypesItemAppended, model, &DayModel::postItemAdded);

        return model;
    }

    QSqlQuery query;
    if (!query.exec("SELECT * FROM " + tableName + " WHERE Day = " + QString::number(day))) {
        std::cout << "ERROR | ProgressStorage::getDayModel | Couldn't execute first query" << std::endl;
    }

    if (!query.first()) {
        DayModel* model = new DayModel(temp, this);

        connect(this, &ProgressStorage::preDayTypesItemAppended, model, &DayModel::preItemAdded);
        connect(this, &ProgressStorage::postDayTypesItemAppended, model, &DayModel::postItemAdded);

        return model;
    }


    do {
        QSqlQuery query2;

        if (!query2.exec("SELECT * FROM AchievementTypes WHERE Name = '" + query.value(1).toString() + "'")) {
            std::cout << "ERROR | ProgressStorage::getDayModel | Could not select from second query" << std::endl;
        } else {

            if (!query2.first())
                std::cout << "ERROR | ProgressStorage::getDayModel | Could not get first value of second query" << std::endl;

            achievement achieve;

            achieve.type.name = query.value(1).toString();
            achieve.type.dataType = achievementDataType(query2.value(1).toInt());
            achieve.type.colorValue = query2.value(2).toString();
            achieve.value = query.value(3).toInt();

            temp.achievements.append(achieve);
        }
    } while (query.next());

    DayModel* model = new DayModel(temp, this);

    connect(this, &ProgressStorage::preDayTypesItemAppended, model, &DayModel::preItemAdded);
    connect(this, &ProgressStorage::postDayTypesItemAppended, model, &DayModel::postItemAdded);

    return model;
}

void ProgressStorage::addAchievement(int year, int month, int day, QString achievementName, achievementDataType in_dataType, QString color, int numberValue)
{
    QString tableName = monthStrings[month] + QString::number(year);

    if (!db.tables().contains(tableName)) {
        QSqlQuery query;
        query.prepare("CREATE TABLE " + tableName + " (Day int, AchievementName VARCHAR(16), DataType int, numberValue int);");

        if (!query.exec()) {
            std::cout << "ERROR | ProgressStorage::addAchievement | Could Not create table" << std::endl;
            return;
        }
    }

    if (isDuplicateAchievement(tableName, day, achievementName)) {
        std::cout << "ERROR | ProgressStorage::addAchievement | Duplicate Achievement Added" << std::endl;
        return;
    }

    achievement temp;
    temp.value = numberValue;
    temp.type = achievementType(achievementName, in_dataType, QColor(color));

    emit preDayTypesItemAppended(year, month, day, temp);

    QSqlQuery query;
    query.prepare("INSERT INTO " + tableName + " VALUES (:day, :achievementName, :dataType, :numberValue)");

    query.bindValue(":day", day);
    query.bindValue(":achievementName", achievementName);
    query.bindValue(":dataType", in_dataType);
    query.bindValue(":numberValue", numberValue);

    if (!query.exec()) {
        std::cout << "ERROR | ProgressStorage::addAchievement | Could Not Add Achievement" << std::endl;
    }

    emit postDayTypesItemAppended(year, month, day);
}
