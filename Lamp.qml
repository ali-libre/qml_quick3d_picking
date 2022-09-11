import QtQuick3D
import QtQuick3D.Particles3D
import QtQuick3D.AssetUtils
import QtQuick3D.Helpers

Model {
    objectName: "lamp"
    source: "#Sphere"
    pickable: true
    property bool isPicked: true
    //! [pickable model]


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
