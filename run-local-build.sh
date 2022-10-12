#!/bin/bash
set -e

#
# This script can be used to safely build an image locally,
# without the Laniakea Spark runner, but in the exact same
# environment as if it was executed on the PureOS' build
# infrastructure.
#

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --dsname)
      DSNAME="$2"
      shift
      shift
      ;;
    --no-fakemachine)
      NO_FAKEMACHINE="1"
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z "$1" ]; then
	echo "usage: $0 SUITE [ENVIRONMENT] [IMAGE-STYLE] [ARCH]"
	exit 1
fi

BASEDIR=$(dirname "$(readlink -f "$0")")
SUITE="$1"
ENVNAME="$2"
STYLE="$3"
ARCH="$4"
LITE="$5"

if [ -z "$DSNAME" ]; then
	DSNAME="$SUITE"
fi

imgbuild_fname="$(mktemp /tmp/exec-mkimage.XXXXXX)"
cat > $imgbuild_fname <<END
#!/bin/sh

export IB_ENVIRONMENT=${ENVNAME}
export IB_LITE=${LITE}
export IB_SUITE=${SUITE}
export IB_TARGET_ARCH=${ARCH}
export IB_IMAGE_STYLE=${STYLE}
export IB_NO_FAKEMACHINE=${NO_FAKEMACHINE}
exec ./build.sh
END

boot_flag=""
if [ "$NO_FAKEMACHINE" = "1" ]; then
  boot_flag="--boot"
fi

mkdir -p ${BASEDIR}/results
set +e
debspawn run \
	-x \
	--arch=amd64 \
	${boot_flag} \
	--allow=kvm,read-kmods \
	--cachekey="${SUITE}-mkimage" \
	--init-command="${BASEDIR}/prepare.sh" \
	--build-dir=${BASEDIR} \
	--artifacts-out=${BASEDIR}/results \
	--header="PureOS Image Build (for ${SUITE})" \
	--suite=${SUITE} \
	${DSNAME} \
	${imgbuild_fname}

# cleanup
retval=$?
rm $imgbuild_fname
if [ $retval -ne 0 ]; then
    exit $retval
fi
exit 0
