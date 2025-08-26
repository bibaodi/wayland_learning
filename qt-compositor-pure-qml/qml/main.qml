// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQuick
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import QtWayland.Compositor.WlShell
import QtWayland.Compositor.IviApplication

WaylandCompositor {
    id: waylandCompositor
    socketName: 'wayland-qt0'

    CompositorScreen {
        id: id_screen0
        compositor: waylandCompositor
    }

    // ![shell extensions]
    // Shell surface extension. Needed to provide a window concept for Wayland clients.
    // I.e. requests and events for maximization, minimization, resizing, closing etc.
    XdgShell {

        onToplevelCreated: (toplevel, xdgSurface) => {
                               id_screen0.handleShellSurface(xdgSurface)
                               console.log("surface xdgshell")
                           }
    }

    // Minimalistic shell extension. Mainly used for embedded applications.
    IviApplication {
        onIviSurfaceCreated: iviSurface => {
                                 id_screen0.handleShellSurface(iviSurface)
                                 console.log("surface IviApplication")
                             }
    }

    // Deprecated shell extension, still used by some clients
    WlShell {
        onWlShellSurfaceCreated: shellSurface => {
                                     id_screen0.handleShellSurface(shellSurface)
                                     console.log("surface WlShell")
                                 }
    }
    // ![shell extensions]

    // Extension for Input Method (QT_IM_MODULE) support at compositor-side
    // ![text input]
    TextInputManager {}
    QtTextInputMethodManager {}
    // ![text input]
    onSurfaceCreated: surface => {
                          console.log("surface created:", surface)
                      }
    onSurfaceRequested: (client, id, version) => {
                            console.log("surface requested", client, id, version)
                        }
}
