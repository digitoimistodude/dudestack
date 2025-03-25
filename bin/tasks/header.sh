# Note about running directly as we can't prevent people running this via sh or bash pre-cmd
if [ "$1" = "--existing" ]; then
  # Skip dirname/basename for --existing flag
  export DIR_TO_FILE=""
else
  # Only try to get directory for non-flag arguments
  export DIR_TO_FILE=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
fi

# Get dudestack version from composer.json in the dudestack root directory
DUDEDESTACK_VERSION=$(grep -m 1 '"version":' "${SCRIPTS_LOCATION}/../composer.json" | cut -d'"' -f4)

# Get version date from CHANGELOG.md in the dudestack root directory
DUDESTACK_DATE=$(grep '^### ' "${SCRIPTS_LOCATION}/../CHANGELOG.md" | head -n 1 | cut -d' ' -f3)

echo "---------------------------------------------------------"
echo "createproject start script ${SCRIPT_LABEL}, v${SCRIPT_VERSION}"
echo "dudestack v${DUDEDESTACK_VERSION} (${DUDESTACK_DATE})"
echo "---------------------------------------------------------"
echo ""

if [ ! -f /usr/local/bin/createproject ]; then
echo "${TXTRESET}${TXTBOLD}ACTION REQUIRED:${TXTRESET}${WHITE} Link this file to system level and start from there with this oneliner:${TXTRESET}"
echo ""
echo "${GREEN}sudo ln -s ${DIR_TO_FILE}${CURRENTFILE} /usr/local/bin/createproject && sudo chmod +x /usr/local/bin/createproject && createproject${TXTRESET}" 1>&2
echo ""
exit
fi
if [ $0 != '/usr/local/bin/createproject' ]; then
echo "${TXTRESET}${WHITE}Please do NOT run this script with ${RED}sh $CURRENTFILE${WHITE} or ${RED}bash $CURRENTFILE${WHITE} or ${RED}./$CURRENTFILE${WHITE}.
Run this script globally instead by simply typing: ${GREEN}createproject${TXTRESET}"
echo ""
exit
fi
