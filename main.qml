import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "qrc:/"

Window {
    id: root;
    width: 750;
    height: 560;
    color: "#4287f5";
    visible: true;
    flags: Qt.Window | Qt.FramelessWindowHint;

    Item {
        id: contentScreen;
        width: (infoDay.visible) ? root.width - infoDay.width : root.width;
        height: root.height - taskbar.height;
    }

    ToolBar {
        id: taskbar
        anchors.top: parent.top;
        width: parent.width;
        height: 30;

        background: Rectangle {
            anchors.fill: parent
            color: "gray";
        }


        RowLayout {
            anchors.fill: parent;
            spacing: 0;

            Image {
                source: "qrc:/Images/icon.png"
                Layout.maximumWidth: parent.height;
                Layout.fillHeight: true;
            }

            MenuBar {
                Layout.fillWidth: true;
                Layout.fillHeight: true;

                background: Rectangle {
                    anchors.fill: parent
                    color: "gray";
                }

                Menu {
                    title: "Options"

                    MenuItem {
                        text: "Add Achievement Type"

                        onTriggered: {var newWindow = Qt.createComponent("qrc:/windows/AddAchievementType.qml", root); newWindow.createObject();}

                        background: Rectangle {
                            anchors.fill: parent
                            color: "gray";
                        }
                    }

                    MenuItem {
                        text: "View all Achievement Types"

                        onTriggered: {var newWindow = Qt.createComponent("qrc:/windows/ViewAllAchievementTypes.qml", root); newWindow.createObject();}

                        background: Rectangle {
                            anchors.fill: parent
                            color: "gray";
                        }
                    }
                }

                Menu {
                    title: "Months"

                    MenuItem {
                        text: "Next Month"

                        onTriggered: {
                            var newMonth = calenderGrid.month;
                            var newYear = calenderGrid.year;

                            if ((newMonth + 1) > 11) {
                                newMonth = 0;
                                newYear = calenderGrid.year + 1;
                            } else
                                newMonth += 1;

                            calenderGrid.reset(newYear, newMonth);
                        }
                        background: Rectangle {
                            anchors.fill: parent
                            color: "gray";
                        }
                    }

                    MenuItem {
                        text: "Previous Month"

                        onTriggered: {
                            var newMonth = calenderGrid.month;
                            var newYear = calenderGrid.year;
                            if ((newMonth - 1) < 0) {
                                newMonth = 11;
                                newYear = calenderGrid.year - 1;
                            } else
                                newMonth -= 1;

                            calenderGrid.reset(newYear, newMonth);
                        }
                        background: Rectangle {
                            anchors.fill: parent
                            color: "gray";
                        }
                    }

                    MenuItem {
                        text: "Current Month"

                        onTriggered: {
                            var day = new Date();

                            calenderGrid.reset(day.getFullYear(), day.getMonth());
                        }
                        background: Rectangle {
                            anchors.fill: parent
                            color: "gray";
                        }
                    }
                }
            }


            Image {
                Layout.minimumWidth: parent.height;
                Layout.maximumWidth: parent.height;
                Layout.fillHeight: true;
                Layout.margins: 0;
                source: "qrc:/Images/Minimize_Icon.png"

                Rectangle {
                    anchors.fill: parent;
                    opacity: 0;
                    color: "white";

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {root.visibility = Window.Minimized}
                        hoverEnabled: true;
                        onEntered: parent.opacity = 0.5;
                        onExited: parent.opacity = 0;
                    }
                }
            }

            Image {
                Layout.minimumWidth: parent.height;
                Layout.maximumWidth: parent.height;
                Layout.fillHeight: true;
                Layout.margins: 0;
                source: "qrc:/Images/Square_Icon.png"

                Rectangle {
                    anchors.fill: parent;
                    opacity: 0;
                    color: "white";

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {root.visibility === Window.Maximized ? root.visibility = Window.Windowed : root.visibility = Window.Maximized}
                        hoverEnabled: true;
                        onEntered: parent.opacity = 0.5;
                        onExited: parent.opacity = 0;
                    }
                }
            }

            Image {
                Layout.minimumWidth: parent.height;
                Layout.maximumWidth: parent.height;
                Layout.fillHeight: true;
                Layout.margins: 0;
                source: "qrc:/Images/X_Icon.png"

                Rectangle {
                    anchors.fill: parent;
                    opacity: 0;
                    color: "white";

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {Qt.quit()}
                        hoverEnabled: true;
                        onEntered: parent.opacity = 0.5;
                        onExited: parent.opacity = 0;
                    }
                }
            }
        }

        Item {
            anchors.fill: parent;
            z: -1;
            DragHandler {
                onActiveChanged: {root.startSystemMove()
                    if (root.y <= 0)
                        root.visibility = Window.Maximized;
                }
            }
        }
    }

    Calender {
        id: calenderGrid;
    }

    Item {
        anchors.fill: parent;
        Rectangle {
            id: infoDay
            width: parent.width * 0.2;
            height: contentScreen.height;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            border.color: "black";
            border.width: 3;
            color: "white";
            visible: false;

            property int selectedYear;
            property int selectedMonth;
            property int selectedDay;

            Rectangle {
                id: infoDayTopBox
                width: parent.width;
                height: parent.height * 0.2;
                color: "#022c59";

                Text {
                    id: infoDayTitleText
                    text: "e";
                    anchors.centerIn: parent;
                    color: "white";

                    fontSizeMode: Text.Fit;
                    font.pixelSize: 20;
                }

                Rectangle {
                    width: parent.width * 0.1;
                    height: parent.width * 0.1;
                    color: "#00000000";

                    border {
                        width: 1
                        color: "black"
                    }

                    anchors {
                        top: parent.top;
                        right: parent.right;
                        topMargin: 10;
                        rightMargin: 10;
                    }
                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: parent.color = "red";
                        onExited: parent.color = "#00000000"
                        onClicked: {
                            infoDay.visible = false;
                        }
                    }
                }
            }

            Column {
                width: parent.width;
                height: parent.height - infoDayTopBox.height;
                spacing: 20;

                anchors {
                    top: infoDayTopBox.bottom;
                    topMargin: (parent.height - infoDayTopBox.height) * 0.025;
                }

                ListView {
                    id: achievementListView
                    model: 0;
                    width: parent.width * 0.9;
                    height: (parent.height - infoDayTopBox.height);
                    spacing: 10;
                    clip: true;

                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                    }

                    delegate: Rectangle {
                        width: ListView.view.width;
                        height: 50;
                        color: model.color;

                        border {
                            width: 1;
                            color: "black";
                        }

                        Column {
                            anchors.centerIn: parent;
                            Text {
                                text: model.name;
                                font.bold: true;
                                color: "white";
                                anchors.horizontalCenter: parent.horizontalCenter;
                            }

                            Text {
                                visible: (model.dataType === 1) ? true : false;
                                text: model.numberValue;
                                color: "white";
                                anchors.horizontalCenter: parent.horizontalCenter;
                            }
                        }
                    }

                    Rectangle {
                        // Border
                        anchors.fill: parent;
                        color: "#00000000";

                        border {
                            width: 2;
                            color: "black";
                        }
                    }
                }

                Rectangle {
                    // Add Achievement Button
                    width: achievementListView.width;
                    height: (parent.height - infoDayTopBox.height) * 0.1;
                    color: "green"

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        anchors.centerIn: parent;
                        text: "Add Achievement";
                        color: "white";
                    }

                    MouseArea {
                        anchors.fill: parent;

                        onClicked: {
                            var newWindow = Qt.createComponent("qrc:/windows/AddAchievement.qml", root);
                            newWindow.createObject();
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        // Border for entire Window
        anchors.fill: parent;
        border.color: "black";
        border.width: 2;
        color: "#00000000";
    }
}
