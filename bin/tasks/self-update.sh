# Temp colors
export YELLOW=$(tput setaf 3)
export GREEN=$(tput setaf 2)
export RED=$(tput setaf 1)
export TXTRESET=$(tput sgr0)

# Check for symlink
echo "${YELLOW}Running self-updater...${TXTRESET}"

if [ $0 != '/usr/local/bin/createproject' ]; then
echo "${TXTRESET}${WHITE}Please do NOT run this script with ${RED}sh $CURRENTFILE${WHITE} or ${RED}bash $CURRENTFILE${WHITE} or ${RED}./$CURRENTFILE${WHITE}.
Run this script globally instead by simply typing: ${GREEN}createproject{TXTRESET}. If this doesn't work, please run first setup from the bin folder first."
echo ""
exit
fi

# Check for updates
# Get symlink path from /usr/local/bin/newtheme
SYMLINKPATH=$(sudo readlink /usr/local/bin/createproject)

# Get project bin folder directory from symlink path
PROJECTBINFOLDER=$(sudo dirname $SYMLINKPATH)

# Go one step back from bin to get theme root folder
PROJECTROOTFOLDER=$(sudo dirname $PROJECTBINFOLDER)

# Go to the theme root folder
cd $PROJECTROOTFOLDER

# Make sure no file mods are being committed
git config core.fileMode false --replace-all

# Check for updates
git pull origin master

# Ensure permissions are intact
sudo chmod +x /usr/local/bin/createproject

# If there is something preventing the update, show error message
if [ $? -ne 0 ]; then
echo ""
echo "${TXTRESET}${RED}There was an error updating the start script. You have probably made changes to the dudestack files? Please commit those changes, send a PR or stash them. Please check the error message above and try again.${TXTRESET}"
echo ""

# Stop script
exit 1

# If there are no errors, add line break
else
echo ""
fi
