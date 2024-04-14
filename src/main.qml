import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.deepin.dtk 1.0

Item {
    id: root

    property int iconSize: 18

    Rectangle {
        id: background

        anchors.fill: parent
        opacity: 0.3
    }

    RowLayout {
        anchors.fill: root
        spacing: 10
        // 活动程序图标和名称
        Item {
            Layout.leftMargin: 10
            Layout.fillHeight: true
            Layout.preferredWidth: root.width / 3

            RowLayout {
                id: appInfoLayout
                anchors.fill: parent
                spacing: 5

                DciIcon {
                    id: appIcon
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: root.iconSize
                    Layout.preferredHeight: root.iconSize
                    sourceSize: Qt.size(root.iconSize,
                                        root.iconSize)
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
    }

}
