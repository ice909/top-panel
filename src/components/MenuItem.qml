import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T

T.MenuItem {
    id: control

    property color hoveredColor: Qt.rgba(0, 0, 0, 0.2)
    property color pressedColor: Qt.rgba(0, 0, 0, 0.3)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding, implicitIndicatorHeight + topPadding + bottomPadding)
    verticalPadding: 5
    hoverEnabled: true
    topPadding: 5
    bottomPadding: 5
    icon.width: 24
    icon.height: 24

    contentItem: IconLabel {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0

        leftPadding: !control.mirrored ? indicatorPadding + 5 * 2 : arrowPadding
        rightPadding: control.mirrored ? indicatorPadding : arrowPadding + 5 * 2
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignLeft
        icon: control.icon
        text: control.text
        font: control.font
        color: control.enabled ? control.pressed || control.hovered ? "#000" : "#222" : "#888"
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: control.visible ? 30 + 10 : 0
        radius: 8
        opacity: 1
        color: control.pressed || highlighted ? control.pressedColor : control.hovered ? control.hoveredColor : "transparent"

        anchors {
            fill: parent
            leftMargin: 5
            rightMargin: 5
        }

    }

}
