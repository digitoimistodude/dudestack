# Note about running directly as we can't prevent people running this via sh or bash pre-cmd
echo "-----------------------------------------------------"
echo "createproject start script ${SCRIPT_LABEL}, v${SCRIPT_VERSION}"
echo "-----------------------------------------------------"
echo ""
if [ $0 != '/usr/local/bin/createproject' ]; then
echo "${TXTBOLD}Please note: ${TXTRESET}${WHITE}Please do NOT prepend sh or bash to run this script. Run this script directly instead."
echo ""
echo "Wrong: ${RED}sh $CURRENTFILE${WHITE} or ${RED}bash $CURRENTFILE${WHITE}"
echo "Right: ${GREEN}./$CURRENTFILE${WHITE} (if no executable permissions, run ${GREEN}sudo chmod +x $CURRENTFILE first)${WHITE}" 1>&2
echo ""
fi
if [ ! -f /usr/local/bin/createproject ]; then
echo "${TXTRESET}${TXTBOLD}Preferred way to run:${TXTRESET}${WHITE} Link this file to system level with this command:${TXTRESET}"
echo ""
echo "${GREEN}sudo ln -s ${DIR_TO_FILE}${CURRENTFILE} /usr/local/bin/createproject${TXTRESET}" 1>&2
echo ""
echo "After this you can just run:"
echo "${GREEN}createproject${TXTRESET}"
echo ""
fi
