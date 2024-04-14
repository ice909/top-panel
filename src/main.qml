import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import org.deepin.dtk 1.0 as D
import fun.tarrow 1.0

Item {
    id: root

    property int iconSize: 18

    Rectangle {
        id: background

        anchors.fill: parent
        opacity: 0.3
    }

    // 活动程序右键菜单
    DesktopMenu {
        id: acticityMenu

        MenuItem {
            text: "关闭"
            onTriggered: {
                PanelHelper.close();
            }
        }

    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        // 活动程序图标和名称
        StandardItem {
            Layout.fillHeight: true

                Layout.leftMargin: 10
            Layout.preferredWidth: Math.min(root.width / 3, appInfoLayout.implicitWidth + 20)
            onClicked: {
                if (mouse.button === Qt.RightButton)
                    acticityMenu.popup();

            }

            RowLayout {
                id: appInfoLayout

                anchors.fill: parent
                spacing: 5

                D.DciIcon {
                    id: appIcon

                    Layout.alignment: Qt.AlignVCenter
                    width: root.iconSize
                    height: root.iconSize
                    sourceSize: Qt.size(root.iconSize, root.iconSize)
                    name: PanelHelper.icon
                    visible: PanelHelper.icon
                }

                Label {
                    id: appName

                    text: PanelHelper.title
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    elide: Qt.ElideRight
                    visible: text
                    color: "#000"
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

        }

        Item {
            id: appMenuItem
            Layout.fillHeight: true
            Layout.fillWidth: true

            ListView {
                id: appMenuView
                anchors.fill: parent
                orientation: Qt.Horizontal
                spacing: 5
                visible: appMenuModel.visible
                interactive: false
                clip: true

                model: appMenuModel

                // Initialize the current index
                onVisibleChanged: {
                    if (!visible)
                        appMenuView.currentIndex = -1
                }

                delegate: StandardItem {
                    id: _menuItem
                    width: _actionText.width + 5
                    height: ListView.view.height
                    checked: appMenuApplet.currentIndex === index

                    onClicked: {
                        appMenuApplet.trigger(_menuItem, index)

                        checked = Qt.binding(function() {
                            return appMenuApplet.currentIndex === index
                        })
                    }

                    Text {
                        id: _actionText
                        anchors.centerIn: parent
                        color: "#000"
                        font.pixelSize: 12
                        font.bold: true
                        text: {
                            var text = activeMenu
                            text = text.replace(/([^&]*)&(.)([^&]*)/g, function (match, p1, p2, p3) {
                                return p1.concat(p2, p3)
                            })
                            return text
                        }
                    }

                    // QMenu opens on press, so we'll replicate that here
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: appMenuApplet.currentIndex !== -1
                        onPressed: parent.clicked(null)
                        onEntered: parent.clicked(null)
                    }
                }

                AppMenuModel {
                    id: appMenuModel
                    onRequestActivateIndex: appMenuApplet.requestActivateIndex(appMenuView.currentIndex)
                    Component.onCompleted: {
                        appMenuView.model = appMenuModel
                    }
                }

                AppMenuApplet {
                    id: appMenuApplet
                    model: appMenuModel
                }

                Component.onCompleted: {
                    appMenuApplet.buttonGrid = appMenuView

                    // Handle left and right shortcut keys.
                    appMenuApplet.requestActivateIndex.connect(function (index) {
                        var idx = Math.max(0, Math.min(appMenuView.count - 1, index))
                        var button = appMenuView.itemAtIndex(index)
                        if (button) {
                            button.clicked(null)
                        }
                    });

                    // Handle mouse movement.
                    appMenuApplet.mousePosChanged.connect(function (x, y) {
                        var item = itemAt(x, y)
                        if (item)
                            item.clicked(null)
                    });
                }
            }
        }
        // 时间和日期
        StandardItem {
            Layout.fillHeight: true
            Layout.preferredWidth: Math.min(root.width / 3, timeLayout.implicitWidth + 20)
            Layout.rightMargin: 10

            RowLayout {
                id: timeLayout

                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 5

                Label {
                    id: timeLabel

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    elide: Qt.ElideRight
                    color: "#000"
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignVCenter

                    Timer {
                        id: timeTimer

                        interval: 1000
                        repeat: true
                        running: true
                        triggeredOnStart: true
                        onTriggered: {
                            timeLabel.text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm:ss");
                        }
                    }

                }

            }

        }

    }

}
