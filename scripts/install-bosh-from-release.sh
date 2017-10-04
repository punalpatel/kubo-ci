#!/bin/bash

set -exu -o pipefail

tar zvxf ghr-kubo-deployment/v0.6.0.tar.gz --directory .
mv kubo-deployment-0.6.0 git-kubo-deployment
git-kubo-ci/scripts/install-bosh.sh