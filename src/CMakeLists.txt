cmake_minimum_required(VERSION 3.7)

find_package(PkgConfig REQUIRED)
find_package(Qt5 COMPONENTS Core Gui Quick DBus X11Extras REQUIRED)
find_package(DtkDeclarative REQUIRED)
find_package(KF5WindowSystem REQUIRED)

pkg_check_modules(XCB_LIBS REQUIRED xcb)

# libdbusmenuqt
set_source_files_properties(libdbusmenuqt/com.canonical.dbusmenu.xml PROPERTIES
   NO_NAMESPACE true
   INCLUDE "libdbusmenuqt/dbusmenutypes_p.h"
   CLASSNAME DBusMenuInterface
)

## appmenu
qt5_add_dbus_adaptor(appmenu_SRCS appmenu/com.canonical.AppMenu.Registrar.xml
    appmenu/menuimporter.h MenuImporter menuimporteradaptor MenuImporterAdaptor)
qt5_add_dbus_adaptor(appmenu_SRCS appmenu/fun.tarrow.appmenu.xml
    appmenu/appmenudbus.h AppmenuDBus appmenuadaptor AppmenuAdaptor)

add_executable(top-panel 
    main.cpp
    panel.cpp
    panel.h
    panelhelper.cpp
    panelhelper.h
    applicationhandler.cpp
    applicationhandler.h
    desktopmenu/menupopupwindow.cpp
    desktopmenu/menupopupwindow.h
    window/windowblur.cpp
    window/windowblur.h

    libdbusmenuqt/dbusmenuimporter.cpp
    libdbusmenuqt/dbusmenushortcut_p.cpp
    libdbusmenuqt/dbusmenutypes_p.cpp
    libdbusmenuqt/utils.cpp

    appmenu/kdbusimporter.h
    appmenu/appmenu.h
    appmenu/appmenu.cpp
    appmenu/appmenudbus.h
    appmenu/appmenudbus.cpp
    appmenu/verticalmenu.h
    appmenu/verticalmenu.cpp
    appmenu/menuimporter.h
    appmenu/menuimporter.cpp
    appmenu/appmenumodel.h
    appmenu/appmenumodel.cpp
    appmenu/appmenuapplet.h
    appmenu/appmenuapplet.cpp
    appmenu/dbusmenu_interface.cpp
    appmenu/dbusmenu_interface.h

    qml.qrc

    ${appmenu_SRCS}
)

target_link_libraries(top-panel PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Quick
    Qt5::DBus
    Qt5::X11Extras
    Dtk::Declarative
    KF5::WindowSystem
    ${XCB_LIBS_LIBRARIES}
)