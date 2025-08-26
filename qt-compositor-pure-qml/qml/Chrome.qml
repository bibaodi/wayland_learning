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
        console.log("surf-destroy=", shellSurface.toplevel, ",activated=", shellSurface.toplevel.activated)
        id_chrome_shellSurfaceItem.bufferLocked = true
        id_destroyAnimation.start()
    }

    SequentialAnimation {
        id: id_destroyAnimation

        ParallelAnimation {
            NumberAnimation {
                target: id_scaleTransform
                property: "yScale"
                to: 2 / height
                duration: 1500
            }
            NumberAnimation {
                target: id_scaleTransform
                property: "xScale"
                to: 0.4
                duration: 1500
            }
            NumberAnimation {
                target: id_chrome_shellSurfaceItem
                property: "opacity"
                to: id_chrome_shellSurfaceItem.prop_isChild ? 0 : 1
                duration: 1500
            }
        }
        NumberAnimation {
            target: id_scaleTransform
            property: "xScale"
            to: 0
            duration: 1500
        }
        ScriptAction {
            script: sig_destroyAnimationFinished()
        }
    }

    // ![destruction]
    transform: [
        Scale {
            id: id_scaleTransform
            origin.x: id_chrome_shellSurfaceItem.width / 2
            origin.y: id_chrome_shellSurfaceItem.height / 2
        }
    ]

    // ![activation]
    Connections {
        //target: id_chrome_shellSurfaceItem.shellSurface.toplevel !== undefined ? id_chrome_shellSurfaceItem.shellSurface.toplevel : null
        target: id_chrome_shellSurfaceItem.shellSurface.toplevel
        // some signals are not available on wl_shell, so let's ignore them
        ignoreUnknownSignals: true

        function onActivatedChanged() {
            console.log("id_chrome_shellSurfaceItem onActivatedChanged()")
            // xdg_shell only
            if (id_chrome_shellSurfaceItem.shellSurface.toplevel.activated) {
                id_receivedFocusAnimation.start()
                console.log("id_receivedFocusAnimation.start()")
            }
        }
    }
    Connections {
        target: shellSurface.toplevel !== undefined ? shellSurface.toplevel : null
        ignoreUnknownSignals: true
        function onActivatedChanged() {
            console.log("id_chrome_shellSurfaceItem onActivatedChanged()2")
            if (shellSurface.toplevel.activated) {
                receivedFocusAnimation.start()
            }
        }
    }

    SequentialAnimation {
        id: id_receivedFocusAnimation

        ParallelAnimation {
            NumberAnimation {
                target: id_scaleTransform
                property: "yScale"
                to: 1.02
                duration: 1000
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: id_scaleTransform
                property: "xScale"
                to: 1.02
                duration: 1000
                easing.type: Easing.OutQuad
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: id_scaleTransform
                property: "yScale"
                to: 1
                duration: 1000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: id_scaleTransform
                property: "xScale"
                to: 1
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }
    }
    // ![activation]
}
