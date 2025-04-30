# Note about running directly as we can't prevent people running this via sh or bash pre-cmd
if [ "$1" = "--existing" ]; then
  # Skip dirname/basename for --existing flag
  export DIR_TO_FILE=""
else
  # Only try to get directory for non-flag arguments
  export DIR_TO_FILE=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
fi

# Get dudestack version from CHANGELOG.md first line, format: "### 1.2.3: YYYY-MM-DD"
DUDESTACK_VERSION=$(grep '^### ' "${SCRIPTS_LOCATION}/../CHANGELOG.md" | head -n 1 | cut -d' ' -f2 | tr -d ':')

# Get version date from CHANGELOG.md in the dudestack root directory
DUDESTACK_DATE=$(grep '^### ' "${SCRIPTS_LOCATION}/../CHANGELOG.md" | head -n 1 | cut -d' ' -f3)

# Source the logo
source "$SCRIPTS_LOCATION/tasks/logo.sh"

# Print the logo
print_logo

echo ""
echo "-----------------------------------------------------------------------"
echo "createproject start script ${SCRIPT_LABEL}, v${SCRIPT_VERSION}"
echo "dudestack v${DUDESTACK_VERSION} (${DUDESTACK_DATE})"
echo "-----------------------------------------------------------------------"
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
