// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtQuick.Window
import QtWayland.Compositor

WaylandOutput {
    id: id_wloutput01

    property ListModel prop_shellSurfaces: ListModel {}
    property bool prop_isNestedCompositor: Qt.platform.pluginName.startsWith("wayland")
                                           || Qt.platform.pluginName === "xcb"

    // ![handleShellSurface]
    function handleShellSurface(shellSurface) {
        console.log("handleShellsurface: param=", shellSurface, ",id_wloutput01.prop_isNestedCompositor=",
                    id_wloutput01.prop_isNestedCompositor, ",Qt.platform.pluginName=", Qt.platform.pluginName,
                    ",sizeFollowsWindow=", id_wloutput01.sizeFollowsWindow)
        prop_shellSurfaces.append({
                                      "shellSurface": shellSurface
                                  })
    }

    // ![handleShellSurface]

    // During development, it can be useful to start the compositor inside X11 or
    // another Wayland compositor. In such cases, set sizeFollowsWindow to true to
    // enable resizing of the compositor window to be forwarded to the Wayland clients
    // as the id_wloutput01 (screen) changing resolution. Consider setting it to false if you
    // are running the compositor using eglfs, linuxfb or similar QPA backends.
    //sizeFollowsWindow: id_wloutput01.prop_isNestedCompositor
    window: Window {
        id: id_wdInOP
        width: 800
        height: 760
        visible: true

        WaylandMouseTracker {
            id: mouseTracker

            anchors.fill: parent

            // Set this to false to disable the outer mouse cursor when running nested
            // compositors. Otherwise you would see two mouse cursors, one for each compositor.
            windowSystemCursorEnabled: id_wloutput01.prop_isNestedCompositor

            Image {
                id: background

                anchors.fill: parent
                fillMode: Image.Tile
                source: "qrc:/images/background.jpg"
                smooth: true

                // ![repeater]
                Repeater {
                    model: id_wloutput01.prop_shellSurfaces
                    // Chrome displays a shell surface on the screen (See Chrome.qml)
                    Chrome {
                        shellSurface: modelData
                        onSig_destroyAnimationFinished: id_wloutput01.prop_shellSurfaces.remove(index)
                    }
                }
                // ![repeater]
            }

            // Virtual Keyboard
            // ![keyboard]
            Loader {
                anchors.fill: parent
                source: "Keyboard.qml"
            }
            // ![keyboard]

            // Draws the mouse cursor for a given Wayland seat
            WaylandCursorItem {
                inputEventsEnabled: false
                x: mouseTracker.mouseX
                y: mouseTracker.mouseY
                seat: id_wloutput01.compositor.defaultSeat
            }
        }

        Shortcut {
            sequence: "Ctrl+Alt+Backspace"
            onActivated: Qt.quit()
        }
        onAfterRendering: {

            //console.log("screen0-prop:", id_screen0.manufacturer)
        }
    }
}
