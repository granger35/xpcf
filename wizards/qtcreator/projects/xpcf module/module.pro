QT       -= core gui
CONFIG -= app_bundle qt

TARGET = %{ModuleName}
FRAMEWORK = %{PackageNameKey}
@if '%{InstallSubDir}'
INSTALLSUBDIR =  %{InstallSubDir}
@endif
VERSION=%{PackageVersionKey}
DEFINES +=  $${TARGET}VERSION=\\\"$${VERSION}\\\"

# Uncomment following line to add more verbose information from builddefs-qmake rules
# CONFIG += verbose
# Uncomment following line to prepare remaken package
# CONFIG += package_remaken

@if '%{withQTVS}' && '%{withQTVS}' === 'QTVS'
CONFIG += with_qtvs
@else
# Uncomment following line to use rules with QTVS plugin mode for visual studio
# CONFIG += with_qtvs
@endif

with_qtvs {
    PROJECTCONFIG = QTVS
}

CONFIG += c++1z
CONFIG += shared

staticlib {
    DEPENDENCIESCONFIG = staticlib
    REMAKEN_PKGSUBDIR=static
} else {
    DEPENDENCIESCONFIG = sharedlib
    REMAKEN_PKGSUBDIR=shared
}

CONFIG(debug,debug|release) {
    DEFINES += _DEBUG=1
    DEFINES += DEBUG=1
    REMAKEN_PKGSUBDIR=$${REMAKEN_PKGSUBDIR}/debug
}

CONFIG(release,debug|release) {
    DEFINES += NDEBUG=1
    REMAKEN_PKGSUBDIR=$${REMAKEN_PKGSUBDIR}/release
}

package_remaken {
    message("Preparing remaken package installation in $${REMAKEN_PKGSUBDIR}")
    INSTALLSUBDIR=$${REMAKEN_PKGSUBDIR}
}

include(findremakenrules.pri)

@if '%{dependenciesBuildMode}' === 'shared'
DEPENDENCIESCONFIG = sharedlib
@else
DEPENDENCIESCONFIG = staticlib
@endif
@if '%{recurseDependencies}' === 'recurse' && '%{dependenciesInstallMode}' !== 'install_recurse'
DEPENDENCIESCONFIG += recurse
@endif
@if '%{dependenciesInstallMode}' !== 'noinstall'
DEPENDENCIESCONFIG += %{dependenciesInstallMode}
@endif

## Configuration for Visual Studio to install binaries and dependencies. Work also for QT Creator by replacing QMAKE_INSTALL
@if '%{withQTVS}' && '%{withQTVS}' === 'QTVS'
PROJECTCONFIG = QTVS
@endif

#NOTE : CONFIG as staticlib or sharedlib, DEPENDENCIESCONFIG as staticlib or sharedlib and PROJECTDEPLOYDIR MUST BE DEFINED BEFORE templatelibbundle.pri inclusion
include ($${QMAKE_REMAKEN_RULES_ROOT}/templatelibconfig.pri)


DEFINES += BOOST_ALL_NO_LIB
DEFINES += BOOST_ALL_DYN_LINK

SOURCES += \
    %{CppFileName}

HEADERS += \
    %{ModuleName}API.h
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

INCLUDEPATH += $${PWD}

header_files.path = $${PROJECTDEPLOYDIR}/interfaces/
header_files.files = $$files($${PWD}/I*.h)

INSTALLS += header_files
DISTFILES += \
    Makefile

OTHER_FILES += \
    packagedependencies.txt

with_qtvs {
#NOTE : Must be placed at the end of the .pro
@if '%{remakenRules}' === 'local'
    include (builddefs/qmake/remaken_install_target.pri)
@else
    include ($${QMAKE_REMAKEN_RULES_ROOT}/remaken_install_target.pri)
@endif
}
