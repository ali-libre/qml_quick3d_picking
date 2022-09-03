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
import QtQuick3D.Helpers

Window {
    visible: true
    width: 400
    height: 300
    title: qsTr("Picking Example")
    color: "#444444"
    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
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
        Row{
            Label {
                id: pick_screen
                color: "white"
                font.pointSize: 14
            }
            Label {
                id: pick_name
                color: "white"
                font.pointSize: 14
            }
            Label {
                id: pick_distance
                color: "white"
                font.pointSize: 14
            }
            Label {
                id: pick_word
                color: "white"
                font.pointSize: 14
            }
        }
    }

    View3D {
        id: control
        anchors.fill: parent
        renderMode: View3D.Underlay

        PointLight {
            x: 400
            y: 600
            z: 400
            quadraticFade: 0
            ambientColor: Qt.rgba(.3,.3, .3, 1)
            brightness: 80
        }
        camera: persepectivecamera
        PerspectiveCamera {
            id: persepectivecamera
            z: 1500
            y: 500
        }
        WasdController {
            id: panner
            controlledObject: persepectivecamera
            mouseEnabled: false
            speed: 3
//            keysEnabled: true
        }
//        environment: SceneEnvironment {
//            clearColor: "#000000"
//            backgroundMode: SceneEnvironment.Color
//        }

        Component{
            id: myComponent
            Model{
//                source: "#Rectangle"
                source: "#Rectangle"
                scale: Qt.vector3d(.1, .1, 0)
                materials: DefaultMaterial{

                }
            }
        }



        //! [pickable model]
        Model {
            id: cubeModel
            objectName: "Cube"
            source: "#Cube"
            pickable: true
            property bool isPicked: false
            //! [pickable model]

            scale.x: 1.5
            scale.y: 2
            scale.z: 1.5

            //! [picked color]
            materials: DefaultMaterial {
                diffuseColor: cubeModel.isPicked ? "#41cd52" : "#09102b"
                //! [picked color]
                specularAmount: 0.25
                specularRoughness: 0.2
                roughnessMap: Texture { source: "maps/roughness.jpg" }
            }


            ParticleSystem3D{
                id: pSystem

                ModelParticle3D{
                    id:myParticle
                    delegate: myComponent
                    maxAmount: 1000
                    color:  "#0000FF"
                    colorVariation: Qt.vector4d(0, 0, .5, .5)

                }

                ParticleEmitter3D{
                    id: myEmitter
                    particle: myParticle
                    z: -300
                    emitRate: 100
                    lifeSpan: 8000
                    particleRotationVelocityVariation: Qt.vector3d(100,0, 100)
                    particleRotationVariation: Qt.vector3d(80,80,80)
                    particleScale: 3
                    velocity: VectorDirection3D{
                        direction: Qt.vector3d(0, 500, 0);
                        directionVariation: Qt.vector3d(80, 80, 80)
                    }
                    //! [picked animation]
                    SequentialAnimation on eulerRotation {
                        running: !cubeModel.isPicked
                        //! [picked animation]
                        loops: Animation.Infinite
                        PropertyAnimation {
                            duration: 2500
                            from: Qt.vector3d(0, 0, -30)
                            to: Qt.vector3d(0, 0, 30)
                        }
                    }
                }
                Gravity3D{
                    direction: Qt.vector3d(0,1,0)
                    magnitude: -200
                }
            }
        }
/*
        Model {
            id: coneModel
            objectName: "Cone"
            source: "#Cone"
            pickable: true
            property bool isPicked: false

            x: 200
            z: 100

            scale.x: 2
            scale.y: 1.5
            scale.z: 2

            materials: DefaultMaterial {
                diffuseColor: coneModel.isPicked ? "#53586b" : "#21be2b"
                specularAmount: 1
                specularRoughness: 0.1
                roughnessMap: Texture { source: "maps/roughness.jpg" }
            }

            SequentialAnimation on eulerRotation {
                running: !coneModel.isPicked
                loops: Animation.Infinite
                PropertyAnimation {
                    duration: 10000
                    from: Qt.vector3d(0, 0, 0)
                    to: Qt.vector3d(-360, 360, 0)
                }
            }
        }

        Model {
            id: sphereModel
            objectName: "Sphere"
            source: "#Sphere"
            pickable: true
            property bool isPicked: false

            x: -100
            y: -100
            z: -100

            scale.x: 5
            scale.y: 3
            scale.z: 3

            materials: DefaultMaterial {
                diffuseColor: sphereModel.isPicked ? "#17a81a" : "#9d9faa"
                specularAmount: 0.25
                specularRoughness: 0.2
                roughnessMap: Texture { source: "maps/roughness.jpg" }
            }

            SequentialAnimation on eulerRotation.x {
                running: !sphereModel.isPicked
                loops: Animation.Infinite
                PropertyAnimation {
                    duration: 5000
                    from: 0
                    to: 10
                }
            }
        }
        */
    }

    //! [mouse area]
//    MouseArea {
//        anchors.fill: view
//        //! [mouse area]

//        onClicked: {
//            // Get screen coordinates of the click
//            pickPosition.text = "Screen Position: (" + mouse.x + ", " + mouse.y + ")"
//            //! [pick result]
//            var result = view.pick(mouse.x, mouse.y);
//            //! [pick result]
//            //! [pick specifics]
//            if (result.objectHit) {
//                var pickedObject = result.objectHit;
//                // Toggle the isPicked property for the model
//                pickedObject.isPicked = !pickedObject.isPicked;
//                // Get picked model name
//                pickName.text = "Last Pick: " + pickedObject.objectName;
//                // Get other pick specifics
//                uvPosition.text = "UV Position: ("
//                        + result.uvPosition.x.toFixed(2) + ", "
//                        + result.uvPosition.y.toFixed(2) + ")";
//                distance.text = "Distance: " + result.distance.toFixed(2);
//                scenePosition.text = "World Position: ("
//                        + result.scenePosition.x.toFixed(2) + ", "
//                        + result.scenePosition.y.toFixed(2) + ")";
//                //! [pick specifics]
//            } else {
//                pickName.text = "Last Pick: None";
//            }
//        }
//    }

    MouseArea {
            id: mouse_area
            anchors.fill: parent
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
