QT       += core gui widgets sql websockets

contains(CONFIG, SINGLEBIN) {
    QT += concurrent printsupport
    CONFIG(USE_EMBED_BROWSER) {
        DEFINES+=USE_EMBED_BROWSER
        CONFIG(USE_WEBENGINE) {
            QT += webenginewidgets
            DEFINES += USE_WEBENGINE
        } else {
            QT += webkitwidgets
        }
    }
}
contains(CONFIG, SERVER_BUILD) {
    DEFINES+=SERVER_BUILD
}

TARGET = Sultan
TEMPLATE = app

CONFIG += c++11

contains(CONFIG, SINGLEBIN) {
    include(../libglobal/libglobal_src.pri)
    include(../libdb/libdb_src.pri)
    include(../libserver/libserver_src.pri)
    !contains(CONFIG, SERVER_BUILD) {
        include(../external_library/o2/src/src.pri)
        include(../libprint/libprint_src.pri)
        include(../libgui/libgui_src.pri)
    }
} else {
    include(../libglobal/libglobal.pri)
    include(../libdb/libdb.pri)
    include(../libserver/libserver.pri)
    !contains(CONFIG, SERVER_BUILD) {
        include(../libprint/libprint.pri)
        include(../libgui/libgui.pri)
    }
}

CONFIG(NO_PRINTER_DEVICE) {
    DEFINES+=NO_PRINTER_DEVICE
}

macx {
    QMAKE_LIBDIR += $$OUT_PWD/../bin/Sultan.app/Contents/Frameworks
    LIBS += -framework Foundation
    contains(CONFIG, SINGLEBIN) {
        DEFINES+=SINGLEBIN
        LIBS += -lcups
    }
    DESTDIR = ../bin
    copymigration_sqlite.commands = $$quote(cp -R $${PWD}/../migration_sqlite $$OUT_PWD/../bin/Sultan.app/Contents/Resources)
    copymigration_mysql.commands = $$quote(cp -R $${PWD}/../migration_mysql $$OUT_PWD/../bin/Sultan.app/Contents/Resources)
    copytr.commands = $$quote(cp -R $${PWD}/../translation/*.qm $${OUT_PWD}/../bin/)
    copysetting.commands = $(COPY) $${PWD}/../script/setting.json $${OUT_PWD}/../bin/
} else:win32 {
    LIBS += -L$$OUT_PWD/../bin
    contains(CONFIG, SINGLEBIN) {
        DEFINES+=SINGLEBIN
        !contains(CONFIG, NO_PRINTER_SPOOL) {
            LIBS += -lKernel32 -lwinspool
        } else {
            DEFINES+=NO_PRINTER_SPOOL
        }
    }
    RC_FILE = sultan.rc
    DESTDIR = ../bin/
    PWD_WIN = $${PWD}
    DESTDIR_WIN = $$OUT_PWD/../bin/
    PWD_WIN ~= s,/,\\,g
    DESTDIR_WIN ~= s,/,\\,g
    copymigration_sqlite.commands = $$quote(cmd /c xcopy /S /I /Y $${PWD_WIN}\..\migration_sqlite $${DESTDIR_WIN}\migration_sqlite)
    copymigration_mysql.commands = $$quote(cmd /c xcopy /S /I /Y $${PWD_WIN}\..\migration_mysql $${DESTDIR_WIN}\migration_mysql)
    copytr.commands = $$quote(cmd /c xcopy /S /I /Y $${PWD_WIN}\..\translation\lib*.qm $${DESTDIR_WIN})
    copysetting.commands = $$quote(cmd /c xcopy /S /I /Y $${PWD_WIN}\..\script\setting.json $${DESTDIR_WIN})
} else {
    QMAKE_LIBDIR = $$OUT_PWD/../bin $$QMAKE_LIBDIR
    LIBS += -L$$OUT_PWD/../bin
    contains(CONFIG, SINGLEBIN) {
        DEFINES+=SINGLEBIN
        !contains(CONFIG, NO_PRINTER_SPOOL) {
            LIBS += -lcups
        } else {
            DEFINES+=NO_PRINTER_SPOOL
        }
    }
    contains(CONFIG, USE_LIBUSB) {
        DEFINES+=USE_LIBUSB
        LIBS += -lusb-1.0
    }
    DESTDIR = ../bin
    copymigration_sqlite.commands = $$quote(cp -R $${PWD}/../migration_sqlite $${OUT_PWD}/../bin/)
    copymigration_mysql.commands = $$quote(cp -R $${PWD}/../migration_mysql $${OUT_PWD}/../bin/)
    copysh.commands = $$quote(cp -R $${PWD}/../script/Sultan.sh $${OUT_PWD}/../bin/)
    copytr.commands = $(COPY) $${PWD}/../translation/*.qm $${OUT_PWD}/../bin/
    copysetting.commands = $(COPY) $${PWD}/../script/setting.json $${OUT_PWD}/../bin/
    QMAKE_EXTRA_TARGETS += copysh
    POST_TARGETDEPS += copysh
}


QMAKE_EXTRA_TARGETS += copymigration_sqlite copymigration_mysql copytr copysetting
POST_TARGETDEPS += copymigration_sqlite copymigration_mysql copytr copysetting

RESOURCES += sultan.qrc

TRANSLATIONS = ../translation/sultan_id.ts

SOURCES += main.cpp \
    core.cpp \
    socket/socketmanager.cpp \
    socket/socketclient.cpp \
    socket/sockethandler.cpp \
    dummy/guidummy.cpp

HEADERS  += \
    core.h \
    socket/socketmanager.h \
    socket/socketclient.h \
    socket/sockethandler.h \
    dummy/guidummy.h

FORMS +=
