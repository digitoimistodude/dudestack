# Configure husky pre-commit hooks (DEV-742, DEV-1254)
# Runs after the GitHub repository exists, since setup.js needs a git repo.
#
# This task never exits. It is sourced, so an exit here would kill the whole
# createproject run and leave the project half built. Problems are reported
# loudly with a copy-pasteable fix instead.

PROJECT_ROOT="$PROJECTS_HOME/$PROJECTNAME"
THEME_DIR="$PROJECT_ROOT/content/themes/$PROJECTNAME"
CQC_PACKAGE='@digitoimistodude/code-quality-checks'
HOOKS_OK=false

echo "${YELLOW}Configuring pre-commit hooks...${TXTRESET}"

# Load nvm so npm and node are on PATH
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
fi

if ! command -v node > /dev/null 2>&1; then
  echo "${RED}Node is not available, skipping pre-commit hooks.${TXTRESET}"
elif [ ! -d "$PROJECT_ROOT/.git" ]; then
  echo "${RED}${PROJECT_ROOT} is not a git repository yet, skipping pre-commit hooks.${TXTRESET}"
else

  # Look for an existing copy of the hooks package, theme first, then project
  # root, then whatever is installed globally
  CQC_DIR=''
  for CANDIDATE in \
    "$THEME_DIR/node_modules/$CQC_PACKAGE" \
    "$PROJECT_ROOT/node_modules/$CQC_PACKAGE" \
    "$( npm root -g 2> /dev/null )/$CQC_PACKAGE"; do
    if [ -d "$CANDIDATE" ]; then
      CQC_DIR="$CANDIDATE"
      break
    fi
  done

  # Nothing installed yet, so install it. Theme is preferred when there is one,
  # otherwise keep it global so hooks work before the theme exists
  if [ -z "$CQC_DIR" ]; then
    if [ -f "$THEME_DIR/package.json" ]; then
      echo "${YELLOW}Installing hooks package into theme...${TXTRESET}"
      ( cd "$THEME_DIR" && npm install )
      CQC_DIR="$THEME_DIR/node_modules/$CQC_PACKAGE"
    else
      echo "${YELLOW}No theme yet, installing hooks package globally...${TXTRESET}"
      npm install -g "$CQC_PACKAGE"
      CQC_DIR="$( npm root -g 2> /dev/null )/$CQC_PACKAGE"
    fi
  fi

  # setup.js resolves the git root itself, so run it from inside the project
  if [ -f "$CQC_DIR/bin/setup.js" ]; then
    ( cd "$PROJECT_ROOT" && node "$CQC_DIR/bin/setup.js" )
  else
    ( cd "$PROJECT_ROOT" && git config core.hooksPath "$CQC_DIR/.husky/_" )
  fi

  # Verify rather than trust, so a broken install cannot pass as done
  HOOKS_PATH=$( cd "$PROJECT_ROOT" && git config --get core.hooksPath )

  if [ -n "$HOOKS_PATH" ] && [ -d "$HOOKS_PATH" ]; then
    HOOKS_OK=true
  fi
fi

if [ "$HOOKS_OK" = true ]; then
  echo "${GREEN}Pre-commit hooks configured at ${HOOKS_PATH}${TXTRESET}"
else
  echo ""
  echo "${RED}Pre-commit hooks were NOT configured.${TXTRESET}"
  echo "${YELLOW}The project is otherwise fine. Set the hooks up before you start work:${TXTRESET}"
  echo "${BLUE}  npm install -g ${CQC_PACKAGE}${TXTRESET}"
  echo "${BLUE}  cd ${PROJECT_ROOT} && node \$( npm root -g )/${CQC_PACKAGE}/bin/setup.js${TXTRESET}"
  echo ""
fi
