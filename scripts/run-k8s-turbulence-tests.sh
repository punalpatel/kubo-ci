#!/usr/bin/env bash

[ -z "$DEBUG" ] || set -x

set -eu
set -o pipefail

gcloud auth activate-service-account --key-file=<(bosh-cli int "$PWD/kubo-lock/metadata" --path='/gcp_service_account')
gcloud config set project "$(bosh-cli int "$PWD/kubo-lock/metadata" --path=/project_id)"
gcloud config set compute/zone "$(bosh-cli int "$PWD/kubo-lock/metadata" --path='/zone')"

. "$PWD/git-kubo-ci/scripts/lib/environment.sh"

cp "$PWD/gcs-bosh-creds/creds.yml" "${KUBO_ENVIRONMENT_DIR}/"
cp "kubo-lock/metadata" "${KUBO_ENVIRONMENT_DIR}/director.yml"

"$PWD/git-kubo-deployment/bin/set_kubeconfig" "${KUBO_ENVIRONMENT_DIR}" "ci-service"
export PATH_TO_KUBECONFIG="$HOME/.kube/config"

BOSH_ENVIRONMENT=$(bosh-cli int "$PWD/kubo-lock/metadata" --path='/internal_ip')
BOSH_CA_CERT=$(bosh-cli int "$PWD/gcs-bosh-creds/creds.yml" --path='/default_ca/ca')
BOSH_CLIENT=bosh_admin
BOSH_CLIENT_SECRET=$(bosh-cli int "$PWD/gcs-bosh-creds/creds.yml" --path='/bosh_admin_client_secret')

TURBULENCE_HOST=${BOSH_ENVIRONMENT}
TURBULENCE_PORT=8080
TURBULENCE_USERNAME=turbulence
TURBULENCE_PASSWORD=$(bosh-cli int "$PWD/gcs-bosh-creds/creds.yml" --path='/turbulence_api_password')
TURBULENCE_CA_CERT=$(bosh-cli int "$PWD/gcs-bosh-creds/creds.yml" --path /turbulence_api_ca/ca)
TURBULENCE_IAAS=$(bosh-cli int "$PWD/kubo-lock/metadata" --path='/iaas')

GIT_KUBO_CI=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)
GOPATH="$GIT_KUBO_CI"
export GOPATH


export TURBULENCE_USERNAME
export TURBULENCE_PASSWORD
export TURBULENCE_HOST
export TURBULENCE_PORT
export TURBULENCE_CA_CERT
export TURBULENCE_IAAS

export BOSH_ENVIRONMENT
export BOSH_CA_CERT
export BOSH_CLIENT
export BOSH_CLIENT_SECRET
ginkgo "$GOPATH/src/turbulence-tests/worker_failure" -progress -v