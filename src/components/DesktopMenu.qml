import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import fun.tarrow 1.0 as I
import org.deepin.dtk 1.0 as D

I.MenuPopupWindow {
    id: control

    default property alias content: _mainLayout.data

    function open() {
        control.show();
    }

    function popup() {
        control.show();
    }

    Rectangle {
        id: _background

        property var borderColor: Qt.rgba(0, 0, 0, 0.2)

        anchors.fill: parent
        color: "#fff"
        radius: 10
        opacity: 0.6
        border.color: _background.borderColor
        border.width: 1
        border.pixelAligned: false

        I.WindowBlur {
            view: control
            geometry: Qt.rect(control.x, control.y, control.width, control.height)
            windowRadius: _background.radius
            enabled: true
        }

    }

    ColumnLayout {
        id: _mainLayout

        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
    }

}
