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

    Rectangle {
        anchors.fill: parent;
        border.color: "black";
        border.width: 2;
        color: "#00000000";

    }

    Text {
        id: infoText
        text: "Add the name of achievement.";
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

    Rectangle {
        id: nameTextInputBox
        width: infoText.width * 0.9;
        height: infoText.height * 0.7;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: infoText.bottom;

        TextField {
            id: nameTextInput
            anchors.fill: parent;
            font.pixelSize: 0.1 * parent.width;
            cursorVisible: false;
            autoScroll: true;
            clip: true;
            maximumLength: 16;
            placeholderText: "Name...";
        }
    }

    ComboBox {
        id: achievementTypeDropdown
        width: infoText.width * 0.9;
        height: infoText.height * 0.7;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: nameTextInputBox.bottom;
        anchors.topMargin: 20;
        currentIndex: -1;
            displayText: currentIndex === -1 ? "Please Choose a type..." : currentText
        model: ["Binary (yes/no)", "Number"];
    }

    Rectangle {
        id: colorPickerBox;
        width: infoText.width * 0.1;
        height: redColorSlider.height * 3;
        x: achievementTypeDropdown.x;
        anchors.top: achievementTypeDropdown.bottom;
        anchors.topMargin: 20;
        border.color: "black";
        border.width: 1;

        // This line keeps crashing it
        color: Qt.rgba(redColorSlider.value, greenColorSlider.value, blueColorSlider.value);
        visible: true;
    }

    Slider {
        id: redColorSlider
        width: infoText.width * 0.9 - colorPickerBox.width - 10;
        height: infoText.height * 0.7;
        anchors.left: colorPickerBox.right;
        anchors.leftMargin: 10;
        anchors.top: achievementTypeDropdown.bottom;
        anchors.topMargin: 20;
        visible: colorPickerBox.visible;

        handle: Rectangle {
            color: "red";
            width: parent.width * 0.05;
            height: parent.height * 0.8;
            anchors.verticalCenter: parent.verticalCenter;
            x: (parent.width - this.width) * parent.position;
        }
    }

    Slider {
        id: blueColorSlider;
        width: redColorSlider.width;
        height: redColorSlider.height;
        anchors.left: colorPickerBox.right;
        anchors.leftMargin: 10;
        anchors.verticalCenter: colorPickerBox.verticalCenter;
        visible: colorPickerBox.visible;

        handle: Rectangle {
            color: "blue";
            width: parent.width * 0.05;
            height: parent.height * 0.8;
            anchors.verticalCenter: parent.verticalCenter;
            x: (parent.width - this.width) * parent.position;
        }
    }

    Slider {
        id: greenColorSlider;
        width: redColorSlider.width;
        height: redColorSlider.height;
        anchors.left: colorPickerBox.right;
        anchors.leftMargin: 10;
        y: (blueColorSlider.y - redColorSlider.y) + blueColorSlider.y;
        visible: colorPickerBox.visible;

        handle: Rectangle {
            color: "green";
            width: parent.width * 0.05;
            height: parent.height * 0.8;
            anchors.verticalCenter: parent.verticalCenter;
            x: (parent.width - this.width) * parent.position;
        }
    }

    Rectangle {
        width: infoText.width * 0.9;
        height: infoText.height * 0.7;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: colorPickerBox.bottom;
        anchors.topMargin: 30;
        border.width: 2;
        border.color: "black";
        visible: (nameTextInput.text !== "" && achievementTypeDropdown.currentIndex !== -1) ? true : false;

        Text {
            width: parent.width * 0.5; height: parent.height;
            anchors.centerIn: parent;
            text: "Submit";
            fontSizeMode: Text.Fit;
            minimumPixelSize: 10;
            font.pixelSize: 40;
        }

        MouseArea {
            anchors.fill: parent;
            onClicked:  {
                var name = nameTextInput.text;
                var achievementType = achievementTypeDropdown.currentIndex;

                ProgressStorage.saveAchievementType(name, achievementType, redColorSlider.value, greenColorSlider.value, blueColorSlider.value);
                root.close();
            }
        }
    }
}

