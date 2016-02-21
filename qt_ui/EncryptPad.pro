QT       += core gui widgets

CONFIG(debug, debug|release){
    CONFIG_NAME = debug
    SUBDIR_RELEASE =
}

CONFIG(release, debug|release){
    CONFIG_NAME = release
    SUBDIR_RELEASE = RELEASE=on
}

unix|macx: DEPS_SUBDIR = $$system(cd ../build && ./get_subdir.sh $$SUBDIR_RELEASE)

# For windows build sh.exe needs to be in the PATH environment variable
win32: DEPS_SUBDIR = $$system(cd ..\build && sh .\get_subdir.sh $$SUBDIR_RELEASE)
#message(DEPS_SUBDIR=$$DEPS_SUBDIR)

# install
target.path = /prj/EncryptPadLight
sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS EncryptPad.pro images
sources.path = /prj/EncryptPadLight
INSTALLS += target sources

CONFIG += c++11

QMAKE_CFLAGS += -fexceptions -o2

FORMS += \
    set_key_dialog.ui \
    file_properties_dialog.ui \
    new_key_dialog.ui \
    preferences_dialog.ui \
    find_and_replace.ui \
    get_password_dialog.ui \
    confirm_password_dialog.ui \
    get_password_or_key_dialog.ui \
    file_encryption_dialog.ui \
    password_generation_dialog.ui \
    find_dialog.ui

win32: LIBS += -luserenv
#unix: LIBS += ldl
LIBS += -L$$PWD/../deps/stlplus/portability/$$DEPS_SUBDIR -L$$PWD/../deps/botan \
     -L$$PWD/../back_end_src/$$DEPS_SUBDIR \
     -lback_end_src -lportability -lbotan-1.10 $$PWD/../deps/zlib/libz.a 

INCLUDEPATH += $$PWD/../deps/stlplus/portability
INCLUDEPATH += $$PWD/../deps/botan/build/include
INCLUDEPATH += $$PWD/../back_end_src

SOURCES += \
    application.cpp \
    file_name_helper.cpp \
    main.cpp \
    mainwindow.cpp \
    set_key_dialog.cpp \
    set_password_dialog.cpp \
    async_load.cpp \
    plain_text_switch.cpp \
    file_properties_dialog.cpp \
    new_key_dialog.cpp \
    preferences_dialog.cpp \
    recent_files_service.cpp \
    find_and_replace.cpp \
    get_password_dialog.cpp \
    confirm_password_dialog.cpp \
    get_password_or_key_dialog.cpp \
    set_encryption_key.cpp \
    file_encryption_dialog.cpp \
    m_window_load_adapter.cpp \
    file_encryption_dlg_adapter.cpp \
    file_dlg_async.cpp \
    password_generation_dialog.cpp \
    load_save_handler.cpp \
    file_request_service.cpp \
    plain_text_edit.cpp \
    find_dialog.cpp

HEADERS += \
    application.h \
    file_name_helper.h \
    mainwindow.h \
    set_key_dialog.h \
    set_password_dialog.h \
    async_load.h \
    plain_text_switch.h \
    file_properties_dialog.h \
    new_key_dialog.h \
    preferences_dialog.h \
    recent_files_service.h \
    find_and_replace.h \
    get_password_dialog.h \
    confirm_password_dialog.h \
    get_password_or_key_dialog.h \
    set_encryption_key.h \
    file_encryption_dialog.h \
    m_window_load_adapter.h \
    file_encryption_dlg_adapter.h \
    file_dlg_async.h \
    password_generation_dialog.h \
    load_save_handler.h \
    file_request_service.h \
    plain_text_edit.h \
    common_definitions.h \
    find_dialog.h

RESOURCES += \
    EncryptPad.qrc

RC_FILE = encrypt_pad.rc
DESTDIR = $$CONFIG_NAME
OBJECTS_DIR = $$CONFIG_NAME/obj