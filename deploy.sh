#!/bin/bash

# ----------------------
# KUDU Deployment Script
# Version: 1.0.6
# ----------------------

# Helpers
# -------

exitWithMessageOnError () {
  if [ ! $? -eq 0 ]; then
    echo "An error has occurred during web site deployment."
    echo $1
    exit 1
  fi
}

# Prerequisites
# -------------

# Verify node.js installed
hash node 2>/dev/null
exitWithMessageOnError "Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment."

# Setup
# -----

SCRIPT_DIR="${BASH_SOURCE[0]%\\*}"
SCRIPT_DIR="${SCRIPT_DIR%/*}"
ARTIFACTS=$SCRIPT_DIR/../artifacts
KUDU_SYNC_CMD=${KUDU_SYNC_CMD//\"}

if [[ ! -n "$DEPLOYMENT_SOURCE" ]]; then
  DEPLOYMENT_SOURCE=$SCRIPT_DIR
fi

if [[ ! -n "$NEXT_MANIFEST_PATH" ]]; then
  NEXT_MANIFEST_PATH=$ARTIFACTS/manifest

  if [[ ! -n "$PREVIOUS_MANIFEST_PATH" ]]; then
    PREVIOUS_MANIFEST_PATH=$NEXT_MANIFEST_PATH
  fi
fi

if [[ ! -n "$DEPLOYMENT_TARGET" ]]; then
  DEPLOYMENT_TARGET=$ARTIFACTS/wwwroot
else
  KUDU_SERVICE=true
fi

if [[ ! -n "$KUDU_SYNC_CMD" ]]; then
  # Install kudu sync
  echo Installing Kudu Sync
  npm install kudusync -g --silent
  exitWithMessageOnError "npm failed"

  if [[ ! -n "$KUDU_SERVICE" ]]; then
    # In case we are running locally this is the correct location of kuduSync
    KUDU_SYNC_CMD=kuduSync
  else
    # In case we are running on kudu service this is the correct location of kuduSync
    KUDU_SYNC_CMD=$APPDATA/npm/node_modules/kuduSync/bin/kuduSync
  fi
fi

# Install JRuby
JRUBY_VERSION=9.1.5.0
JRUBY_DIR=jruby
JRUBY_HOME=$DEPLOYMENT_TARGET/$JRUBY_DIR/jruby-$JRUBY_VERSION
JRUBY_EXE=$JRUBY_HOME/bin/jruby.exe
JRUBY_GEM_CMD=$JRUBY_HOME/bin/gem
JRUBY_BUNDLER_CMD=$JRUBY_HOME/bin/bundle

export JAVA_OPTS=-Djava.net.preferIPv4Stack=true

if [[ ! -d "$JRUBY_HOME" ]]; then
  echo Installing JRuby $JRUBY_VERSION
  pushd $DEPLOYMENT_TARGET

  mkdir $JRUBY_DIR ; cd $JRUBY_DIR

  curl -LOs https://s3.amazonaws.com/jruby.org/downloads/$JRUBY_VERSION/jruby-bin-$JRUBY_VERSION.zip
  unzip -q jruby-bin-$JRUBY_VERSION.zip ; rm -f jruby-bin-$JRUBY_VERSION.zip

  popd
fi

if [[ ! -f "$JRUBY_BUNDLER_CMD" ]]; then
  echo Installing bundler

  $JRUBY_EXE -S $JRUBY_GEM_CMD install bundler --no-ri --no-rdoc
  exitWithMessageOnError "fail to install bundler"
fi

##################################################################################################################################
# Deployment
# ----------

echo Handling Basic Web Site deployment.

# 1. KuduSync
if [[ "$IN_PLACE_DEPLOYMENT" -ne "1" ]]; then
  "$KUDU_SYNC_CMD" -v 50 -f "$DEPLOYMENT_SOURCE" -t "$DEPLOYMENT_TARGET" -n "$NEXT_MANIFEST_PATH" -p "$PREVIOUS_MANIFEST_PATH" -i ".git;.hg;.deployment;deploy.sh"
  exitWithMessageOnError "Kudu Sync failed"
fi

# 2. Exec Bundler
if [[ -f "$DEPLOYMENT_TARGET\Gemfile.lock" ]]; then
  echo Executing bundle install

  pushd "$DEPLOYMENT_TARGET"

  $JRUBY_EXE -S "$JRUBY_BUNDLER_CMD" install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin -j4
  exitWithMessageOnError "Bundle install failed"

  popd
fi

# 3. rake db:migrate
echo DB migration

pushd "$DEPLOYMENT_TARGET"

#$JRUBY_EXE -S vendor/bundle/bin/rake db:migrate RAILS_ENV=production

#exitWithMessageOnError "DB Migration failed"

#$JRUBY_EXE -S vendor/bundle/bin/rake db:seed RAILS_ENV=production

#exitWithMessageOnError "DB Migration failed"

popd
##################################################################################################################################

# Post deployment stub
if [[ -n "$POST_DEPLOYMENT_ACTION" ]]; then
  POST_DEPLOYMENT_ACTION=${POST_DEPLOYMENT_ACTION//\"}
  cd "${POST_DEPLOYMENT_ACTION_DIR%\\*}"
  "$POST_DEPLOYMENT_ACTION"
  exitWithMessageOnError "post deployment action failed"
fi

echo "Finished successfully."
