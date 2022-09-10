/****************************************************************************
**
** Copyright (C) 2019 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

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
    NozzleModel{
        id: nzz
    }

    Timer{
        id: modelUpdater
        property int refresh: 0
        property int x: -1000
        property int y: -1000
        running: false
        repeat: true
        interval: 10
        onTriggered: {
            x += 300
            nzz.append({"x" : x, "y" : y, "z" : 300})
            if(x > 1000){
                x = -1000
                y += 300
            }
            if(y > 1000)
                modelUpdater.running = false
//            nzz.setData()
//            nzz.layoutAboutToBeChanged()
//            nzz.append()
        }
    }
    CModel{
        id:modeler
    }

    JSONListModel{
        id: listModel
//        source:
//        source: modeler.getPlainJsonData()
//        data: modeler.getPlainJsonData()
//        model: modeler.getPlainJsonData()
        model: [
            {"x": 0,"y": 0, "z":0},
            {"x": 100,"y": 0, "z":0},
            {"x": 200,"y": 0, "z":0},
            {"x": 300,"y": 0, "z":0}
        ]
    }

    Column {
        id: controlPanel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 50
        spacing: 50
//        Row{
//            Label {
//                id: pickName
//                color: "#222840"
//                font.pointSize: 14
//                text: "Last Pick: None"
//            }
//            Label {
//                id: pickPosition
//                color: "#222840"
//                font.pointSize: 14
//                text: "Screen Position: (0, 0)"
//            }
//            Label {
//                id: uvPosition
//                color: "#222840"
//                font.pointSize: 14
//                text: "UV Position: (0.00, 0.00)"
//            }
//            Label {
//                id: distance
//                color: "#222840"
//                font.pointSize: 14
//                text: "Distance: 0.00"
//            }
//            Label {
//                id: scenePosition
//                color: "#222840"
//                font.pointSize: 14
//                text: "World Position: (0.00, 0.00)"
//            }
//        }
        Rectangle{
//            width: 300
//            height: 200
            color: "#00000000"
            border.color: "red"
            width: parent.width
            height: parent.height
            Component.onCompleted: {
                console.log(height,width,parent.width,parent.height)
            }
            anchors.margins: 10

            Row{
                anchors.margins: 20
                //            anchors.margins: 20
                spacing: 20
                Slider{
                    id:pumpValue
                    value: pump
                    from: 200
                    to: 800
                    onValueChanged:
                        pump = value
                }

                Label {
                    id: pick_screen
                    color: "white"
                    font.pointSize: 14
                    text: "------------"
                }
                Label {
                    id: pick_name
                    color: "white"
                    font.pointSize: 14
                    text: "------------"
                }
                Label {
                    id: pick_distance
                    color: "white"
                    font.pointSize: 14
                    text: "------------"
                }
                Label {
                    id: pick_word
                    color: "white"
                    font.pointSize: 14
                    text: "------------"
                }

                Button{
                    text: "test"
                    onClicked: {
                        modeler.jsonTester()
                    }
                }
            }
        }
    }

    View3D {
        id: control
//        anchors.fill: parent
        anchors{
            top: controlPanel.bottom
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

        //lamp
        Model {
            id: lamp
            objectName: "lamp"
            source: "#Sphere"
            pickable: true
            property bool isPicked: true
            //! [pickable model]

            x: 400
            y: 600
            z: 400
            scale.x: 1
            scale.y: 1
            scale.z: 1

            //! [picked color]
            materials: DefaultMaterial {
//                alpha: .5
                opacity: .5
                diffuseColor: "#FFFF00"
//                diffuseColor: cubeModel.isPicked ? "#41cd52" : "#09102b"
//                //! [picked color]
//                specularAmount: 0.25
//                specularRoughness: 1
//                roughnessMap: Texture { source: "maps/roughness.jpg" }
            }
            PointLight {
                quadraticFade: 0
                ambientColor: Qt.rgba(.3,.3, .3, 1)
                brightness: lamp.isPicked ? 80 : 0
            }
        }
        camera: persepectivecamera
        PerspectiveCamera {
            id: persepectivecamera
            x: 0
            y: 300
            z: 1500
//            rotation.y: -180
//            rotation.x: -180
//            rotation:Qt.vector3d(-.018,0.691,0.721)
            onXChanged: {
                console.log(x,y,z,rotation.x,rotation.y, rotation.z)
            }

        }
        WasdController {
            id: panner
            controlledObject: persepectivecamera
            mouseEnabled: false
            speed: 3
//            xInvert: true
//            yInvert: true


//            keysEnabled: true
        }
//        environment: SceneEnvironment {
//            clearColor: "#000000"
//            backgroundMode: SceneEnvironment.Color
//        }

        Component{
            id: waterdroplets
            Model{
//                source: "#Rectangle"
                source: "#Rectangle"
                scale: Qt.vector3d(.1, .1, 0)
                materials: DefaultMaterial{
                }
            }
        }



        //! [pickable model]
        Repeater3D{
            model: listModel
            Model {
                id: cubeModel
                objectName: "Cube"
                source: "#Sphere"
                pickable: true
                property bool isPicked: false
                //! [pickable model]
                x: model.x
                y: model.y
                z: model.z
                scale.x: 1
                scale.y: 1
                scale.z: 1
                Component.onCompleted: console.log("X:", model.x,"Y:", model.y,"Z:", model.z)
                //! [picked color]
                materials: DefaultMaterial {
                    opacity: .7
                    diffuseColor: cubeModel.isPicked ? "#41cd52" : "#09102b"
                    //! [picked color]
                    specularAmount: 0.25
                    specularRoughness: 1
                    roughnessMap: Texture { source: "maps/roughness.jpg" }
                }


                ParticleSystem3D{
                    id: pSystem

                    ModelParticle3D{
                        id: myParticle
                        delegate: waterdroplets
                        maxAmount: 1000
                        color:  "#0000FF"
                        colorVariation: Qt.vector4d(0, 0, .5, .5)

                    }

                    ParticleEmitter3D{
                        id: myEmitter
                        particle: myParticle
                        property var t: 10
                        emitRate: 200
                        lifeSpan: 8000
                        particleRotationVelocityVariation: Qt.vector3d(100,100, 100)
                        particleRotationVariation: Qt.vector3d(t,t,t)
                        particleScale: 1.2
                        velocity: VectorDirection3D{
                            direction: Qt.vector3d(0, pumpValue.value, 0);
                            directionVariation: Qt.vector3d(20, 20, 20)
                        }
                        //! [picked animation]
                        SequentialAnimation on eulerRotation {
                            running: !cubeModel.isPicked
                            //! [picked animation]
                            loops: Animation.Infinite
                            PropertyAnimation {
                                duration: 1000
                                from: Qt.vector3d(360, 0, 360)
                                to: Qt.vector3d(0, 0, 0)
                            }
                        }
                    }
                    Gravity3D{
                        direction: Qt.vector3d(0,0,1)
                        magnitude: -200
                    }
                }
            }
        }

    }

    MouseArea {
            id: mouse_area
//            anchors.fill: parent
            anchors{
                top: controlPanel.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

//            anchors.margins: 20
//            anchors.top: control.bottom
            hoverEnabled: false
            property var pickNode: null
            // Mouse and objects xy The migration
            property real xOffset: 0
            property real yOffset: 0
            property real zOffset: 0

            onPressed: {
                // Get point at View Screen coordinates on
                pick_screen.text = "(" + mouse.x + ", " + mouse.y + ")"
                //pick Take the nearest intersection with the ray path at this point Model Information about , return PickResult object
                // Because the module has been iterating , The new version can be downloaded from PickResult Object to get more information
                //Qt6 It is also provided pickAll Get all that intersect the ray Model Information
                var result = control.pick(mouse.x, mouse.y)
                // Currently only updated when clicked pick Information about objects
                if (result.objectHit) {
                    panner.mouseEnabled = false
                    pickNode = result.objectHit
                    pickNode.isPicked = !pickNode.isPicked
                    pick_name.text = pickNode.objectName
                    pick_distance.text = result.distance.toFixed(2)
                    pick_word.text = "("
                            + result.scenePosition.x.toFixed(2) + ", "
                            + result.scenePosition.y.toFixed(2) + ", "
                            + result.scenePosition.z.toFixed(2) + ")"
                    //console.log('in',pick_screen.text)
                    //console.log(result.scenePosition)
                    var map_from = control.mapFrom3DScene(pickNode.scenePosition)
                    //var map_to = control.mapTo3DScene(Qt.vector3d(mouse.x,mouse.y,map_from.z))
                    //console.log(map_from)
                    //console.log(map_to)
                    xOffset = map_from.x - mouse.x
                    yOffset = map_from.y - mouse.y
                    zOffset = map_from.z
                } else {
                    panner.mouseEnabled = true
                    pickNode = null
                    pick_name.text = "None"
                    pick_distance.text = " "
                    pick_word.text = " "
                }
            }
            onPositionChanged: {
                if(!mouse_area.containsMouse || !pickNode){
                    return
                }
                var pos_temp = Qt.vector3d(mouse.x + xOffset, mouse.y + yOffset, zOffset);
                var map_to = control.mapTo3DScene(pos_temp)
                pickNode.x = map_to.x
                pickNode.y = map_to.y
                pickNode.z = map_to.z
            }
        }
}
