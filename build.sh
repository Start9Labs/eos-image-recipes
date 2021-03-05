#!/bin/sh
set -e

echo "==== PureOS Image Build ===="

if [ -z "$FLAVOR" ]; then
  FLAVOR="gnome-live"
  echo "Using default flavor: $FLAVOR"
else
  echo "Using flavor: $FLAVOR"
fi

if [ -z "$SUITE" ]; then
  SUITE="byzantium"
  echo "Using default suite: $SUITE"
else
  echo "Using suite: $SUITE"
fi

if [ -z "$ARCH" ]; then
  ARCH="amd64"
  echo "Using default architecture: $ARCH"
else
  echo "Using architecture: $ARCH"
fi

OS_FLAVOR=$(echo $FLAVOR | cut -f1 -d-)
IMAGE_FLAVOR=${FLAVOR#*-}
if [ "$IMAGE_FLAVOR" = "$FLAVOR" ]; then
  IMAGE_FLAVOR="live"
  echo "Using default image type: $IMAGE_FLAVOR"
else
  echo "Using image type: $IMAGE_FLAVOR"
fi

CURRENT_DATE=$(date +%Y%m%d)

case "$SUITE" in
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

IMAGE_FILENAME=pureos-${VERSION_FULL}-${FLAVOR}-${CURRENT_DATE}_${ARCH}.iso

rm -rf ./disk-ws-tmp/
echo ""
exec debos \
	-m4G \
	-c4 \
	--scratchsize=8G \
	pureos-isohybrid.yaml \
	-t arch:"$ARCH" \
	-t suite:"$SUITE" \
	-t version:"$VERSION_FULL" \
	-t osflavor:"$OS_FLAVOR" \
	-t imageflavor:"$IMAGE_FLAVOR" \
	-t image:"$IMAGE_FILENAME"
