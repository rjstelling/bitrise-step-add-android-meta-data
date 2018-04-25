#!/bin/bash

#set -ex

# Test for xmlstarlet
hash xmlstarlet 2>/dev/null || { echo >&2 "xmlstarlet required, but it's not installed."; exit 1; }

EXISTING_VALUE=$(xmlstarlet sel -t -v "//meta-data[@android:name='${metadata_name}']/@android:value" "${android_manifest_path}")

if [ ! -n "${EXISTING_VALUE}" ] # No Element, add it
then

echo
echo "Added <meta-data> to: ${android_manifest_path}"
echo "\tName: ${metadata_name}"
echo "\tValue: ${metadata_value}"
echo

# Add <metadata>
xmlstarlet ed --inplace \
	-s "/manifest/application" \
	-t elem \
	-n "meta-data" \
	-i "/manifest/application/meta-data[not(@android:name)]" \
	-t attr \
	-n "android:name" \
	-v "${metadata_name}" \
	-i "/manifest/application/meta-data[not(@android:value)]" \
	-t attr \
	-n "android:value" \
	-v "${metadata_value}" "${android_manifest_path}"

elif [ $EXISTING_VALUE != ${metadata_value} ] # Found element, update it
then

echo
echo "Updating <meta-data> at: ${android_manifest_path}"
echo "\tName: ${metadata_name}"
echo "\tValue: ${metadata_value}"
echo

xmlstarlet ed --inplace \
	-u "/manifest/application/meta-data[@android:name='${metadata_name}']/@android:value" \
	-v "${metadata_value}" "${android_manifest_path}"

else

echo "Element '${metadata_name}' does not need updating to '${metadata_value}'"

fi

