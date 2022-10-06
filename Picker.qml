import QtQuick 2.0

MouseArea {
    id: mouse_area
    anchors.fill: viewScene
    hoverEnabled: false
    property var pickNode: null
    property var viewScene: null
    // Mouse and objects xy The migration
    property real xOffset: 0
    property real yOffset: 0
    property real zOffset: 0
    property string pickName: "--"
    property string pickDistance: "--"
    property string pickWord: "--"
    property string touchPoint: "--"

    onPressed: {
        // Get point at View Screen coordinates on
        touchPoint = "(" + mouseX + ", " + mouseY + ")"
        //pick Take the nearest intersection with the ray path at this point Model Information about , return PickResult object
        // Because the module has been iterating , The new version can be downloaded from PickResult Object to get more information
        //Qt6 It is also provided pickAll Get all that intersect the ray Model Information
//        var result = viewScene.pick(mouse.x, mouse.y)
        var result = viewScene.pick(mouseX, mouseY)
        // Currently only updated when clicked pick Information about objects
        if (result.objectHit) {
            panner.mouseEnabled = false
            pickNode = result.objectHit
//                pickNode.isPicked = !pickNode.isPicked
            pickName = pickNode.objectName
            pickDistance = result.distance.toFixed(2)
            pickWord= "("
                    + result.scenePosition.x.toFixed(2) + ", "
                    + result.scenePosition.y.toFixed(2) + ", "
                    + result.scenePosition.z.toFixed(2) + ")"
            //console.log('in',pick_screen.text)
            //console.log(result.scenePosition)
            var map_from = viewScene.mapFrom3DScene(pickNode.scenePosition)
            //var map_to = scene.mapTo3DScene(Qt.vector3d(mouse.x,mouse.y,map_from.z))
            //console.log(map_from)
            //console.log(map_to)
            xOffset = map_from.x - mouseX
            yOffset = map_from.y - mouseY
            zOffset = map_from.z
        } else {
            panner.mouseEnabled = true
            pickNode = null
            pickName = "None"
            pickDistance = " "
            pickWord = " "
        }
    }
    onReleased: {
        pickNode = null
    }

    onPositionChanged: {
        if(!mouse_area.containsMouse || !pickNode){
            return
        }
        var pos_temp = Qt.vector3d(mouseX + xOffset, mouseY + yOffset, zOffset);
        var map_to = scene.mapTo3DScene(pos_temp)
        pickNode.x = map_to.x
        pickNode.y = map_to.y
        pickNode.z = map_to.z
    }
}
