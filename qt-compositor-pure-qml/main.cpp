// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#include <QtCore/QDebug>
#include <QtCore/QUrl>

#include <QtGui/QGuiApplication>

#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  // ShareOpenGLContexts is needed for using the threaded renderer
  // on Nvidia EGLStreams
  // Note: If the compositor has multiple Wayland outputs, the Qt::AA_ShareOpenGLContexts
  // attribute must be set before the QGuiApplication object is constructed.
  QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts, true);
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine appEngine(QUrl("qrc:///qml/main.qml"));

  return app.exec();
}
