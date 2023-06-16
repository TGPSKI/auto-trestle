# This script is used to update the OSCAL content in the fixtures directory.
#
# bootstrap-fixtures-oscal.sh takes in a revision string, clones the OSCAL content repository from https://github.com/GSA/fedramp-automation, and copies the content
# of the revision string into the fixtures directory.
# Usage: ./hack/bootstrap-fixtures-oscal.sh <revision string> <repo url> <repo content dir>
# Example: ./hack/bootstrap-fixtures-oscal.sh rev4 "https://github.com/GSA/fedramp-automation" "dist/content"

set -e

if [ -z "$1" ]; then
    echo "Usage: ./hack/bootstrap-fixtures-oscal.sh <revision string> <repo url> <repo content dir>"
    echo "Example: ./hack/bootstrap-fixtures-oscal.sh rev4 https://github.com/GSA/fedramp-automation dist/content"
    exit 1
fi

REVISION=$1
REPO_URL=$2
REPO_CONTENT_DIR=$3

# Clone the OSCAL content repository into a temporary directory
TMP_DIR=$(mktemp -d)
git clone $REPO_URL $TMP_DIR

# Copy the content of the revision string into the fixtures directory
mkdir -p ./fixtures/oscal/$REVISION
cp -r $TMP_DIR/$REPO_CONTENT_DIR/$REVISION/* ./fixtures/oscal/$REVISION

# Remove the temporary directory
rm -rf $TMP_DIR
