#!/usr/bin/env bash
set -ev
helm push $(ls *.tgz) oci://ghcr.io/${GITHUB_REPOSITORY_OWNER}/charts

unset GITHUB_TOKEN
export GH_TOKEN=$SEGWAY_CHARTS_WRITE

gh auth setup-git
pushd /tmp
gh repo clone ${GITHUB_REPOSITORY_OWNER}/${SEGWAY_CHARTS_REPO}
popd
helm repo index . --url https://github.com/${GITHUB_REPOSITORY_OWNER}/${GITHUB_REPOSITORY#*/}/releases/download/v$1 --merge /tmp/${SEGWAY_CHARTS_REPO}/index.yaml
cp index.yaml /tmp/${SEGWAY_CHARTS_REPO}/index.yaml
pushd /tmp/${SEGWAY_CHARTS_REPO}
git add index.yaml
git commit -am "chore(helm): Publish $1"
git push
