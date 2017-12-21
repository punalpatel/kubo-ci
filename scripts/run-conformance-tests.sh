#!/usr/bin/env bash

[ -z "$DEBUG" ] || set -x

set -eu
set -o pipefail

source "$PWD/git-kubo-ci/scripts/lib/environment.sh"

GIT_KUBO_CI=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)
export GOPATH="$GIT_KUBO_CI"
export DEPLOYMENT_NAME=${DEPLOYMENT_NAME:="ci-service"}

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
  generate_testconfig > "$PWD"/testconfig.json

  export CONFIG="$PWD"/testconfig.json

  if [ -z ${CONFORMANCE_RESULTS_DIR+x} ]; then
    echo "Error: CONFORMANCE_RESULTS_DIR is not set, exiting..."
    exit 1
  fi

  export CONFORMANCE_RESULTS_DIR="$PWD/$CONFORMANCE_RESULTS_DIR"
  export RELEASE_TARBALL="$PWD/$KUBO_DEPLOYMENT_DIR/kubo-release.tgz"
  ginkgo -progress -v "$GOPATH/src/tests/conformance"
}

main
