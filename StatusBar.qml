import QtQuick 2.0

import CustomModel
import QtQuick.Controls
Column {
    property string touch_point: "none"
    property string pick_name: "none"
    property var pickNode: null
    property string pick_distance: "none"
    property string pick_word: "none"
    property int font_size: 14
    property string font_color: "white"

    Row{
        spacing: 20
        Label {
            color: font_color
            font.pointSize: font_size
            text: touch_point
        }
        Label {
            color: font_color
            font.pointSize: font_size
            text: pick_name
        }
        Label {
            color: font_color
            font.pointSize: font_size
            text: pick_distance
        }
        Label {
            color: font_color
            font.pointSize: font_size
            text: pick_word
        }
    }

}
