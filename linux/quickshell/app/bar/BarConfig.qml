pragma Singleton

import Quickshell
import qs.config as Config

Singleton {
    enum Position {
        Left,
        Right,
        Top,
        Bottom
    }

    readonly property var positionValues: [
        BarConfig.Position.Left,
        BarConfig.Position.Right,
        BarConfig.Position.Top,
        BarConfig.Position.Bottom,
    ]

    property int position: BarConfig.Position.Top
    property int size: Config.Theme.barHeight
    property int borderSize: 4 // TODO: this is global border size
    property bool reserveSpace: true

    readonly property bool vertical: isVertical(position)
    readonly property bool horizontal: !vertical

    function isVertical(position) {
        return position === BarConfig.Position.Left
            || position === BarConfig.Position.Right
    }

    function correspondingAnchor(position) {
        const left   = (position === BarConfig.Position.Left)
        const right  = (position === BarConfig.Position.Right)
        const top    = (position === BarConfig.Position.Top)
        const bottom = (position === BarConfig.Position.Bottom)

        return {
            left: left,
            right: right,
            top: top,
            bottom: bottom,
        }
    }

    function anchorsForPosition(position) {
        const left   = (position === BarConfig.Position.Left)
        const right  = (position === BarConfig.Position.Right)
        const top    = (position === BarConfig.Position.Top)
        const bottom = (position === BarConfig.Position.Bottom)

        return {
            left:   left   || top  || bottom,
            right:  right  || top  || bottom,
            top:    top    || left || right,
            bottom: bottom || left || right,
        }
    }
}
