#!/bin/bash
SCRIPT_DIR=$(dirname $0)

# ===================================================================================================
# Funtions
# ---------------------------------------------------------------------------------------------------
exitOnError (){
  rtnCd=$?
  if [ ${rtnCd} -ne 0 ]; then
	echo "An error has occurred.!  Please check the previous output message(s) for details."
    exit ${rtnCd}
  fi
}

createProject (){
  namespace=$1
  display_name=$2
  description=$3
  
  oc new-project ${namespace} --display-name="${display_name}" --description="${description}"
}

projectExists (){
  project=$1
  rtnVal=$(oc projects | grep ${project})
  if [ -z "$rtnVal" ]; then
    # Project does not exist ..."
	return 1
  else
    # Project exists ..."
	return 0
  fi
}
# ===================================================================================================

# ===================================================================================================
# Setup

if ! projectExists ${PROJECT_NAMESPACE}; then
  createProject ${PROJECT_NAMESPACE} "${DISPLAY_NAME}" "${DESCRIPTION}"
  exitOnError
else
  echo "${PROJECT_NAMESPACE} exists ..."
fi
