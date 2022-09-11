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

    //c++ Model
    CModel{
        id:modeler
    }

    JSONListModel{
        id: listModel
        source: modeler.getPlainJsonData()
        query: "$.nozzle[*]"
//        source:
        json: modeler.getPlainJsonData()
//        data: modeler.getPlainJsonData()
//        model: modeler.getPlainJsonData()
        Component.onCompleted: console.log("count is: " + listModel.count + " ,data is: " + listModel.json)
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
            y: 300
            z: 1500
            onPositionChanged: {
                console.log(x,y,z,rotation.x,rotation.y, rotation.z)
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
                pumpValue: controlPanel.slid
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
            controlPanel.touchPoint = "(" + mouse.x + ", " + mouse.y + ")"
            //pick Take the nearest intersection with the ray path at this point Model Information about , return PickResult object
            // Because the module has been iterating , The new version can be downloaded from PickResult Object to get more information
            //Qt6 It is also provided pickAll Get all that intersect the ray Model Information
            var result = control.pick(mouse.x, mouse.y)
            // Currently only updated when clicked pick Information about objects
            if (result.objectHit) {
                panner.mouseEnabled = false
                pickNode = result.objectHit
                pickNode.isPicked = !pickNode.isPicked
                controlPanel.pick_name = pickNode.objectName
                controlPanel.pick_distance = result.distance.toFixed(2)
                controlPanel.pick_word= "("
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
            var map_to = control.mapTo3DScene(pos_temp)
            pickNode.x = map_to.x
            pickNode.y = map_to.y
            pickNode.z = map_to.z
        }
    }
}
