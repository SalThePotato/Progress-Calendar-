import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    border.color: "black";
    border.width: 1;
    Layout.fillWidth: true;
    Layout.fillHeight: true;

    Text {
        id: dayText;
        text: index + 1;
        fontSizeMode: Text.Fit;
        anchors.top: parent.top;
        anchors.left: parent.left;
        padding: 5;
    }

    MouseArea {
        anchors.fill: parent;
        z: 1;

        onClicked: {
            onClicked: {
                infoDayTitleText.text = calenderGrid.monthNames[calenderGrid.month] + " " + (index + 1);
                infoDay.visible = true;

                infoDay.selectedYear = calenderGrid.year;
                infoDay.selectedMonth = calenderGrid.month;
                infoDay.selectedDay = index + 1;

                achievementListView.model = ProgressStorage.getDayModel(calenderGrid.year, calenderGrid.month, index + 1);
            };
        }
    }

    ListView {
        width: (parent.width - dayText.width) * 0.9;
        height: parent.height * 0.8;
        anchors.left: dayText.right;
        anchors.verticalCenter: parent.verticalCenter;
        clip: true;
        model: ProgressStorage.getDayModel(calenderGrid.year, calenderGrid.month, index + 1);
        spacing: 5;

        delegate: Rectangle {
            width: ListView.view.width;
            height: ListView.view.height * 0.2;
            color: (model.dataType === 1) ? "#00000000" : model.color;
            visible: true;

            border {
                width: (model.dataType === 1) ? 1 : 0;
                color: (model.dataType === 1) ? model.color : "black";
            }

            Text {
                width: parent.width * 0.2;
                height: parent.height;
                visible: (model.dataType === 1) ? true : false;
                text: model.numberValue;
                anchors.centerIn: parent;
                fontSizeMode: Text.Fit;
                minimumPixelSize: 3;
                font.pixelSize: 50;
            }
        }
    }
}
