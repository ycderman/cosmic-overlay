#!/usr/bin/env bash
# Build one atom from this overlay inside a Gentoo stage3 (systemd) container.
set -euo pipefail
atom=$1
mkdir -p out
docker create -v /var/db/repos/gentoo --name portage docker.io/gentoo/portage:latest /bin/true >/dev/null
docker run --rm --volumes-from portage \
	-v "$PWD:/var/db/repos/depos-cosmic:ro" \
	-v "$PWD/out:/out" \
	docker.io/gentoo/stage3:systemd \
	bash /var/db/repos/depos-cosmic/scripts/ci-inner.sh "$atom"
