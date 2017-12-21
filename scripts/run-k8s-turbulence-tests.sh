#!/usr/bin/env bash

[ -z "$DEBUG" ] || set -x

set -eu
set -o pipefail

source "$PWD/git-kubo-ci/scripts/lib/environment.sh"

GIT_KUBO_CI=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)
export GOPATH="$GIT_KUBO_CI"
export DEPLOYMENT_NAME=${DEPLOYMENT_NAME:="ci-service"}

iaas=$(bosh-cli int "$PWD/kubo-lock/metadata" --path='/iaas')

setup_env_dir() {
  cp "$PWD/gcs-bosh-creds/creds.yml" "${KUBO_ENVIRONMENT_DIR}/"
  cp "kubo-lock/metadata" "${KUBO_ENVIRONMENT_DIR}/director.yml"
}

set_kubeconfig() {
  "$PWD/git-kubo-deployment/bin/set_kubeconfig" "${KUBO_ENVIRONMENT_DIR}" "${DEPLOYMENT_NAME}"
}

generate_testconfig() {
  "$GIT_KUBO_CI/scripts/generate-test-config.sh" "${KUBO_ENVIRONMENT_DIR}" "${DEPLOYMENT_NAME}"
}

main() {
  setup_env_dir
  set_kubeconfig
  generate_testconfig > testconfig.json

  export CONFIG=testconfig.json

  ginkgo -progress -v "$GOPATH/src/tests/turbulence-tests/worker_failure"
  ginkgo -progress -v "$GOPATH/src/tests/turbulence-tests/master_failure"
  if [[ "${iaas}" == "gcp" || "${iaas}" == "aws" || "${iaas}" == "vsphere" ]]; then
    ginkgo -progress -v "$GOPATH/src/tests/turbulence-tests/persistence_failure"
  fi
}

main
