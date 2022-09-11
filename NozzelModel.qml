import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Particles3D
import QtQuick3D.AssetUtils
import QtQuick3D.Helpers
Node {
    property bool isPicked: false
    property int pumpValue: 200
    property int pX: 0
    property int pY: 0
    property int pZ: 0
    Model {
        id: cubeModel
        objectName: "Cube"
        source: "#Sphere"
        pickable: true
        //! [pickable model]
        x: pX
        y: pY
        z: pZ
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
                    direction: Qt.vector3d(0, pumpValue, 0);
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
}
