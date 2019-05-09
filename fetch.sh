#!/usr/bin/env bash

#-------------------------------------------------------------------------------
# ============LICENSE_START=======================================================
#  Copyright (C) 2018 Sven van der Meer. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# SPDX-License-Identifier: Apache-2.0
# ============LICENSE_END=========================================================
#-------------------------------------------------------------------------------

##
## Build script for the VDMEER.GITHUB.IO
## - fetches built sites
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar


help(){ 
    printf "\nusage: fetch [options]\n"
    printf "\n  options:"
    printf "\n    -h | --help         - print this help screen and exit"
    printf "\n    -n | --no-dry-run   - run rsync without dry run option"
    printf "\n    -v | --verbose      - run rsync in verbose mode"
    printf "\n"
    printf "\nThe default is to run rsync in dry run mode."
    printf "\n\n"
}

DRY_RUN="--dry-run"
VERBOSE=

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help)
            help
            exit
            ;;
        -n | --no-dry-run)
           DRY_RUN=
            shift
            ;;
        -v | --verbose)
           VERBOSE="--verbose"
            shift
            ;;
        *)
            printf "\nunknown option '$1'\n\n"
            help
            exit 2
            ;;
    esac
done

if [[ -d "../skb/sites/vandermeer/target/site-vandermeer" ]]; then
    printf "\nfetching site-vandermeer\n"
    SITE_DIR="../skb/sites/vandermeer/target/site-vandermeer/"
    TARGET_DIR="./"
    if [[ "${SITE_DIR}/index.html" -nt "${TARGET_DIR}index.html" ]]; then
        printf "  -> newer build found\n"
        rsync ${DRY_RUN} --archive ${VERBOSE} --compress --delete --exclude '.git' --exclude 'fetch.sh' --exclude 'README.asciidoc' --exclude 'skb' ${SITE_DIR} ${TARGET_DIR}
    else
        printf "  -> is current\n"
    fi
else
    printf "\nsite-vandermeer not build\n"
fi

if [[ -d "../skb/sites/skb/target/site-skb" ]]; then
    printf "\nfetching site-skb\n"
    SITE_DIR="../skb/sites/skb/target/site-skb/"
    TARGET_DIR="./skb"
    if [[ "${SITE_DIR}/index.html" -nt "${TARGET_DIR}index.html" ]]; then
        printf "  -> newer build found\n"
        rsync ${DRY_RUN} --archive ${VERBOSE} --compress --delete --exclude 'framework' --exclude 'ipc' ${SITE_DIR} ${TARGET_DIR}
    else
        printf "  -> is current\n"
    fi
else
    printf "\nsite-skb not build\n"
fi

if [[ -d "../bash/framework/target/site-framework" ]]; then
    printf "\nfetching site-framework\n"
    SITE_DIR="../bash/framework/target/site-framework/"
    TARGET_DIR="./skb/framework"
    if [[ "${SITE_DIR}/index.html" -nt "${TARGET_DIR}index.html" ]]; then
        printf "  -> newer build found\n"
        rsync ${DRY_RUN} --archive ${VERBOSE} --compress --delete ${SITE_DIR} ${TARGET_DIR}
    else
        printf "  -> is current\n"
    fi
else
    printf "\nsite-framework not build\n"
fi

if [[ -d "../ipc/target/site-ipc" ]]; then
    printf "\nfetching site-ipc\n"
    SITE_DIR="../ipc/target/site-ipc/"
    TARGET_DIR="./skb/ipc"
    if [[ "${SITE_DIR}/index.html" -nt "${TARGET_DIR}index.html" ]]; then
        printf "  -> newer build found\n"
        rsync ${DRY_RUN} --archive ${VERBOSE} --compress --delete ${SITE_DIR} ${TARGET_DIR}
    else
        printf "  -> is current\n"
    fi
else
    printf "\nsite-ipc not build\n"
fi
