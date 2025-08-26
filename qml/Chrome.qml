// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtWayland.Compositor

//WaylandSurface
ShellSurfaceItem {
    id: id_chrome_shellSurfaceItem

    property bool prop_isChild: parent.shellSurface !== undefined
    signal sig_destroyAnimationFinished

    // ![destruction]
    onSurfaceDestroyed: {
        id_chrome_shellSurfaceItem.bufferLocked = true
        destroyAnimation.start()
    }

    SequentialAnimation {
        id: destroyAnimation

        ParallelAnimation {
            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                to: 2 / height
                duration: 150
            }
            NumberAnimation {
                target: scaleTransform
                property: "xScale"
                to: 0.4
                duration: 150
            }
            NumberAnimation {
                target: id_chrome_shellSurfaceItem
                property: "opacity"
                to: id_chrome_shellSurfaceItem.prop_isChild ? 0 : 1
                duration: 150
            }
        }
        NumberAnimation {
            target: scaleTransform
            property: "xScale"
            to: 0
            duration: 150
        }
        ScriptAction {
            script: sig_destroyAnimationFinished()
        }
    }

    // ![destruction]
    transform: [
        Scale {
            id: scaleTransform
            origin.x: id_chrome_shellSurfaceItem.width / 2
            origin.y: id_chrome_shellSurfaceItem.height / 2
        }
    ]

    // ![activation]
    Connections {
        target: shellSurface.toplevel !== undefined ? shellSurface.toplevel : null

        // some signals are not available on wl_shell, so let's ignore them
        ignoreUnknownSignals: true

        function onActivatedChanged() {
            // xdg_shell only
            if (shellSurface.toplevel.activated) {
                receivedFocusAnimation.start()
            }
        }
    }

    SequentialAnimation {
        id: receivedFocusAnimation

        ParallelAnimation {
            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                to: 1.02
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: scaleTransform
                property: "xScale"
                to: 1.02
                duration: 100
                easing.type: Easing.OutQuad
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                to: 1
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: scaleTransform
                property: "xScale"
                to: 1
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    }
    // ![activation]
}
