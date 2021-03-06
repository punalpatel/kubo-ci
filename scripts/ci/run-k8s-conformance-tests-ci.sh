#!/usr/bin/env bash

[ -z "$DEBUG" ] || set -x

set -eu
set -o pipefail


BASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"/../.. && pwd)

setup_env() {
  export GOPATH="$BASE_DIR"
  DEPLOYMENT_NAME=${DEPLOYMENT_NAME:="ci-service"}
  KUBO_ENVIRONMENT_DIR="${PWD}/environment"
  mkdir -p "${KUBO_ENVIRONMENT_DIR}"
  cp "$PWD/gcs-bosh-creds/creds.yml" "${KUBO_ENVIRONMENT_DIR}/"
  cp "$PWD/kubo-lock/metadata" "${KUBO_ENVIRONMENT_DIR}/director.yml"

  "$PWD/git-kubo-deployment/bin/set_bosh_alias" "${KUBO_ENVIRONMENT_DIR}"
  "$PWD/git-kubo-deployment/bin/set_kubeconfig" "${KUBO_ENVIRONMENT_DIR}" "${DEPLOYMENT_NAME}"
}

bosh_login() {

  export BOSH_CLIENT=admin
  export BOSH_CLIENT_SECRET=$(bosh-cli int $PWD/gcs-bosh-creds/creds.yml --path='/admin_password')
}

main() {
  setup_env
  bosh_login
  "$BASE_DIR/scripts/run-k8s-conformance-tests.sh" "${KUBO_ENVIRONMENT_DIR}" "${DEPLOYMENT_NAME}" "${PWD}/${CONFORMANCE_RESULTS_DIR}"
}

main "$@"
