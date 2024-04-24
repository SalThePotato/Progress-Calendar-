#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "progressstorage.h"
#include "achievementtypesmodel.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ProgressStorage* storage = new ProgressStorage;
    AchievementTypesModel* achievementModel = new AchievementTypesModel(storage);
    engine.rootContext()->setContextProperty("ProgressStorage", storage);
    engine.rootContext()->setContextProperty("AchievementModel", achievementModel);

    engine.load("qrc:/windows/main.qml");

    return app.exec();
}

