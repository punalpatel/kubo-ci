#!/usr/bin/env bash

[ -z "$DEBUG" ] || set -x

set -eu
set -o pipefail

source "$PWD/git-kubo-ci/scripts/lib/environment.sh"

GIT_KUBO_CI=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)
export BOSH_LOG_LEVEL=debug
export BOSH_LOG_PATH="$PWD"/bosh.log
export GOPATH="$GIT_KUBO_CI"
export DEPLOYMENT_NAME=${DEPLOYMENT_NAME:="ci-service"}

iaas=$(bosh-cli int "$PWD/kubo-lock/metadata" --path="/iaas")
routing_mode=$(bosh-cli int "$PWD/kubo-lock/metadata" --path="/routing_mode")
director_name=$(bosh-cli int "$PWD/kubo-lock/metadata" --path="/director_name")

credHub_login() {
    local director_name credhub_user_password credhub_api_url
    director_name=$(bosh-cli int "${KUBO_ENVIRONMENT_DIR}/director.yml" --path="/director_name")
    credhub_user_password=$(bosh-cli int "${KUBO_ENVIRONMENT_DIR}/creds.yml" --path="/credhub_cli_password")
    credhub_api_url="https://$(bosh-cli int "${KUBO_ENVIRONMENT_DIR}/director.yml" --path="/internal_ip"):8844"

    tmp_uaa_ca_file="$(mktemp)"
    bosh-cli int "${KUBO_ENVIRONMENT_DIR}/creds.yml" --path="/uaa_ssl/ca" > "${tmp_uaa_ca_file}"
    tmp_credhub_ca_file="$(mktemp)"
    bosh-cli int "${KUBO_ENVIRONMENT_DIR}/creds.yml" --path="/credhub_tls/ca" > "${tmp_credhub_ca_file}"

    credhub login -u credhub-cli -p "${credhub_user_password}" -s "${credhub_api_url}" --ca-cert "${tmp_credhub_ca_file}" --ca-cert "${tmp_uaa_ca_file}"
}

setup_env_variables() {
  TLS_KUBERNETES_CERT=$(bosh-cli int <(credhub get -n "${director_name}/${DEPLOYMENT_NAME}/tls-kubernetes" --output-json) --path='/value/certificate')
  TLS_KUBERNETES_PRIVATE_KEY=$(bosh-cli int <(credhub get -n "${director_name}/${DEPLOYMENT_NAME}/tls-kubernetes" --output-json) --path='/value/private_key')
  export TLS_KUBERNETES_CERT TLS_KUBERNETES_PRIVATE_KEY
}

setup_env_dir() {
  cp "$PWD/gcs-bosh-creds/creds.yml" "${KUBO_ENVIRONMENT_DIR}/"
  cp "kubo-lock/metadata" "${KUBO_ENVIRONMENT_DIR}/director.yml"
  cp "git-kubo-ci/specs/guestbook.yml" "${KUBO_ENVIRONMENT_DIR}/addons.yml"
}

set_kubeconfig() {
  "$PWD/git-kubo-deployment/bin/set_kubeconfig" "${KUBO_ENVIRONMENT_DIR}" "${DEPLOYMENT_NAME}"
}

generate_testconfig() {
  "$GIT_KUBO_CI/scripts/generate-test-config.sh" "${KUBO_ENVIRONMENT_DIR}" "${DEPLOYMENT_NAME}"
}

main() {
  setup_env_dir
  credHub_login
  setup_env_variables
  set_kubeconfig
  generate_testconfig > "$PWD"/testconfig.json

  export CONFIG="$PWD"/testconfig.json

  if [[ ${routing_mode} == "cf" ]]; then
    ginkgo -progress -v "$GOPATH/src/tests/integration-tests/cloudfoundry"
  elif [[ ${routing_mode} == "iaas" ]]; then
    case "${iaas}" in
      aws)
        aws configure set aws_access_key_id "$(bosh-cli int "${KUBO_ENVIRONMENT_DIR}/director.yml" --path=/access_key_id)"
        aws configure set aws_secret_access_key  "$(bosh-cli int "${KUBO_ENVIRONMENT_DIR}/director.yml" --path=/secret_access_key)"
        aws configure set default.region "$(bosh-cli int "${KUBO_ENVIRONMENT_DIR}/director.yml" --path=/region)"
        AWS_INGRESS_GROUP_ID=$(bosh-cli int "${KUBO_ENVIRONMENT_DIR}/director.yml" --path=/default_security_groups/0)
        export AWS_INGRESS_GROUP_ID
        ;;
    esac
    ginkgo -progress -v "$GOPATH/src/tests/integration-tests/workload/k8s_lbs"
  fi
  ginkgo -progress -v "$GOPATH/src/tests/integration-tests/pod_logs"
  ginkgo -progress -v "$GOPATH/src/tests/integration-tests/generic"
  ginkgo -progress -v "$GOPATH/src/tests/integration-tests/oss_only"
  ginkgo -progress -v "$GOPATH/src/tests/integration-tests/api_extensions"
  if [[ "${iaas}" != "openstack" ]]; then
      ginkgo -progress -v "$GOPATH/src/tests/integration-tests/persistent_volume"
  fi
}

main
