#include <QObject>
#include <QColor>
#include <iostream>


enum achievementDataType {
    boolType, numberType
};

struct achievementType {
    QString name;
    achievementDataType dataType;
    QColor colorValue;

    achievementType(QString in_name = "", achievementDataType in_dataType = achievementDataType::boolType, QColor in_colorValue = QColor(0, 0, 0, 0))
        : name{in_name}, dataType{in_dataType}, colorValue{in_colorValue}
    {
    }
};

struct achievement {
    achievementType type;
    int value;

    achievement(achievementType in_achievementType = achievementType(), int in_value = 0)
        : type{in_achievementType}, value{in_value}
    {}
};

struct Day {
    int year;
    int month;
    int day;
    QVector<achievement> achievements{};

    Day(int in_year, int in_month, int in_day) : year{in_year}, month{in_month}, day{in_day}
    {}
};
