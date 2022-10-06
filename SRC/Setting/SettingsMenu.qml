import QtQuick
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
//import QtQuick.Dialogs 1.0
import "../Custom"
SettingsView{
//    id: settingView
    property int particleCount: 400
    property int particleLife: 10000
        Rectangle{
            color: "transparent"
            radius: 5
            border.color: "yellow"
            border.width: 2
            width: childrenRect.width + 10
            height: childrenRect.height + 10

    //        anchors.margins: 5
            ColumnLayout{
                spacing: 10
                Layout.margins: 5
                CustomCheckBox{
                    text: "firsr"
                    checked: true
                }
                TreeView{
                    id: tree
                    model: listModel.model
                    height: 500

                    delegate:Item {
                        id: treeDelegate

                        implicitWidth: padding + label.x + label.implicitWidth + padding
                        implicitHeight: label.implicitHeight * 1.5

                        readonly property real indent: 20
                        readonly property real padding: 5

                        // Assigned to by TreeView:
                        property TreeView treeView: tree
                        required property bool isTreeNode
                        required property bool expanded
                        required property int hasChildren
                        required property int depth

                        TapHandler {
                            onTapped: treeView.toggleExpanded(row)
                        }

                        Text {
                            id: indicator
                            visible: treeDelegate.isTreeNode && treeDelegate.hasChildren
                            x: padding + (treeDelegate.depth * treeDelegate.indent)
                            anchors.verticalCenter: label.verticalCenter
                            text: "▸"
                            rotation: treeDelegate.expanded ? 90 : 0
                        }

                        Text {
                            id: label
                            x: padding + (treeDelegate.isTreeNode ? (treeDelegate.depth + 1) * treeDelegate.indent : 0)
                            width: treeDelegate.width - treeDelegate.padding - x
                            clip: true
                            text: model.x
                            Component.onCompleted: console.log("comp")
                        }
                    }
                }

                CustomLabel{
                    text: "Particle Count"
                }

                CustomSlider{
                    fromValue: 100
                    toValue: 1000
                    sliderStepSize: 50
                    sliderValue: particleCount
                    onValueChange: particleCount = sliderValue

                }
                CustomLabel{
                    text: "Particle Life"
                }
                CustomSlider{
                    fromValue: 1000
                    sliderValue: particleLife
                    onValueChange: particleLife = sliderValue
                    toValue: 20000
                    sliderStepSize: 500

                }
                Button{
                    id: bLoader
                    text: "load Fountain Map"
                    background: Rectangle{
                        id: bgLoader
                        color: "white"
                    }

                    onClicked: folderDialog.open()

                    FileDialog {
                        id: folderDialog
                        currentFile: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
//                        selectedFolder: viewer.folder
                        nameFilters: ["H-Studio Fountain Map (*.hfm)"]
//                        acceptLabel: "Open"
                        onAccepted: {
                           var res = modeler.readHFM(folderDialog.currentFile)
                            if(res)
                                bgLoader.color = "green"
                            else
                                bgLoader.color = "red"
                        }
                    }
//                    onClicked: modeler.readHFM();
                }
            }
        }
}
