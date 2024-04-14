import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.deepin.dtk 1.0

Item {
    id: control

    property bool checked: false
    property real moveX: 0
    property real moveY: 0
    property bool animationEnabled: false
    property alias mouseArea: _mouseArea

    signal clicked(var mouse)

    MouseArea {
        id: _mouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true
        onEntered: {
            _bgRect.width = 0;
            _bgRect.height = 0;
            _bgRect.x = mouseX;
            _bgRect.y = mouseY;
            _bgRect.state = "shown";
        }
        onExited: {
            control.moveX = mouseX;
            control.moveY = mouseY;
            _bgRect.state = "hidden";
        }
        onClicked: {
            control.moveX = mouseX;
            control.moveX = mouseY;
            control.clicked(mouse);
        }
    }

    Rectangle {
        id: _bgRect

        radius: 3
        color: Qt.rgba(0, 0, 0, 0.1)
        state: "hidden"
        states: [
            State {
                name: "shown"

                PropertyChanges {
                    target: _bgRect
                    x: 0
                    y: 1
                    width: control.width
                    height: control.height - 2
                    visible: true
                }

            },
            State {
                name: "hidden"

                PropertyChanges {
                    target: _bgRect
                    x: control.moveX
                    y: control.moveY
                    width: 0
                    height: 0
                    visible: false
                }

            }
        ]
        transitions: [
            Transition {
                from: "hidden"
                to: "shown"

                SequentialAnimation {
                    PropertyAnimation {
                        target: _bgRect
                        properties: "visible"
                        duration: 0
                        easing.type: Easing.OutQuart
                    }

                    PropertyAnimation {
                        target: _bgRect
                        properties: "x, y, width, height"
                        duration: control.animationEnabled ? 400 : 0
                        easing.type: Easing.OutQuart
                    }

                }

            },
            Transition {
                from: "shown"
                to: "hidden"

                SequentialAnimation {
                    PropertyAnimation {
                        target: _bgRect
                        properties: "x, y, width, height"
                        duration: control.animationEnabled ? 200 : 0
                        easing.type: Easing.OutQuart
                    }

                    PropertyAnimation {
                        target: _bgRect
                        properties: "visible"
                        duration: 0
                        easing.type: Easing.OutQuart
                    }

                }

            }
        ]
    }

}
