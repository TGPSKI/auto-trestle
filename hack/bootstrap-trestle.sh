# bootstrap-trestle takes a interface directory and oscal revision as inputs,
# initalizes a trestle project, imports a control catalog, imports a control profile,
# and generates a markdown directroy to house response content.

# Usage: ./bootstrap-trestle.sh <interface directory> <oscal revision>

# Example: ./bootstrap-trestle.sh ./fixtures/interface rev4

# This script is intended to be run from the root of the trestle project.

if [ -z "$1" ]
then
  echo "No interface directory supplied"
  exit 1
fi

if [ -z "$2" ]
then
  echo "No oscal revision supplied"
  exit 1
fi

INTERFACE_DIR=$1
OSCAL_REVISION=$2

ROOT_PATH=$(pwd)
OSCAL_CONTROLS_PATH=$ROOT_PATH/fixtures/oscal/$2

CONTROL_FILETYPE=json
CONTROL_LEVEL=HIGH
CONTROL_BASELINE_CATALOG_FILENAME=FedRAMP_${OSCAL_REVISION}_${CONTROL_LEVEL}-baseline-resolved-profile_catalog.${CONTROL_FILETYPE}
CONTROL_BASELINE_PROFILE_FILENAME=FedRAMP_${OSCAL_REVISION}_${CONTROL_LEVEL}-baseline_profile.${CONTROL_FILETYPE}
CONTROL_PATH_PREFIX=baselines/${CONTROL_FILETYPE}
CONTROL_SHORTNAME=FedRAMP-${CONTROL_LEVEL}-${OSCAL_REVISION}


# Initialize trestle project
# make sure $1 directory exists, if not make it, and then change into it
mkdir -p $1
cd $1
trestle init

# Import control catalog
trestle import -f $OSCAL_CONTROLS_PATH/$CONTROL_PATH_PREFIX/$CONTROL_BASELINE_CATALOG_FILENAME -o ${CONTROL_SHORTNAME}

# Import control profile
trestle import -f $OSCAL_CONTROLS_PATH/$CONTROL_PATH_PREFIX/$CONTROL_BASELINE_PROFILE_FILENAME -o ${CONTROL_SHORTNAME}

# Generate markdown directory
mkdir -p markdown
trestle author ssp-generate -p ${CONTROL_SHORTNAME} -o markdown
