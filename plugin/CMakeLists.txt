cmake_minimum_required(VERSION 3.28)
project(nyxde-plugin VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick Gui Concurrent DBus)
find_package(PkgConfig REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)

# ── NyxDE.Config ─────────────────────────────────────────────────────────────
qt_add_qml_module(nyxde-config
    URI NyxDE.Config
    VERSION 1.0
    PLUGIN_TARGET nyxde-config
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml/NyxDE/Config"
    SOURCES
        src/config/Config.hpp
        src/config/Config.cpp
)
target_link_libraries(nyxde-config PRIVATE Qt6::Core Qt6::Qml Qt6::Quick)
target_include_directories(nyxde-config PRIVATE src/config)

# ── NyxDE.ImageAnalyser ───────────────────────────────────────────────────────
qt_add_qml_module(nyxde-imageanalyser
    URI NyxDE.ImageAnalyser
    VERSION 1.0
    PLUGIN_TARGET nyxde-imageanalyser
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml/NyxDE/ImageAnalyser"
    SOURCES
        src/imageanalyser/ImageAnalyser.hpp
        src/imageanalyser/ImageAnalyser.cpp
)
target_link_libraries(nyxde-imageanalyser PRIVATE Qt6::Core Qt6::Qml Qt6::Quick Qt6::Gui Qt6::Concurrent)
target_include_directories(nyxde-imageanalyser PRIVATE src/imageanalyser)

# ── NyxDE.HyprExtras ─────────────────────────────────────────────────────────
qt_add_qml_module(nyxde-hyprextras
    URI NyxDE.HyprExtras
    VERSION 1.0
    PLUGIN_TARGET nyxde-hyprextras
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml/NyxDE/HyprExtras"
    SOURCES
        src/hyprextras/HyprExtras.hpp
        src/hyprextras/HyprExtras.cpp
)
target_link_libraries(nyxde-hyprextras PRIVATE Qt6::Core Qt6::Qml Qt6::DBus)
target_include_directories(nyxde-hyprextras PRIVATE src/hyprextras)

# ── NyxDE.Logind ─────────────────────────────────────────────────────────────
qt_add_qml_module(nyxde-logind
    URI NyxDE.Logind
    VERSION 1.0
    PLUGIN_TARGET nyxde-logind
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml/NyxDE/Logind"
    SOURCES
        src/logind/Logind.hpp
        src/logind/Logind.cpp
)
target_link_libraries(nyxde-logind PRIVATE Qt6::Core Qt6::Qml Qt6::DBus)
target_include_directories(nyxde-logind PRIVATE src/logind)

# ── NyxDE.Widgets ─────────────────────────────────────────────────────────────
qt_add_qml_module(nyxde-widgets
    URI NyxDE.Widgets
    VERSION 1.0
    PLUGIN_TARGET nyxde-widgets
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml/NyxDE/Widgets"
    SOURCES
        src/widgets/SparklineItem.hpp
        src/widgets/SparklineItem.cpp
        src/widgets/ArcGauge.hpp
        src/widgets/ArcGauge.cpp
        src/widgets/CircularBuffer.hpp
        src/widgets/CircularBuffer.cpp
)
target_link_libraries(nyxde-widgets PRIVATE Qt6::Core Qt6::Qml Qt6::Quick Qt6::Gui)
target_include_directories(nyxde-widgets PRIVATE src/widgets ${Qt6Quick_INCLUDE_DIRS})

# ── Install ───────────────────────────────────────────────────────────────────
set(QML_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml")

foreach(mod config imageanalyser hyprextras logind widgets)
    string(REPLACE "-" "" modname "nyxde-${mod}")
    install(
        DIRECTORY "${CMAKE_BINARY_DIR}/qml/NyxDE/"
        DESTINATION "${QML_INSTALL_DIR}/NyxDE"
        FILES_MATCHING PATTERN "*.so" PATTERN "*.qmltypes" PATTERN "qmldir"
    )
endforeach()
