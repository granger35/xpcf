#!/bin/bash
QTVERSION=6.4.2
XPCFROOT=../..

# default linux values
QMAKEPATH=$HOME/Qt/${QTVERSION}/gcc_64/bin
if [[ "$OSTYPE" == "darwin"* ]]; then
	# overload for mac values
	QMAKE_PATH=/Application/Qt/${QTVERSION}/clang_64/bin
fi

display_usage() { 
	echo "This script builds xpcf and xpcfSampleComponent in shared and static mode with a special deployment option for packaging."
	echo "It also compress the various xpcf packages." 
    echo "It can receive three optional arguments." 
	echo -e "\nUsage: \$0 [path to qmake] [path to xpcf project root | default='${XPCFROOT}'] [Qt kit version to use | default='${QTVERSION}'] [path to qmake | default='${QMAKEPATH}'] \n" 
} 

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
    display_usage
    exit 0
fi 

if [ $# -ge 1 ]; then
	XPCFROOT=$1
fi
if [ $# -ge 2 ]; then
	QTVERSION=$2

	QMAKEPATH=$HOME/Qt/${QTVERSION}/gcc_64/bin
	if [[ "$OSTYPE" == "darwin"* ]]; then
		# overload for mac values
		QMAKE_PATH=/Application/Qt/${QTVERSION}/clang_64/bin
	fi
fi
if [ $# -eq 3 ]; then
	QMAKEPATH=$3
fi

${XPCFROOT}/scripts/unixes/build_remaken_project_package.sh xpcf shared ${XPCFROOT} ${QTVERSION} ${QMAKEPATH}
${XPCFROOT}/scripts/unixes/build_remaken_project_package.sh xpcf static ${XPCFROOT} ${QTVERSION} ${QMAKEPATH}
${XPCFROOT}/scripts/unixes/build_remaken_project_package.sh xpcfSampleComponent shared ${XPCFROOT}/samples/sample_component ${QTVERSION} ${QMAKEPATH}

${XPCFROOT}/scripts/unixes/make_remaken_package.sh xpcf 2.6.3
${XPCFROOT}/scripts/unixes/make_remaken_package.sh xpcfSampleComponent 2.6.3
