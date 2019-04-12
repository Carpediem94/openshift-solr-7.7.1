#!/bin/bash
SCRIPT_DIR=$(dirname $0)
export MSYS_NO_PATHCONV=1

# ===================================================================================================
# Funtions
# ---------------------------------------------------------------------------------------------------
usage (){
  echo "========================================================================================"
  echo "Creates a Solr test project in OpenShift"
  echo "----------------------------------------------------------------------------------------"
  echo "Usage:"
  echo
  echo "${0} -c <project_name> <git_ref> <git_uri>"
	echo "emit -c to use an existing project"
	echo
	echo "Optional:"
	echo " - c : create new project"
	echo " - h : usage"
  echo
  echo "Where:"
  echo " - <project_name> is the name of the openshift project."
  echo " - <git_ref> is GitHub ref to use."
  echo " - <git_uri> is the GitHub repo to use."
  echo
  echo "Examples:"
  echo "${0} -c solr master https://github.com/Carpediem94/openshift-solr-7.7.1.git"
  echo "========================================================================================"
  exit 1
}

exitOnError (){
  rtnCd=$?
  if [ ${rtnCd} -ne 0 ]; then
	echo "An error has occurred.!  Please check the previous output message(s) for details."
    exit ${rtnCd}
  fi
}

isLocalCluster (){
  rtnVal=$(oc project | grep //10.0)
  if [ -z "$rtnVal" ]; then
    # Not a local cluster ..."
	return 1
  else
    # Is a local cluster ..."
	return 0
  fi
}

isMinishiftRun (){
	rtnVal=$(minishift status | grep "Running")
	echo $rtnVal
	if [ -z "$rtnVal" ]; then
		# No Minishift instance is running ...		
	return 1
	else
		# Minishift instance is running ...
	return 0
	fi
}

projectNotExists (){
  project=$1
  rtnVal=$(oc projects | grep ${project})
  if [ -z "$rtnVal" ]; then
    # Project does not exist ..."
	return 0
  else
    # Project exists ..."
	return 1
  fi
}

# ===================================================================================================

# ===================================================================================================
# Setup
# ---------------------------------------------------------------------------------------------------
while getopts ":c:h" opt; do
  case $opt in
    c)
      CREATE=0
			shift $(($OPTIND - 2))
      ;;
		h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done

if [ ! -z "${1}" ]; then
  PROJECT_NAMESPACE=$1
fi

if [ ! -z "${2}" ]; then
  GIT_REF=$2
fi

if [ ! -z "${3}" ]; then
  GIT_URI=$3
fi

if [ -z "$PROJECT_NAMESPACE" ]; then
	echo "Enter PROJECT NAME"
	echo -n "Please enter the name of the tools project; for example 'project-tools': "
	read PROJECT_NAMESPACE
	PROJECT_NAMESPACE="$(echo "${PROJECT_NAMESPACE}" | tr '[:upper:]' '[:lower:]')"
	echo
fi

if [ -z "$GIT_REF" ]; then
	echo "Enter GIT REF"
	echo -n "Please enter the name of the github reference; for example 'master': "
	read GIT_REF
	echo
fi

if [ -z "$GIT_URI" ]; then
	echo "Enter GIT URI"
	echo -n "Please enter the name of the github reference; for example 'https://github.com/bcgov/TheOrgBook.git': "
	read GIT_URI
	echo
fi
# ===================================================================================================
if isMinishiftRun; then
   echo "Run script on minishift..."
elif isLocalCluster; then
  echo "Run script in local cluster..."
else
	echo "No minishift or local cluster found!"
  exit 1
fi

if [ ! -z $CREATE ]; then
	./createLocalProject.sh ${PROJECT_NAMESPACE} "Solr" "Solr Test Project"
fi

./generateBuilds.sh ${PROJECT_NAMESPACE} ${GIT_REF} ${GIT_URI}
exitOnError

./generateDeployments.sh ${PROJECT_NAMESPACE} latest ${PROJECT_NAMESPACE}
exitOnError
