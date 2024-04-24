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

    property int year: infoDay.selectedYear;
    property int month: infoDay.selectedMonth;
    property int day: infoDay.selectedDay;
    property variant monthNames: ["January","February","March","April","May","June","July","August","September","October","November","December"];

    Rectangle {
        id: border
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

    Column {
        anchors.top: miniTaskbar.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        spacing: 30;

        Text {
            id: infoText
            text: root.monthNames[root.month] + " " + root.day;
            fontSizeMode: Text.Fit;
            width: root.width * 0.5;
            height: root.height * 0.1;
            minimumPixelSize: 10;
            font.pixelSize: 40;
            color: "white";
            font.bold: true;
            anchors.horizontalCenter: parent.horizontalCenter;
        }

        ComboBox {
            id: achievementDropdown
            model: AchievementModel;
            width: root.width * 0.9;
            height: root.height * 0.1;
            currentIndex: -1;

            property int selectedAchievementType: -1;
            property string selectedAchievementTypeString: "";
            property string selectedColor;

            popup: Popup {
                    y: parent.height - 1
                    width: achievementDropdown.width;
                    height: achievementDropdown.height * 3.5;

                    contentItem: ListView {
                        clip: true;
                        currentIndex: achievementDropdown.highlightedIndex
                        anchors.fill: parent;
                        model: AchievementModel

                        Rectangle {
                            anchors.fill: parent;
                            color: "#00000000"
                            border {
                                color: "black"
                                width: 1;
                            }
                        }

                        ScrollIndicator.vertical: ScrollIndicator { }

                        delegate: Rectangle {
                            width: ListView.view.width;
                            implicitHeight: achievementDropdown.height;
                            color: model.color;

                            Column {
                                anchors.horizontalCenter: parent.horizontalCenter;
                                Text {
                                    text: model.name;
                                    color: "white";
                                    font.bold: true;
                                    anchors.horizontalCenter: parent.horizontalCenter;
                                }

                                Text {
                                    color: "white";
                                    anchors.horizontalCenter: parent.horizontalCenter;

                                    Component.onCompleted: {
                                        if (model.dataType === 0)
                                            this.text = "Binary Type";
                                        else if (model.dataType === 1)
                                            this.text = "Number Type"
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent;
                                onClicked: {
                                    achievementDropdown.currentIndex = model.index;
                                    achievementDropdown.displayText = model.name;
                                    achievementDropdown.selectedAchievementType = model.dataType;

                                    if (model.dataType === 0)
                                        achievementDropdown.selectedAchievementTypeString = "Binary Type";
                                    else if (model.dataType === 1)
                                        achievementDropdown.selectedAchievementTypeString = "Number Type"

                                    achievementDropdown.selectedColor = model.color;
                                    achievementDropdown.popup.close();
                                }
                            }
                        }
                    }
                }
            contentItem: Rectangle {
                color: achievementDropdown.selectedColor;
                width: parent.width;
                height: parent.height;
                clip: true;

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter;
                    Text {
                        text: achievementDropdown.displayText;
                        color: "white";
                        font.bold: true;
                        anchors.horizontalCenter: parent.horizontalCenter;
                    }

                    Text {
                        text: achievementDropdown.selectedAchievementTypeString;
                        color: "white";
                        anchors.horizontalCenter: parent.horizontalCenter;
                    }
                }
            }
        }


        TextField {
            id: numberInput;
            width: achievementDropdown.width;
            height: achievementDropdown.height * 0.9;
            visible: (achievementDropdown.selectedAchievementType === 1) ? true : false;
            validator: IntValidator {bottom: -1000000; top: 1000000;}
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter;
        }

        Rectangle {
            width: achievementDropdown.width;
            height: achievementDropdown.height * 0.9;
            // cancer
            visible: (achievementDropdown.currentIndex !== -1) ?
                         (achievementDropdown.selectedAchievementType !== 1)
                            ? true : ((achievementDropdown.selectedAchievementType === 1 && (numberInput.text !== "" && numberInput.text !== "-")))
                              ? true : false : false

            border {
                width: 2;
                color: "black"
            }

            Text {
                text: "Submit";
                anchors.centerIn: parent;
                font.pixelSize: 20;
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    ProgressStorage.addAchievement(root.year, root.month, root.day, achievementDropdown.displayText, achievementDropdown.selectedAchievementType, achievementDropdown.selectedColor, numberInput.text);
                    root.close();
                }
            }
        }
    }
}
