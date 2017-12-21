#!/usr/bin/env bash

[ -z "$DEBUG" ] || set -x

set -eu

if [[ $# -lt 2 ]]; then
    echo "Usage:" >&2
    echo "$0 KUBO_ENVIRONMENT_DIR DEPLOYMENT_NAME" >&2
    exit 1
fi

KUBO_ENVIRONMENT_DIR="$1"
DEPLOYMENT_NAME="$2"

if [ ! -f "$KUBO_ENVIRONMENT_DIR"/director.yml ] || [ ! -f "$KUBO_ENVIRONMENT_DIR"/creds.yml ]; then
  echo "$KUBO_ENVIRONMENT_DIR must contain director.yml and creds.yml"
  exit 1
fi

generate_test_config() {
  local director_yml="$KUBO_ENVIRONMENT_DIR"/director.yml
  local creds_yml="$KUBO_ENVIRONMENT_DIR"/creds.yml

  config=$(cat <<EOF
{
  "bosh": {
     "iaas": "$(bosh int $director_yml --path=/iaas)",
     "environment": "$(bosh int $director_yml --path=/internal_ip)",
     "ca_cert": $(bosh int $creds_yml --path=/default_ca/ca --json | jq .Blocks[0]),
     "client": "bosh_admin",
     "client_secret": "$(bosh int $creds_yml --path=/bosh_admin_client_secret)",
     "deployment": "$DEPLOYMENT_NAME"
  },
  "turbulence": {
    "host": "$(bosh int $director_yml --path=/internal_ip)",
    "port": 8080,
    "username": "turbulence",
    "password": "$(bosh int $creds_yml --path=/turbulence_api_password 2>/dev/null)",
    "ca_cert": $(bosh int $creds_yml --path=/turbulence_api_ca/ca --json | jq .Blocks[0])
  },
  "cf": {
    "apps_domain": "$(bosh int $director_yml --path=/routing_cf_app_domain_name)"
  },
  "kubernetes": {
    "master_host": "$(bosh int $director_yml --path=/kubernetes_master_host)",
    "master_post": "$(bosh int $director_yml --path=/kubernetes_master_port)",
    "path_to_kube_config": "$HOME/.kube/config"
  }
}
EOF
  )
  echo "$config"
}

generate_test_config
