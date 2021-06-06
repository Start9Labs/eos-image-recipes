#!/bin/sh
set -e

echo "==== PureOS Image Build ===="

if [ -z "$IB_ENVIRONMENT" ]; then
  IB_ENVIRONMENT="gnome"
  echo "Building for default OS environment: $IB_ENVIRONMENT"
else
  echo "Building for environment: $IB_ENVIRONMENT"
fi

if [ -z "$IB_SUITE" ]; then
  IB_SUITE="byzantium"
  echo "Building for default suite: $IB_SUITE"
else
  echo "Building for suite: $IB_SUITE"
fi

if [ -z "$IB_TARGET_ARCH" ]; then
  IB_TARGET_ARCH="amd64"
  echo "Building for default architecture: $IB_TARGET_ARCH"
else
  echo "Building for architecture: $IB_TARGET_ARCH"
fi

if [ -z "$IB_IMAGE_STYLE" ]; then
  IB_IMAGE_STYLE="live"
  echo "Building default image variant: $IB_IMAGE_STYLE"
else
  echo "Building image variant: $IB_IMAGE_STYLE"
fi

if [ -z "$container" ]; then
  RESULTS_DIR="/srv/artifacts"
else
  RESULTS_DIR="$(dirname "$(readlink -f "$0")")/results"
fi
  echo "Saving results in: $RESULTS_DIR"

CURRENT_DATE=$(date +%Y%m%d)

case "$IB_SUITE" in
  byzantium)
    dist_version="10"
    dist_reltag="~devel"
  ;;
  amber)
    dist_version="9.0"
  ;;
  *)
    echo "WARNING: Suite $SUITE is unknown" >&2
    dist_version="0.0"
  ;;
esac
VERSION_FULL="${dist_version}${dist_reltag}"

IMAGE_BASENAME=pureos-${VERSION_FULL}-${IB_ENVIRONMENT}-${IB_IMAGE_STYLE}-${CURRENT_DATE}_${IB_TARGET_ARCH}

rm -rf ./disk-ws-tmp/
echo ""
exec debos \
        -b kvm \
	-m4G \
	-c4 \
	--scratchsize=8G \
	pureos-isohybrid.yaml \
	-t arch:"${IB_TARGET_ARCH}" \
	-t suite:"${IB_SUITE}" \
	-t version:"${VERSION_FULL}" \
	-t environment:"${IB_ENVIRONMENT}" \
	-t imagestyle:"${IB_IMAGE_STYLE}" \
	-t image:"$IMAGE_BASENAME" \
	-t results_dir:"$RESULTS_DIR"
