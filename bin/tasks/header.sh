# Note about running directly as we can't prevent people running this via sh or bash pre-cmd
echo "-----------------------------------------------------"
echo "createproject start script ${SCRIPT_LABEL}, v${SCRIPT_VERSION}"
echo "-----------------------------------------------------"
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
