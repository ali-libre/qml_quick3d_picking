import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Particles3D
import QtQuick3D.AssetUtils
import QtQuick3D.Helpers
import CustomModel
import Qt3D.Core 2.0
import Qt3D.Extras 2.0
import "./SRC/Setting"
Window {
    id: rootWindow
    visible: true
    width: 1200
    height: 800
    title: qsTr("H-STudio Fountain Preview")
    color: "#636363"
    property int pump: 200
    property var selectObject: null
    //prevent timer action after destroy ! no needed
//    Component.onDestruction:{
//        updater.running = false
//        console.log( "start Destroy")
//    }
    //c++ Model
    CModel{
        id:modeler
    }
    Timer{
        id:updater
        property bool firstInit: true
        running: true
        repeat: true
        interval: 40
        onTriggered:{
        tempModel.json = modeler.jsonTester()
        var i;
//            if(updater.running === true)
//                console.log("timer")
//        console.log(tempModel.model.count)
        if(firstInit){
//            console.log("firstInit...!")
            listModel.json = modeler.jsonTester()
            firstInit = false
            console.log(tempModel.json)
        }else{
            for(i = 0; i< listModel.model.count; i++){
                listModel.model.set(i, {
                                        "rX": tempModel.model.get(i).rX,
                                        "rY": tempModel.model.get(i).rY,
                                        "rZ": tempModel.model.get(i).rZ
                                    })
            }
        }


        }
    }

    JSONListModel{
        id: tempModel
        query: "nozzle[*]"
    }

    JSONListModel{
        id: listModel
        query: "nozzle[*]"
//        json: modeler.jsonTester()
//        Component.onCompleted: {
//            console.log(listModel.count, listModel.json)
//            var i = 0;
//            for(i = 0; i < 20; i++)
//                console.log(i, listModel.model.get(i).x)
//        }

    }

    View3D {
        id: scene
        anchors.fill: parent
        renderMode: View3D.Underlay
        environment: SceneEnvironment {
            clearColor: "#636363"
            backgroundMode: SceneEnvironment.SkyBox
            lightProbe: Texture {
//                source: "qrc:/HDR.hdr"
//                Component.onCompleted: console.log("i'm load HDR")
            }
            probeOrientation: Qt.vector3d(0, 0, 0)
        }

        Lamp{
            id: lamp
            x: 400
            y: 1500
            z: 400
            Model{
                materials: DefaultMaterial{
                    diffuseColor: "blue"
                }

                source: "#Cylinder"
                scale.x: .3
                scale.y: 2
                scale.z: .3
            }
        }
/*
        camera: cameraNode
        Node {
            id: originNode
            PerspectiveCamera {
                id: cameraNode
                z: 100
            }
        }
        OrbitCameraController {
            anchors.fill: parent
            origin: originNode
            camera: cameraNode
        }
*/
        camera: persepectivecamera
        PerspectiveCamera {
            id: persepectivecamera
            x: 800
            y: -3500
            z: 2000
            eulerRotation: Qt.vector3d(60, 0, 0)
            onPositionChanged: {
            }
        }
        WasdController {
            id: panner
            controlledObject: persepectivecamera
            mouseEnabled: false
            speed: 3
//            rotation.x: false
//            rotation.y: false
        }
//        CameraController{
//            id: panner
//            camera: persepectivecamera
//        }

        //! [pickable model]
        Repeater3D{
            model: listModel.model

            NozzelModel{
                pumpValue: model.pump
                pX: model.x
                pY: model.y
                pZ: model.z
                isPicked: false
                particleCount: setting.particleCount
                particleLife: setting.particleLife // TODO: add model
            }

        }
    }



    Picker{
        id: picker
        viewScene: scene
    }

    SettingsMenu{
        id: setting
        // TODO: sums up with setting object

    }

    StatusBar{
        id: status
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 20
        spacing: 50

        pick_name: picker.pickName
        pick_distance: picker.pickDistance
        pick_word: picker.pickWord
        touch_point: picker.touchPoint
    }


    QtObject {
        id: settings
        // Antialiasing mode & quality used in all examples.
        property var antialiasingMode: SceneEnvironment.NoAA
        property var antialiasingQuality: SceneEnvironment.High
        // Toggle default visibility of these views
        property bool showSettingsView: true
        property bool showLoggingView: false
        // Fonts in pointSizes
        // These are used mostly on examples in 3D side
        property real fontSizeLarge: 16
        // These are used mostly on settings
        property real fontSizeSmall: 10
    }

    readonly property real iconSize: 16 + Math.max(width, height) * 0.05
}
