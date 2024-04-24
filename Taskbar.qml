import QtQuick 2.15
import QtQuick.Controls

Rectangle {
    width: root.width;
    height: 25;
    color: "black";

    property bool beMaximized: true;
    property bool showMinimzieButton: true;
    property bool showAddAchievementButton: true;
    property bool showViewAllAchievementsButton: true;
    property bool closeWindowOnly: false;

    Item {
        anchors.fill: parent;
        z: -1;
        DragHandler {
            onActiveChanged: {root.startSystemMove()
                if (root.y <= 0 && beMaximized == true)
                    root.visibility = Window.Maximized;
            }
        }
    }

    Rectangle {
        id: taskbarQuitButton
        width: parent.height;
        height: parent.height;
        anchors.right: parent.right;
        color: "white";
        border.width: 1;
        border.color: "black";

        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: parent.color = "gray";
            onExited: parent.color = "white";
            onClicked: {
                if (closeWindowOnly == false)
                    Qt.quit();
                else
                    root.close();
            }
        }
    }

    Rectangle {
        id: taskbarMaximizeButton
        width: parent.height;
        height: parent.height;
        anchors.right: taskbarQuitButton.left;
        color: "white";
        border.width: 1;
        border.color: "black";
        visible: beMaximized;

        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: parent.color = "gray";
            onExited: parent.color = "white";
            onClicked: {root.visibility === Window.Maximized ? root.visibility = Window.Windowed : root.visibility = Window.Maximized}
        }
    }

    Rectangle {
        id: taskbarMinimizeButton
        width: parent.height;
        height: parent.height;
        anchors.right: taskbarMaximizeButton.left;
        color: "white";
        border.width: 1;
        border.color: "black";
        visible: showMinimzieButton;

        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: parent.color = "gray";
            onExited: parent.color = "white";
            onClicked: {root.visibility = Window.Minimized}
        }
    }

    ComboBox {
        id: optionsDropdown
        visible: showViewAllAchievementsButton;
        anchors.left: parent.left;
        anchors.leftMargin: 2;
        width: parent.height * 2;
        height: parent.height;
        model: 2;

        background: Rectangle {
            id: optionsBox
            anchors.fill: parent;
            color: "white";
            z: 1;
            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true;
                onEntered: parent.color = "gray";
                onExited: (optionsPopup.opened) ? parent.color = "gray" : parent.color = "white";
                onClicked: (optionsPopup.opened) ? optionsPopup.close() : optionsPopup.open();

            }

            Text {
                anchors.centerIn: parent;
                width: parent.width * 0.8;
                height: parent.height * 0.8;
                text: "Options";

            }
        }


        popup: Popup {
            id: optionsPopup;
            y: parent.height - 1
            width: parent.width * 3;
            height: parent.height * 2;
            onOpenedChanged: {(optionsPopup.opened) ? optionsBox.color = "gray" : optionsBox.color = "white"}
            contentItem: Column {
                anchors.fill: parent;
                Rectangle {
                    color: "white";
                    width: parent.width;
                    height: parent.height / 2;

                    border {
                        width: 1;
                        color: "black"
                    }

                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: parent.color = "gray";
                        onExited: parent.color = "white";
                        onClicked: {var newWindow = Qt.createComponent("qrc:/windows/AddAchievementType.qml", root); newWindow.createObject(); optionsPopup.close()}
                    }

                    Text {
                        anchors.centerIn: parent;
                        width: parent.width
                        height: parent.height;
                        wrapMode : Text.Wrap;
                        fontSizeMode: Text.Fit;
                        minimumPixelSize: 1;
                        font.pixelSize: 40;
                        text: "Add Achievement Type";
                        color: "black";
                    }
                }
                Rectangle {
                    color: "white";
                    width: parent.width;
                    height: parent.height / 2;

                    border {
                        width: 1;
                        color: "black"
                    }

                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: parent.color = "gray";
                        onExited: parent.color = "white";
                        onClicked: {var newWindow = Qt.createComponent("qrc:/windows/ViewAllAchievementTypes.qml", root); newWindow.createObject(); optionsPopup.close()}
                    }

                    Text {
                        anchors.centerIn: parent;
                        width: parent.width
                        height: parent.height;
                        wrapMode : Text.Wrap;
                        fontSizeMode: Text.Fit;
                        minimumPixelSize: 1;
                        font.pixelSize: 40;
                        text: "View all Achievement Types";
                        color: "black";
                    }
                }

            }
        }
    }

    ComboBox {
        id: monthDropdown
        visible: showViewAllAchievementsButton;
        anchors.left: optionsDropdown.right;
        anchors.leftMargin: 2;
        width: parent.height * 2;
        height: parent.height;
        model: 2;

        background: Rectangle {
            id: monthBox
            anchors.fill: parent;
            color: "white";
            z: 1;
            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true;
                onEntered: parent.color = "gray";
                onExited: (monthPopup.opened) ? parent.color = "gray" : parent.color = "white";
                onClicked: (monthPopup.opened) ? monthPopup.close() : monthPopup.open();

            }

            Text {
                anchors.centerIn: parent;
                width: parent.width * 0.8;
                height: parent.height * 0.8;
                text: "Month";

            }
        }


        popup: Popup {
            id: monthPopup;
            y: parent.height - 1
            width: parent.width * 3;
            height: parent.height * 2;
            onOpenedChanged: {(monthPopup.opened) ? monthBox.color = "gray" : monthBox.color = "white"}
            contentItem: Column {
                anchors.fill: parent;
                Rectangle {
                    color: "white";
                    width: parent.width;
                    height: parent.height / 2;

                    border {
                        width: 1;
                        color: "black"
                    }

                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: parent.color = "gray";
                        onExited: parent.color = "white";
                        onClicked: {
                            var newMonth = calenderGrid.month;
                            var newYear = calenderGrid.year;
                            if ((newMonth - 1) < 0) {
                                newMonth = 11;
                                newYear = calenderGrid.year - 1;
                            } else
                                newMonth -= 1;

                            calenderGrid.reset(newYear, newMonth);
                        }
                    }

                    Text {
                        anchors.centerIn: parent;
                        width: parent.width
                        height: parent.height;
                        wrapMode : Text.Wrap;
                        fontSizeMode: Text.Fit;
                        minimumPixelSize: 1;
                        font.pixelSize: 40;
                        text: "Previous Month";
                        color: "black";
                    }
                }
                Rectangle {
                    color: "white";
                    width: parent.width;
                    height: parent.height / 2;

                    border {
                        width: 1;
                        color: "black"
                    }

                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: parent.color = "gray";
                        onExited: parent.color = "white";
                        onClicked: {
                            var newMonth = calenderGrid.month;
                            var newYear = calenderGrid.year;

                            if ((newMonth + 1) > 11) {
                                newMonth = 0;
                                newYear = calenderGrid.year + 1;
                            } else
                                newMonth += 1;

                            calenderGrid.reset(newYear, newMonth);
                        }
                    }

                    Text {
                        anchors.centerIn: parent;
                        width: parent.width
                        height: parent.height;
                        wrapMode : Text.Wrap;
                        fontSizeMode: Text.Fit;
                        minimumPixelSize: 1;
                        font.pixelSize: 40;
                        text: "Next Month";
                        color: "black";
                    }
                }
            }

            Rectangle {
                color: "white";
                width: parent.width;
                height: parent.height / 2;

                border {
                    width: 1;
                    color: "black"
                }

                MouseArea {
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onEntered: parent.color = "gray";
                    onExited: parent.color = "white";
                    onClicked: {
                        var day = new Date();

                        calenderGrid.reset(day.getFullYear(), day.getMonth());
                    }
                }

                Text {
                    anchors.centerIn: parent;
                    width: parent.width
                    height: parent.height;
                    wrapMode : Text.Wrap;
                    fontSizeMode: Text.Fit;
                    minimumPixelSize: 1;
                    font.pixelSize: 40;
                    text: "Current Month";
                    color: "black";
                }
            }

        }
    }
}
