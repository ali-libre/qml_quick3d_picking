import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Particles3D
import QtQuick3D.AssetUtils
import QtQuick3D.Helpers
import CustomModel

Window {
    visible: true
    width: 1200
    height: 800
    title: qsTr("Fountain Preview")
    color: "#636363"
    property int pump: 200
    property var selectObject: null

    //c++ Model
    CModel{
        id:modeler
    }
    Timer{
        running: true
        repeat: true
        interval: 20
        onTriggered:{
            tempModel.json = modeler.jsonTester()
            var i;
//            console.log(0, tempModel.model.get(0).rX)
            listModel.model.set(0, {
                                    "rX": tempModel.model.get(0).rX,
                                    "rY": tempModel.model.get(0).rY,
                                    "rZ": tempModel.model.get(0).rZ
                                })
            for(i = 0; i < tempModel.model.count; i++){
//                listModel.model.set(i, {
//                                        "rX": tempModel.model.get(i).rX,
//                                        "rY": tempModel.model.get(i).rY,
//                                        "rZ": tempModel.model.get(i).rZ
//                                    })
            }

        }
    }

    JSONListModel{
        id: tempModel
        query: "$.nozzle[*]"
        json: modeler.jsonTester()

        Component.onCompleted: {
            console.log(listModel.count, listModel.json)
            var i = 0;
            for(i = 0; i < 20; i++)
                console.log(i, listModel.model.get(i).x)
        }

    }

    JSONListModel{
        id: listModel
        query: "$.nozzle[*]"
        json: modeler.jsonTester()

        Component.onCompleted: {
            console.log(listModel.count, listModel.json)
            var i = 0;
            for(i = 0; i < 20; i++)
                console.log(i, listModel.model.get(i).x)
        }

    }



    View3D {
        id: scene
        anchors{
//            top: controlPanel.bottom
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        renderMode: View3D.Underlay
        environment: SceneEnvironment {
            clearColor: "#636363"
            backgroundMode: SceneEnvironment.SkyBox
            lightProbe: Texture {
//                source: "qrc:/HDR.hdr"
            }
            probeOrientation: Qt.vector3d(0, -90, 0)
        }

        Lamp{
            id: lamp
            x: 400
            y: 600
            z: 400
        }

        camera: persepectivecamera
        PerspectiveCamera {
            id: persepectivecamera
            x: 0
            y: -500
            z: 100
            eulerRotation: Qt.vector3d(90, 0, 0)
            onPositionChanged: {
            }
        }

        WasdController {
            id: panner
            controlledObject: persepectivecamera
            mouseEnabled: false
            speed: 3
        }

        //! [pickable model]
        Repeater3D{
            model: listModel.model

            NozzelModel{
                pumpValue: model.pump
                pX: model.x
                pY: model.y
                pZ: model.z
                isPicked: false
            }

        }
    }



    MouseArea {
        id: mouse_area
//        anchors{
//            top: controlPanel.bottom
//            left: parent.left
//            right: parent.right
//            bottom: parent.bottom
//        }
        anchors.fill: scene
        hoverEnabled: false
        property var pickNode: null
        // Mouse and objects xy The migration
        property real xOffset: 0
        property real yOffset: 0
        property real zOffset: 0

        onPressed: {
            // Get point at View Screen coordinates on
            controlPanel.touchPoint = "(" + mouse.x + ", " + mouse.y + ")"
            //pick Take the nearest intersection with the ray path at this point Model Information about , return PickResult object
            // Because the module has been iterating , The new version can be downloaded from PickResult Object to get more information
            //Qt6 It is also provided pickAll Get all that intersect the ray Model Information
            var result = scene.pick(mouse.x, mouse.y)
            // Currently only updated when clicked pick Information about objects
            if (result.objectHit) {
                panner.mouseEnabled = false
                pickNode = result.objectHit
//                pickNode.isPicked = !pickNode.isPicked
                controlPanel.pick_name = pickNode.objectName
                controlPanel.pick_distance = result.distance.toFixed(2)
                controlPanel.pick_word= "("
                        + result.scenePosition.x.toFixed(2) + ", "
                        + result.scenePosition.y.toFixed(2) + ", "
                        + result.scenePosition.z.toFixed(2) + ")"
                //console.log('in',pick_screen.text)
                //console.log(result.scenePosition)
                var map_from = scene.mapFrom3DScene(pickNode.scenePosition)
                //var map_to = scene.mapTo3DScene(Qt.vector3d(mouse.x,mouse.y,map_from.z))
                //console.log(map_from)
                //console.log(map_to)
                xOffset = map_from.x - mouse.x
                yOffset = map_from.y - mouse.y
                zOffset = map_from.z
            } else {
                panner.mouseEnabled = true
                controlPanel.pickNode = null
                controlPanel.pick_name.text = "None"
                controlPanel.pick_distance.text = " "
                controlPanel.pick_word.text = " "
            }
        }
        onPositionChanged: {
            if(!mouse_area.containsMouse || !pickNode){
                return
            }
            var pos_temp = Qt.vector3d(mouse.x + xOffset, mouse.y + yOffset, zOffset);
            var map_to = scene.mapTo3DScene(pos_temp)
            pickNode.x = map_to.x
            pickNode.y = map_to.y
            pickNode.z = map_to.z
        }
    }

    ControlPanel{
        id: controlPanel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 50
        spacing: 50
    }
}
