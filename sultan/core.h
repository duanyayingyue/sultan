/*
 * core.h
 * Copyright 2017 - ~, Apin <apin.klas@gmail.com>
 *
 * This file is part of Sultan.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef CORE_H
#define CORE_H

#include <QObject>

class Splash;
class LoginDialog;
class SocketManager;
class SocketClient;

namespace LibG {
class MessageBus;
}

namespace LibServer {
class MainServer;
}

namespace LibGUI {
class MainWindow;
}

class Core : public QObject
{
    Q_OBJECT
public:
    Core(QObject *parent = 0);
    ~Core();
    void setup();
    void initLogger();

private:
    Splash *mSplashUi;
    LoginDialog *mLoginDialog;
    SocketManager *mSocketManager;
    SocketClient *mSocketClient;
    LibServer::MainServer *mMainServer;
    LibG::MessageBus *mMessageBus;
    LibGUI::MainWindow *mMainWindow;

private slots:
    void init();
    void connectToServer();
    void clientConnected();
    void clientDisconnected();
    void loginSuccess();
    void logout();
};

#endif // CORE_H
