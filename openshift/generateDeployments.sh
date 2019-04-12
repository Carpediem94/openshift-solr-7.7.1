#!/bin/bash

USER_ID="$(id -u)"
SCRIPT_DIR=$(dirname $0)
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
TEMPLATE_DIR="${SCRIPT_DIR}/templates"

export MSYS_NO_PATHCONV=1
# ==============================================================================
# Script for setting up the deployment environment in OpenShift
# -----------------------------------------------------------------------------------
PROJECT_NAMESPACE="${1}"
DEPLOYMENT_ENV_NAME="${2}"
BUILD_ENV_NAME="${3}"
# -------------------------------------------------------------------------------------
DeploymentConfigPostfix="_DeploymentConfig.json"
SOLR_DEPLOYMENT_NAME="solr"
# ==============================================================================

echo "============================================================================="
echo "Switching to project ${PROJECT_NAMESPACE} ..."
echo "-----------------------------------------------------------------------------"
oc project ${PROJECT_NAMESPACE}
echo "============================================================================"
echo

echo "============================================================================="
echo "Deleting previous deployment configuration files ..."
echo "-----------------------------------------------------------------------------"
for file in *${DeploymentConfigPostfix}; do
	echo "Deleting ${file} ..."
	rm -rf ${file};
done
echo "============================================================================="
echo

echo "============================================================================="
echo "Generating deployment configuration for ${SOLR_DEPLOYMENT_NAME} ..."
echo "-----------------------------------------------------------------------------"
${SCRIPTS_DIR}/configureSolrDeployment.sh \
	${SOLR_DEPLOYMENT_NAME} \
	${DEPLOYMENT_ENV_NAME} \
	${BUILD_ENV_NAME} \
	"" \
	"${TEMPLATE_DIR}/${SOLR_DEPLOYMENT_NAME}-deploy.json"

echo "============================================================================="
echo

echo "============================================================================="
echo "Creating deployment configurations in OpenShift project; ${PROJECT_NAMESPACE} ..."
echo "-----------------------------------------------------------------------------"
for file in *${DeploymentConfigPostfix}; do
	echo "Loading ${file} ...";
	oc create -f ${file};
	echo;
done
echo "============================================================================="
echo
