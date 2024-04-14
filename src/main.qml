import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import org.deepin.dtk 1.0 as D

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
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        spacing: 10

        // 活动程序图标和名称
        StandardItem {
            Layout.fillHeight: true
            Layout.preferredWidth: Math.min(root.width / 3, appInfoLayout.implicitWidth + 20)
            onClicked: {
                if (mouse.button === Qt.RightButton)
                    acticityMenu.popup();

            }

            RowLayout {
                id: appInfoLayout

                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
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
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

        }

        Item {
            Layout.fillWidth: true
        }

        // 时间和日期
        StandardItem {
            Layout.fillHeight: true
            Layout.preferredWidth: Math.min(root.width / 3, timeLayout.implicitWidth + 20)

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
