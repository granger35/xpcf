QT       -= core gui
CONFIG -= app_bundle qt

TARGET = xpcfHelloConfigurable
FRAMEWORK = $${TARGET}
VERSION=1.0.0
DEFINES +=  $${TARGET}VERSION=\"$${VERSION}\"

CONFIG += c++1z
CONFIG += shared

DEPENDENCIESCONFIG = sharedlib recurse
#NOTE : CONFIG as staticlib or sharedlib, DEPENDENCIESCONFIG as staticlib or sharedlib and PROJECTDEPLOYDIR MUST BE DEFINED BEFORE templatelibbundle.pri inclusion
include (../../builddefs/qmake/templatelibconfig.pri)

DEFINES += BOOST_ALL_NO_LIB
DEFINES += BOOST_ALL_DYN_LINK

SOURCES +=     xpcfHelloConfigurable_main.cpp \
    ConfigurableComponent.cpp

HEADERS +=     xpcfHelloConfigurableAPI.h     xpcfHelloConfigurable_traits.h \
    ConfigurableComponent.h \
    interfaces/IMessage.h

unix {
}

macx {
    DEFINES += _MACOS_TARGET_
    QMAKE_MAC_SDK= macosx
    QMAKE_CFLAGS += -mmacosx-version-min=10.7 #-x objective-c++
    QMAKE_CXXFLAGS += -mmacosx-version-min=10.7 -std=c++17 -fPIC#-x objective-c++
    QMAKE_LFLAGS += -mmacosx-version-min=10.7 -v -lstdc++
    LIBS += -lstdc++ -lc -lpthread
}

win32 {
    DEFINES += _X86_VC12_TARGET_
    DEFINES += MBCS _MBCS
 }

INCLUDEPATH += $${PWD} $${PWD}/../interfaces

header_files.path = $${PROJECTDEPLOYDIR}/interfaces/
header_files.files = $$files($${PWD}/../interfaces/*.h)
header_files.files += _traits.h

target.path = $${USERHOMEFOLDER}/.xpcf/modules/$${TARGET}
xpcf_xml_files.path = $${USERHOMEFOLDER}/.xpcf/samples
xpcf_xml_files.files=$$files($${PWD}/xpcfHelloConfigurable.xml)

INSTALLS += header_files target xpcf_xml_files
DISTFILES +=     Makefile \
    bcom-xpcfHelloConfigurable.pc.in \
    xpcfHelloConfigurable.xml
