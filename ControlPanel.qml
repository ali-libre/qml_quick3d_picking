import QtQuick 2.0

import QtQuick.Controls
Column {
    property int slid: 200
    property string touchPoint: "none"
    property string pick_name: "none"
    property string pick_distance: "none"
    property string pick_word: "none"


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
                    slid = value
            }

            Label {
                color: "white"
                font.pointSize: 14
                text: touchPoint
            }
            Label {
                color: "white"
                font.pointSize: 14
                text: pick_name
            }
            Label {
                color: "white"
                font.pointSize: 14
                text: pick_distance
            }
            Label {
                color: "white"
                font.pointSize: 14
                text: pick_word
            }

            Button{
                text: "test"
                onClicked: {
                    console.log(modeler.getPlainJsonData())
                }
            }
        }
    }
}
