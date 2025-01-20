cmake_minimum_required(VERSION 3.16)
project(lindbergh-gui LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets)
qt_standard_project_setup()

add_executable(lindbergh-gui
    src/main.cpp
    src/mainwindow.cpp
    src/mainwindow.h
    src/settingsdialog.cpp
    src/settingsdialog.h
    src/setupdialog.cpp
    src/setupdialog.h
    src/gamedata.h
)

target_link_libraries(lindbergh-gui PRIVATE Qt6::Widgets)

# Enable automoc for Qt
set_target_properties(lindbergh-gui PROPERTIES
    AUTOMOC ON
    AUTORCC ON
    AUTOUIC ON
)
