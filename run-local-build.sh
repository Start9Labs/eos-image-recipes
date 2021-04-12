#!/bin/sh
set -e

#
# This script can be used to safely build an image locally,
# without the Laniakea Spark runner, but in the exact same
# environment as if it was executed on the PureOS' build
# infrastructure.
#

if [ -z "$1" ]; then
	echo "usage: $0 SUITE [ENVIRONMENT] [IMAGE-STYLE] [ARCH]"
	exit 1
fi

BASEDIR=$(dirname "$(readlink -f "$0")")
SUITE="$1"
ENVNAME="$2"
STYLE="$3"
ARCH="$4"

imgbuild_fname="$(mktemp /tmp/exec-mkimage.XXXXXX)"
cat > $imgbuild_fname <<END
#!/bin/sh

export IB_ENVIRONMENT=${ENVNAME}
export IB_SUITE=${SUITE}
export IB_TARGET_ARCH=${ARCH}
export IB_IMAGE_STYLE=${STYLE}
exec ./build.sh
END

mkdir -p ${BASEDIR}/results
set +e
debspawn run \
	-x \
	--arch=amd64 \
	--allow=kvm \
	--cachekey="${SUITE}-mkimage" \
	--init-command="${BASEDIR}/prepare.sh" \
	--build-dir=${BASEDIR} \
	--artifacts-out=${BASEDIR}/results \
	--header="PureOS Image Build (for ${SUITE})" \
	${SUITE} \
	${imgbuild_fname}

# cleanup
retval=$?
rm $imgbuild_fname
if [ $retval -ne 0 ]; then
    exit $retval
fi
exit 0
