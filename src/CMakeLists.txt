cmake_minimum_required(VERSION 3.7)

find_package(PkgConfig REQUIRED)
find_package(Qt5 COMPONENTS Core Gui Quick DBus X11Extras REQUIRED)
find_package(DtkDeclarative REQUIRED)
find_package(KF5WindowSystem REQUIRED)

pkg_check_modules(XCB_LIBS REQUIRED xcb)

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
    qml.qrc
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