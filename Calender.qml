import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

GridLayout {
    id: calenderGrid
    columns: 7;
    rows: 7;
    width: contentScreen.width * 0.8;
    height: contentScreen.height * 0.8;
    anchors.centerIn: contentScreen;
    anchors.topMargin: 100;
    Text {
        id: monthText
        property variant months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        text: months[calenderGrid.month] + " " + calenderGrid.year;
        font.pixelSize: 40;
        font.bold: true;
        color: "white";

        Layout.columnSpan: 7;
    }

    rowSpacing: 0;
    columnSpacing: 0;

    property variant monthNames: ["January","February","March","April","May","June","July","August","September","October","November","December"];
    property int year;
    property int month;
    property int daysInCurrentMonth;
    property int monthStartDay;

    function daysInMonth (year, month) {
        return new Date(year, month, 0).getDate();
    }

    function setup (year = -1,month = -1) {

        if (year === -1) {
            var d = new Date();
            calenderGrid.month = d.getMonth();
            calenderGrid.year = d.getFullYear();
            calenderGrid.daysInCurrentMonth = calenderGrid.daysInMonth(calenderGrid.year, calenderGrid.month + 1);

            calenderGrid.monthStartDay = new Date(calenderGrid.year, calenderGrid.month, 1).getDay();
        } else {
            calenderGrid.month = month;
            calenderGrid.year = year;
            calenderGrid.daysInCurrentMonth = calenderGrid.daysInMonth(calenderGrid.year, calenderGrid.month + 1);

            calenderGrid.monthStartDay = new Date(calenderGrid.year, calenderGrid.month, 1).getDay();
        }
    }

    function roundUp(obj, index) {
        if (index !== 0) {
            var previousCell = cells.itemAt(index - 1);
        }

        if (index === 0) {
            calenderGrid.setup(calenderGrid.year, calenderGrid.month);
            return 2;
        } else if (previousCell.Layout.column === 6) {
            return (previousCell.Layout.row + 1);
        } else {
            return previousCell.Layout.row;
        }
    }

    function reset(year, month) {
        cells.model = [];
        calenderGrid.setup(year, month);
        cells.model = calenderGrid.daysInCurrentMonth;
    }

    Repeater {
        model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        Rectangle {Layout.fillWidth: true; Layout.fillHeight: true; color: "black"; Text {color: "white"; text: modelData; fontSizeMode: Text.Fit; font.pixelSize: 20; anchors.centerIn: parent;} }
    }

    Repeater {
        id: cells;
        model: calenderGrid.daysInCurrentMonth;

        Component.onCompleted: {
            calenderGrid.setup();
            var firstCell = cells.itemAt(new Date().getDate() - 1);
            firstCell.border.color = "yellow";
            firstCell.border.width = 4;
        }
        Cell {
            Layout.column: (calenderGrid.monthStartDay + index) % 7;
            Component.onCompleted: { this.Layout.row = calenderGrid.roundUp(this, index); }
        }

    }
}
