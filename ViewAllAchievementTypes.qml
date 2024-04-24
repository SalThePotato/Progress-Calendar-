import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "qrc:/"

Window {
    id: root;
    width: 200;
    height: 400;
    color: "#4287f5";
    visible: true;
    flags: Qt.Window | Qt.FramelessWindowHint;

    Rectangle {
        id: borderBox
        anchors.fill: parent;
        border.color: "black";
        border.width: 2;
        color: "#00000000";
        z: 1;
    }

    ToolBar {
        id: miniTaskbar
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
            layoutDirection: Qt.RightToLeft

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
                        onClicked: {root.close()}
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
                onActiveChanged: {root.startSystemMove()}
            }
        }
    }

    Text {
        id: infoText
        text: "All Achievement Types";
        fontSizeMode: Text.Fit;
        width: parent.width * 0.95;
        height: parent.height * 0.1;
        minimumPixelSize: 10;
        font.pixelSize: 40;
        color: "white";
        font.bold: true;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: miniTaskbar.bottom;
        anchors.topMargin: 20;
    }

    ListView {
        model: AchievementModel;
        width: parent.width - borderBox.border.width;
        height: parent.height - (infoText.height + borderBox.border.width + miniTaskbar.height + infoText.anchors.topMargin);
        ScrollBar.vertical: ScrollBar {
            hoverEnabled: true
            active: hovered || pressed
            visible: true;
        }

        anchors.top: infoText.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        clip:true;
        delegate: Item {
            id: achievementItem
            width: ListView.view.width - ListView.view.ScrollBar.vertical.width;
            implicitHeight: 70;
            property bool expanded: false;

            Rectangle {
                width: parent.width;
                height: (expanded) ? parent.height * 0.8 : parent.height;
                border {width: 2; color: "black"}
                color: model.color;

                Column {
                    anchors.centerIn: parent;

                    Text {
                        text: model.name;
                        font.bold: true;
                        color: "white";
                        anchors.horizontalCenter: parent.horizontalCenter;
                    }

                    Text {
                        fontSizeMode: Text.Fit;
                        text: (model.dataType === 1) ? "Number Type" : "Binary Type";
                        color: "white";
                        anchors.horizontalCenter: parent.horizontalCenter;
                    }
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: { if (optionsBox.visible !== true) {
                            achievementItem.height += optionsBox.height;
                            achievementItem.expanded = true;

                        } else {
                            achievementItem.height -= optionsBox.height;
                            achievementItem.expanded = false;
                        }
                    }
                }

                Rectangle {
                    id: optionsBox;
                    width: parent.width;
                    height: achievementItem.height * 0.3;
                    visible: expanded;
                    color: "white";
                    anchors.top: parent.bottom;
                }
        }
        }
}
}
