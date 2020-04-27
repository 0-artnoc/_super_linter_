#!/bin/bash

################################################################################
################################################################################
########### Super-Linter (Lint all the code) @AdmiralAwkbar ####################
################################################################################
################################################################################

###########
# GLOBALS #
###########
# Default Vars
DEFAULT_RULES_LOCATION='/action/lib/.automation'                    # Default rules files location
LINTER_PATH='.github/linters'                                       # Default linter path
# YAML Vars
YAML_FILE_NAME='.yaml-lint.yml'                                     # Name of the file
YAML_LINTER_RULES="$DEFAULT_RULES_LOCATION/$YAML_FILE_NAME"         # Path to the yaml lint rules
# MD Vars
MD_FILE_NAME='.markdown-lint.yml'                                   # Name of the file
MD_LINTER_RULES="$DEFAULT_RULES_LOCATION/$MD_FILE_NAME"             # Path to the markdown lint rules
# Python Vars
PYTHON_FILE_NAME='.python-lint'                                     # Name of the file
PYTHON_LINTER_RULES="$DEFAULT_RULES_LOCATION/$PYTHON_FILE_NAME"     # Path to the python lint rules
# Ruby Vars
RUBY_FILE_NAME='.ruby-lint.yml'                                     # Name of the file
RUBY_LINTER_RULES="$DEFAULT_RULES_LOCATION/$RUBY_FILE_NAME"         # Path to the ruby lint rules
# Coffee Vars
COFFEE_FILE_NAME='.coffee-lint.json'                                  # Name of the file
COFFEESCRIPT_LINTER_RULES="$DEFAULT_RULES_LOCATION/$COFFEE_FILE_NAME" # Path to the coffescript lint rules
# Javascript Vars
JAVASCRIPT_FILE_NAME='.eslintrc.yml'                                    # Name of the file
JAVASCRIPT_LINTER_RULES="$DEFAULT_RULES_LOCATION/$JAVASCRIPT_FILE_NAME" # Path to the Javascript lint rules
JAVASCRIPT_STANDARD_LINTER_RULES=''                                     # ENV string to pass when running js standard
# Typecript Vars
TYPESCRIPT_FILE_NAME='.eslintrc.yml'                                    # Name of the file
TYPESCRIPT_LINTER_RULES="$DEFAULT_RULES_LOCATION/$TYPESCRIPT_FILE_NAME" # Path to the Typescript lint rules
TYPESCRIPT_STANDARD_LINTER_RULES=''                                     # ENV string to pass when running js standard
# Ansible Vars
ANSIBLE_FILE_NAME='.ansible-lint.yml'                               # Name of the file
ANSIBLE_LINTER_RULES="$DEFAULT_RULES_LOCATION/$ANSIBLE_FILE_NAME"   # Path to the Ansible lint rules
# Docker Vars
DOCKER_FILE_NAME='.dockerfilelintrc'                                # Name of the file
DOCKER_LINTER_RULES="$DEFAULT_RULES_LOCATION/$DOCKER_FILE_NAME"     # Path to the Docker lint rules
# Golang Vars
GO_FILE_NAME='.golangci.yml'                                        # Name of the file
GO_LINTER_RULES="$DEFAULT_RULES_LOCATION/$GO_FILE_NAME"             # Path to the Go lint rules
# Terraform Vars
TERRAFORM_FILE_NAME='.tflint.hcl'                                        # Name of the file
TERRAFORM_LINTER_RULES="$DEFAULT_RULES_LOCATION/$TERRAFORM_FILE_NAME"    # Path to the Terraform lint rules

#######################################
# Linter array for information prints #
#######################################
LINTER_ARRAY=("jsonlint" "yamllint" "xmllint" "markdownlint" "shellcheck"
  "pylint" "perl" "rubocop" "coffeelint" "eslint" "standard"
  "ansible-lint" "/dockerfilelint/bin/dockerfilelint" "golangci-lint" "tflint")

###################
# GitHub ENV Vars #
###################
GITHUB_SHA="${GITHUB_SHA}"                            # GitHub sha from the commit
GITHUB_EVENT_PATH="${GITHUB_EVENT_PATH}"              # Github Event Path
GITHUB_WORKSPACE="${GITHUB_WORKSPACE}"                # Github Workspace
ANSIBLE_DIRECTORY="${ANSIBLE_DIRECTORY}"              # Ansible Directory
VALIDATE_ALL_CODEBASE="${VALIDATE_ALL_CODEBASE}"      # Boolean to validate all files
VALIDATE_YAML="${VALIDATE_YAML}"                      # Boolean to validate language
VALIDATE_JSON="${VALIDATE_JSON}"                      # Boolean to validate language
VALIDATE_XML="${VALIDATE_XML}"                        # Boolean to validate language
VALIDATE_MD="${VALIDATE_MD}"                          # Boolean to validate language
VALIDATE_BASH="${VALIDATE_BASH}"                      # Boolean to validate language
VALIDATE_PERL="${VALIDATE_PERL}"                      # Boolean to validate language
VALIDATE_PYTHON="${VALIDATE_PYTHON}"                  # Boolean to validate language
VALIDATE_RUBY="${VALIDATE_RUBY}"                      # Boolean to validate language
VALIDATE_COFFEE="${VALIDATE_COFFEE}"                  # Boolean to validate language
VALIDATE_ANSIBLE="${VALIDATE_ANSIBLE}"                # Boolean to validate language
VALIDATE_JAVASCRIPT_ES="${VALIDATE_JAVASCRIPT_ES}"              # Boolean to validate language
VALIDATE_JAVASCRIPT_STANDARD="${VALIDATE_JAVASCRIPT_STANDARD}"  # Boolean to validate language
VALIDATE_TYPESCRIPT_ES="${VALIDATE_TYPESCRIPT_ES}"              # Boolean to validate language
VALIDATE_TYPESCRIPT_STANDARD="${VALIDATE_TYPESCRIPT_STANDARD}"  # Boolean to validate language
VALIDATE_DOCKER="${VALIDATE_DOCKER}"                  # Boolean to validate language
VALIDATE_GO="${VALIDATE_GO}"                          # Boolean to validate language
VALIDATE_TERRAFORM="${VALIDATE_TERRAFORM}"            # Boolean to validate language
TEST_CASE_RUN="${TEST_CASE_RUN}"                      # Boolean to validate only test cases

##############
# Debug Vars #
##############
RUN_LOCAL="${RUN_LOCAL}"                        # Boolean to see if we are running locally
ACTIONS_RUNNER_DEBUG="${ACTIONS_RUNNER_DEBUG}"  # Boolean to see even more info (debug)

################
# Default Vars #
################
DEFAULT_VALIDATE_ALL_CODEBASE='true'                  # Default value for validate all files
DEFAULT_VALIDATE_LANGUAGE='true'                      # Default to validate language
DEFAULT_WORKSPACE='/tmp/lint'                         # Default workspace if running locally
DEFAULT_ANSIBLE_DIRECTORY="$GITHUB_WORKSPACE/ansible" # Default Ansible Directory
DEFAULT_RUN_LOCAL='false'                             # Default value for debugging locally
DEFAULT_TEST_CASE_RUN='false'                         # Flag to tell code to run only test cases
DEFAULT_ACTIONS_RUNNER_DEBUG='false'                  # Default value for debugging output
RAW_FILE_ARRAY=()                                     # Array of all files that were changed
READ_ONLY_CHANGE_FLAG=0                               # Flag set to 1 if files changed are not txt or md
TEST_CASE_FOLDER='.automation/test'                   # Folder for test cases we should always ignore

##########################
# Array of changed files #
##########################
FILE_ARRAY_YML=()                   # Array of files to check
FILE_ARRAY_JSON=()                  # Array of files to check
FILE_ARRAY_XML=()                   # Array of files to check
FILE_ARRAY_MD=()                    # Array of files to check
FILE_ARRAY_BASH=()                  # Array of files to check
FILE_ARRAY_PERL=()                  # Array of files to check
FILE_ARRAY_RUBY=()                  # Array of files to check
FILE_ARRAY_PYTHON=()                # Array of files to check
FILE_ARRAY_COFFEESCRIPT=()          # Array of files to check
FILE_ARRAY_JAVASCRIPT_ES=()         # Array of files to check
FILE_ARRAY_JAVASCRIPT_STANDARD=()   # Array of files to check
FILE_ARRAY_TYPESCRIPT_ES=()         # Array of files to check
FILE_ARRAY_TYPESCRIPT_STANDARD=()   # Array of files to check
FILE_ARRAY_DOCKER=()                # Array of files to check
FILE_ARRAY_GO=()                    # Array of files to check
FILE_ARRAY_TERRAFORM=()             # Array of files to check

############
# Counters #
############
ERRORS_FOUND_YML=0                  # Count of errors found
ERRORS_FOUND_JSON=0                 # Count of errors found
ERRORS_FOUND_XML=0                  # Count of errors found
ERRORS_FOUND_MARKDOWN=0             # Count of errors found
ERRORS_FOUND_BASH=0                 # Count of errors found
ERRORS_FOUND_PERL=0                 # Count of errors found
ERRORS_FOUND_RUBY=0                 # Count of errors found
ERRORS_FOUND_PYTHON=0               # Count of errors found
ERRORS_FOUND_COFFEESCRIPT=0         # Count of errors found
ERRORS_FOUND_ANSIBLE=0              # Count of errors found
ERRORS_FOUND_JAVASCRIPT_STANDARD=0  # Count of errors found
ERRORS_FOUND_JAVASCRIPT_ES=0        # Count of errors found
ERRORS_FOUND_TYPESCRIPT_STANDARD=0  # Count of errors found
ERRORS_FOUND_TYPESCRIPT_ES=0        # Count of errors found
ERRORS_FOUND_DOCKER=0               # Count of errors found
ERRORS_FOUND_GO=0                   # Count of errors found
ERRORS_FOUND_TERRAFORM=0            # Count of errors found

################################################################################
########################## FUNCTIONS BELOW #####################################
################################################################################
################################################################################
#### Function Header ###########################################################
Header()
{
  echo ""
  echo "---------------------------------------------"
  echo "--- Github Actions Multi Language Linter ----"
  echo "---------------------------------------------"
  echo ""
  echo "---------------------------------------------"
  echo "The Super-Linter source code can be found at:"
  echo " - https://github.com/github/super-linter"
  echo "---------------------------------------------"
}
################################################################################
#### Function GetLinterVersions ################################################
GetLinterVersions()
{
  #########################
  # Print version headers #
  #########################
  echo ""
  echo "---------------------------------------------"
  echo "Linter Version Info:"
  echo "---------------------------------------------"
  echo ""

  ##########################################################
  # Go through the array of linters and print version info #
  ##########################################################
  for LINTER in "${LINTER_ARRAY[@]}"
  do
    echo "---------------------------------------------"
    echo "[$LINTER]:"
    ###################
    # Get the version #
    ###################
    # shellcheck disable=SC2207
    GET_VERSION_CMD=($("$LINTER" --version 2>&1))

    #######################
    # Load the error code #
    #######################
    ERROR_CODE=$?

    ##############################
    # Check the shell for errors #
    ##############################
    if [ $ERROR_CODE -ne 0 ] | [ -z "${GET_VERSION_CMD[*]}" ]; then
      echo "WARN! Failed to get version info for:[$LINTER]"
      echo "---------------------------------------------"
    else
      ##########################
      # Print the version info #
      ##########################
      echo "${GET_VERSION_CMD[*]}"
      echo "---------------------------------------------"
    fi
  done
}
################################################################################
#### Function GetLinterRules ###################################################
GetLinterRules()
{
  # Need to validate the rules files exist

  ################
  # Pull in vars #
  ################
  FILE_NAME="$1"      # Name fo the linter file
  FILE_LOCATION="$2"  # Location of the linter file

  #####################################
  # Validate we have the linter rules #
  #####################################
  if [ -f "$GITHUB_WORKSPACE/$LINTER_PATH/$FILE_NAME" ]; then
    echo "----------------------------------------------"
    echo "User provided file:[$FILE_NAME], setting rules file..."

    ####################################
    # Copy users into default location #
    ####################################
    CP_CMD=$(cp "$GITHUB_WORKSPACE/$LINTER_PATH/$FILE_NAME" "$FILE_LOCATION" 2>&1)

    ###################
    # Load Error code #
    ###################
    ERROR_CODE=$?

    ##############################
    # Check the shell for errors #
    ##############################
    if [ $ERROR_CODE -ne 0 ]; then
      echo "ERROR! Failed to set file:[$FILE_NAME] as default!"
      echo "ERROR:[$CP_CMD]"
      exit 1
    fi
  else
    ########################################################
    # No user default provided, using the template default #
    ########################################################
    if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
      echo "  -> Codebase does NOT have file:[$LINTER_PATH/$FILE_NAME], using Default rules at:[$FILE_LOCATION]"
    fi
  fi
}
################################################################################
#### Function GetStandardRules #################################################
GetStandardRules()
{
  ################
  # Pull In Vars #
  ################
  LINTER="$1" # Type: javascript | typescript

  #########################################################################
  # Need to get the ENV vars from the linter rules to run in command line #
  #########################################################################
  # Copy orig IFS to var
  ORIG_IFS="$IFS"
  # Set the IFS to newline
  IFS=$'\n'

  #########################################
  # Get list of all environment variables #
  #########################################
  # Only env vars that are marked as true
  GET_ENV_ARRAY=()
  if [[ "$LINTER" == "javascript" ]]; then
    # shellcheck disable=SC2207
    GET_ENV_ARRAY=($(yq .env "$JAVASCRIPT_LINTER_RULES" |grep true))
  elif [[ "$LINTER" == "typescript" ]]; then
    # shellcheck disable=SC2207
    GET_ENV_ARRAY=($(yq .env "$TYPESCRIPT_LINTER_RULES" |grep true))
  fi

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # ERROR
    echo "ERROR! Failed to gain list of ENV vars to load!"
    echo "ERROR:[${GET_ENV_ARRAY[*]}]"
    exit 1
  fi

  ##########################
  # Set IFS back to normal #
  ##########################
  # Set IFS back to Orig
  IFS="$ORIG_IFS"

  ######################
  # Set the env string #
  ######################
  ENV_STRING=''

  #############################
  # Pull out the envs to load #
  #############################
  for ENV in "${GET_ENV_ARRAY[@]}"
  do
    #############################
    # remove spaces from return #
    #############################
    ENV="$(echo -e "${ENV}" | tr -d '[:space:]')"
    ################################
    # Get the env to add to string #
    ################################
    ENV="$(echo "${ENV}" | cut -d'"' -f2)"
    # echo "ENV:[$ENV]"
    ENV_STRING+="--env ${ENV} "
  done

  ########################################
  # Remove trailing and ending witespace #
  ########################################
  if [[ "$LINTER" == "javascript" ]]; then
    JAVASCRIPT_STANDARD_LINTER_RULES="$(echo -e "${ENV_STRING}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  elif [[ "$LINTER" == "typescript" ]]; then
    TYPESCRIPT_STANDARD_LINTER_RULES="$(echo -e "${ENV_STRING}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  fi
}
################################################################################
#### Function LintAnsibleFiles #################################################
LintAnsibleFiles()
{
  ######################
  # Create Print Array #
  ######################
  PRINT_ARRAY=()

  ################
  # print header #
  ################
  PRINT_ARRAY+=("")
  PRINT_ARRAY+=("----------------------------------------------")
  PRINT_ARRAY+=("----------------------------------------------")
  PRINT_ARRAY+=("Linting [Ansible] files...")
  PRINT_ARRAY+=("----------------------------------------------")
  PRINT_ARRAY+=("----------------------------------------------")

  ######################
  # Name of the linter #
  ######################
  LINTER_NAME="ansible-lint"

  ###########################################
  # Validate we have ansible-lint installed #
  ###########################################
  # shellcheck disable=SC2230
  VALIDATE_INSTALL_CMD=$(command -v "$LINTER_NAME" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Failed
    echo "ERROR! Failed to find $LINTER_NAME in system!"
    echo "ERROR:[$VALIDATE_INSTALL_CMD]"
    exit 1
  else
    # Success
    if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
      # Success
      echo "Successfully found binary in system"
      echo "Location:[$VALIDATE_INSTALL_CMD]"
    fi
  fi

  ##########################
  # Initialize empty Array #
  ##########################
  LIST_FILES=()

  #######################
  # Create flag to skip #
  #######################
  SKIP_FLAG=0

  ######################################################
  # Only go into ansible linter if we have base folder #
  ######################################################
  if [ -d "$ANSIBLE_DIRECTORY" ]; then

    ############################################################
    # Check to see if we need to go through array or all files #
    ############################################################
    if [ "$VALIDATE_ALL_CODEBASE" == "false" ]; then
      # We need to only check the ansible playbooks that have updates
      #LIST_FILES=("${ANSIBLE_ARRAY[@]}")
      # shellcheck disable=SC2164,SC2010,SC2207
      LIST_FILES=($(cd "$ANSIBLE_DIRECTORY"; ls | grep ".yml" 2>&1))
    else
      #################################
      # Get list of all files to lint #
      #################################
      # shellcheck disable=SC2164,SC2010,SC2207
      LIST_FILES=($(cd "$ANSIBLE_DIRECTORY"; ls | grep ".yml" 2>&1))
    fi

    ###############################################################
    # Set the list to empty if only MD and TXT files were changed #
    ###############################################################
    # No need to run the full ansible checks on read only file changes
    if [ "$READ_ONLY_CHANGE_FLAG" -eq 0 ]; then
      ##########################
      # Set the array to empty #
      ##########################
      LIST_FILES=()
      ###################################
      # Send message that were skipping #
      ###################################
      #echo "- Skipping Ansible lint run as file(s) that were modified were read only..."
      ############################
      # Create flag to skip loop #
      ############################
      SKIP_FLAG=1
    fi

    ####################################
    # Check if we have data to look at #
    ####################################
    if [ $SKIP_FLAG -eq 0 ]; then
      for LINE in "${PRINT_ARRAY[@]}"
      do
        #########################
        # Print the header line #
        #########################
        echo "$LINE"
      done
    fi

    ##################
    # Lint the files #
    ##################
    for FILE in "${LIST_FILES[@]}"
    do

      ########################################
      # Make sure we dont lint certain files #
      ########################################
      if [[ $FILE == *"vault.yml"* ]] || [[ $FILE == *"galaxy.yml"* ]]; then
        # This is a file we dont look at
        continue
      fi

      ####################
      # Get the filename #
      ####################
      FILE_NAME=$(basename "$ANSIBLE_DIRECTORY/$FILE" 2>&1)

      ##############
      # File print #
      ##############
      echo "---------------------------"
      echo "File:[$FILE]"

      ################################
      # Lint the file with the rules #
      ################################
      LINT_CMD=$("$LINTER_NAME" -v -c "$ANSIBLE_LINTER_RULES" "$ANSIBLE_DIRECTORY/$FILE" 2>&1)

      #######################
      # Load the error code #
      #######################
      ERROR_CODE=$?

      ##############################
      # Check the shell for errors #
      ##############################
      if [ $ERROR_CODE -ne 0 ]; then
        #########
        # Error #
        #########
        echo "ERROR! Found errors in [$LINTER_NAME] linter!"
        echo "ERROR:[$LINT_CMD]"
        # Increment error count
        ((ERRORS_FOUND_ANSIBLE++))
      else
        ###########
        # Success #
        ###########
        echo " - File:[$FILE_NAME] was linted with [$LINTER_NAME] successfully"
      fi
    done
  else # No ansible directory found in path
    ###############################
    # Check to see if debug is on #
    ###############################
    if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
      ########################
      # No Ansible dir found #
      ########################
      echo "WARN! No Ansible base directory found at:[$ANSIBLE_DIRECTORY]"
      echo "skipping ansible lint"
    fi
  fi
}
################################################################################
#### Function GetGitHubVars ####################################################
GetGitHubVars()
{
  ##########
  # Prints #
  ##########
  echo "--------------------------------------------"
  echo "Gathering GitHub information..."

  ###############################
  # Get the Run test cases flag #
  ###############################
  if [ -z "$TEST_CASE_RUN" ]; then
    ##################################
    # No flag passed, set to default #
    ##################################
    TEST_CASE_RUN="$DEFAULT_TEST_CASE_RUN"
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  TEST_CASE_RUN=$(echo "$TEST_CASE_RUN" | awk '{print tolower($0)}')

  ##########################
  # Get the run local flag #
  ##########################
  if [ -z "$RUN_LOCAL" ]; then
    ##################################
    # No flag passed, set to default #
    ##################################
    RUN_LOCAL="$DEFAULT_RUN_LOCAL"
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  RUN_LOCAL=$(echo "$RUN_LOCAL" | awk '{print tolower($0)}')

  #################################
  # Check if were running locally #
  #################################
  if [[ "$RUN_LOCAL" != "false" ]]; then
    ##########################################
    # We are running locally for a debug run #
    ##########################################
    echo "NOTE: ENV VAR [RUN_LOCAL] has been set to:[true]"
    echo "bypassing GitHub Actions variables..."
    echo "Linting all files in mapped directory:[$DEFAULT_WORKSPACE]"

    # No need to touch or set the GITHUB_SHA
    # No need to touch or set the GITHUB_EVENT_PATH
    # No need to touch or set the GITHUB_ORG
    # No need to touch or set the GITHUB_REPO

    ############################
    # Set the GITHUB_WORKSPACE #
    ############################
    GITHUB_WORKSPACE="$DEFAULT_WORKSPACE"

    #################################
    # Set the VALIDATE_ALL_CODEBASE #
    #################################
    VALIDATE_ALL_CODEBASE="$DEFAULT_VALIDATE_ALL_CODEBASE"
  else
    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_SHA" ]; then
      echo "ERROR! Failed to get [GITHUB_SHA]!"
      echo "ERROR:[$GITHUB_SHA]"
      exit 1
    else
      echo "Successfully found:[GITHUB_SHA], value:[$GITHUB_SHA]"
    fi

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_WORKSPACE" ]; then
      echo "ERROR! Failed to get [GITHUB_WORKSPACE]!"
      echo "ERROR:[$GITHUB_WORKSPACE]"
      exit 1
    else
      echo "Successfully found:[GITHUB_WORKSPACE], value:[$GITHUB_WORKSPACE]"
    fi

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_EVENT_PATH" ]; then
      echo "ERROR! Failed to get [GITHUB_EVENT_PATH]!"
      echo "ERROR:[$GITHUB_EVENT_PATH]"
      exit 1
    else
      echo "Successfully found:[GITHUB_EVENT_PATH], value:[$GITHUB_EVENT_PATH]"
    fi

    ##################################################
    # Need to pull the GitHub Vars from the env file #
    ##################################################

    ######################
    # Get the GitHub Org #
    ######################
    # shellcheck disable=SC2002
    GITHUB_ORG=$(cat "$GITHUB_EVENT_PATH" | jq -r '.repository.owner.login' )

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_ORG" ]; then
      echo "ERROR! Failed to get [GITHUB_ORG]!"
      echo "ERROR:[$GITHUB_ORG]"
      exit 1
    else
      echo "Successfully found:[GITHUB_ORG], value:[$GITHUB_ORG]"
    fi

    #######################
    # Get the GitHub Repo #
    #######################
    # shellcheck disable=SC2002
    GITHUB_REPO=$(cat "$GITHUB_EVENT_PATH"| jq -r '.repository.name' )

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_REPO" ]; then
      echo "ERROR! Failed to get [GITHUB_REPO]!"
      echo "ERROR:[$GITHUB_REPO]"
      exit 1
    else
      echo "Successfully found:[GITHUB_REPO], value:[$GITHUB_REPO]"
    fi
  fi
}
################################################################################
#### Function GetValidationInfo ################################################
GetValidationInfo()
{
  ############################################
  # Print headers for user provided env vars #
  ############################################
  echo ""
  echo "--------------------------------------------"
  echo "Gathering user validation information..."

  ###########################################
  # Skip validation if were running locally #
  ###########################################
  if [[ "$RUN_LOCAL" != "true" ]]; then
    ###############################
    # Convert string to lowercase #
    ###############################
    VALIDATE_ALL_CODEBASE=$(echo "$VALIDATE_ALL_CODEBASE" | awk '{print tolower($0)}')
    ######################################
    # Validate we should check all files #
    ######################################
    if [[ "$VALIDATE_ALL_CODEBASE" != "false" ]]; then
      # Set to true
      VALIDATE_ALL_CODEBASE="$DEFAULT_VALIDATE_ALL_CODEBASE"
      echo "- Validating ALL files in code base..."
    else
      # Its false
      echo "- Only validating [new], or [edited] files in code base..."
    fi
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_YAML=$(echo "$VALIDATE_YAML" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_YAML" != "false" ]]; then
    # Set to true
    VALIDATE_YAML="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [YML] files in code base..."
  else
    # Its false
    echo "- Excluding [YML] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_JSON=$(echo "$VALIDATE_JSON" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_JSON" != "false" ]]; then
    # Set to true
    VALIDATE_JSON="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [JSON] files in code base..."
  else
    # Its false
    echo "- Excluding [JSON] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_XML=$(echo "$VALIDATE_XML" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_XML" != "false" ]]; then
    # Set to true
    VALIDATE_XML="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [XML] files in code base..."
  else
    # Its false
    echo "- Excluding [XML] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_MD=$(echo "$VALIDATE_MD" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_MD" != "false" ]]; then
    # Set to true
    VALIDATE_MD="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [MARKDOWN] files in code base..."
  else
    # Its false
    echo "- Excluding [MARKDOWN] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_BASH=$(echo "$VALIDATE_BASH" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_BASH" != "false" ]]; then
    # Set to true
    VALIDATE_BASH="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [BASH] files in code base..."
  else
    # Its false
    echo "- Excluding [BASH] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_PERL=$(echo "$VALIDATE_PERL" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_PERL" != "false" ]]; then
    # Set to true
    VALIDATE_PERL="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [PERL] files in code base..."
  else
    # Its false
    echo "- Excluding [PERL] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_PYTHON=$(echo "$VALIDATE_PYTHON" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_PYTHON" != "false" ]]; then
    # Set to true
    VALIDATE_PYTHON="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [PYTHON] files in code base..."
  else
    # Its false
    echo "- Excluding [PYTHON] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_RUBY=$(echo "$VALIDATE_RUBY" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_RUBY" != "false" ]]; then
    # Set to true
    VALIDATE_RUBY="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [RUBY] files in code base..."
  else
    # Its false
    echo "- Excluding [RUBY] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_COFFEE=$(echo "$VALIDATE_COFFEE" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_COFFEE" != "false" ]]; then
    # Set to true
    VALIDATE_COFFEE="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [COFFEE] files in code base..."
  else
    # Its false
    echo "- Excluding [COFFEE] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_ANSIBLE=$(echo "$VALIDATE_ANSIBLE" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_ANSIBLE" != "false" ]]; then
    # Set to true
    VALIDATE_ANSIBLE="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [ANSIBLE] files in code base..."
  else
    # Its false
    echo "- Excluding [ANSIBLE] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_JAVASCRIPT_ES=$(echo "$VALIDATE_JAVASCRIPT_ES" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_JAVASCRIPT_ES" != "false" ]]; then
    # Set to true
    VALIDATE_JAVASCRIPT_ES="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [JAVASCRIPT(eslint)] files in code base..."
  else
    # Its false
    echo "- Excluding [JAVASCRIPT(eslint)] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_JAVASCRIPT_STANDARD=$(echo "$VALIDATE_JAVASCRIPT_STANDARD" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_JAVASCRIPT_STANDARD" != "false" ]]; then
    # Set to true
    VALIDATE_JAVASCRIPT_STANDARD="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [JAVASCRIPT(standard)] files in code base..."
  else
    # Its false
    echo "- Excluding [JAVASCRIPT(standard)] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_TYPESCRIPT_ES=$(echo "$VALIDATE_TYPESCRIPT_ES" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_TYPESCRIPT_ES" != "false" ]]; then
    # Set to true
    VALIDATE_TYPESCRIPT_ES="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [TYPESCRIPT(eslint)] files in code base..."
  else
    # Its false
    echo "- Excluding [TYPESCRIPT(eslint)] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_TYPESCRIPT_STANDARD=$(echo "$VALIDATE_TYPESCRIPT_STANDARD" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_TYPESCRIPT_STANDARD" != "false" ]]; then
    # Set to true
    VALIDATE_TYPESCRIPT_STANDARD="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [TYPESCRIPT(standard)] files in code base..."
  else
    # Its false
    echo "- Excluding [TYPESCRIPT(standard)] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_DOCKER=$(echo "$VALIDATE_DOCKER" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_DOCKER" != "false" ]]; then
    # Set to true
    VALIDATE_DOCKER="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [DOCKER] files in code base..."
  else
    # Its false
    echo "- Excluding [DOCKER] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_GO=$(echo "$VALIDATE_GO" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_GO" != "false" ]]; then
    # Set to true
    VALIDATE_GO="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [GOLANG] files in code base..."
  else
    # Its false
    echo "- Excluding [GOLANG] files in code base..."
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  VALIDATE_TERRAFORM=$(echo "$VALIDATE_TERRAFORM" | awk '{print tolower($0)}')
  ######################################
  # Validate we should check all files #
  ######################################
  if [[ "$VALIDATE_TERRAFORM" != "false" ]]; then
    # Set to true
    VALIDATE_TERRAFORM="$DEFAULT_VALIDATE_LANGUAGE"
    echo "- Validating [TERRAFORM] files in code base..."
  else
    # Its false
    echo "- Excluding [TERRAFORM] files in code base..."
  fi

  ##############################
  # Validate Ansible Directory #
  ##############################
  if [ -z "$ANSIBLE_DIRECTORY" ]; then
    # No Value, need to default
    ANSIBLE_DIRECTORY="$DEFAULT_ANSIBLE_DIRECTORY"
  else
    # Check if first char is '/'
    if [[ ${ANSIBLE_DIRECTORY:0:1} == "/" ]]; then
      # Remove first char
      ANSIBLE_DIRECTORY="${ANSIBLE_DIRECTORY:1}"
    fi
    # Need to give it full path
    TEMP_ANSIBLE_DIRECTORY="$GITHUB_WORKSPACE/$ANSIBLE_DIRECTORY"
    # Set the value
    ANSIBLE_DIRECTORY="$TEMP_ANSIBLE_DIRECTORY"
  fi

  ############################
  # Get the run verbose flag #
  ############################
  if [ -z "$ACTIONS_RUNNER_DEBUG" ]; then
    ##################################
    # No flag passed, set to default #
    ##################################
    ACTIONS_RUNNER_DEBUG="$DEFAULT_ACTIONS_RUNNER_DEBUG"
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  ACTIONS_RUNNER_DEBUG=$(echo "$ACTIONS_RUNNER_DEBUG" | awk '{print tolower($0)}')

  ############################
  # Set to true if not false #
  ############################
  if [ "$ACTIONS_RUNNER_DEBUG" != "false" ]; then
    ACTIONS_RUNNER_DEBUG="true"
  fi

  ###################
  # Debug on runner #
  ###################
  if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
    echo "--- DEBUG ---"
    echo "---------------------------------------------"
    RUNNER=$(whoami)
    echo "Runner:[$RUNNER]"
    echo "ENV:"
    printenv
    echo "---------------------------------------------"
  fi
}
################################################################################
#### Function BuildFileList ####################################################
BuildFileList()
{
  # Need to build a list of all files changed
  # This can be pulled from the GITHUB_EVENT_PATH payload

  ################
  # print header #
  ################
  if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
    echo ""
    echo "----------------------------------------------"
    echo "Pulling in code history and branches..."
  fi

  #####################################################################
  # Switch codebase back to master to get a list of all files changed #
  #####################################################################
  SWITCH_CMD=$(cd "$GITHUB_WORKSPACE" || exit; git pull --quiet; git checkout master 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Error
    echo "Failed to switch to master branch to get files changed!"
    echo "ERROR:[$SWITCH_CMD]"
    exit 1
  fi

  ################
  # print header #
  ################
  if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
    echo ""
    echo "----------------------------------------------"
    echo "Generating Diff with:[git diff --name-only 'master..$GITHUB_SHA' --diff-filter=d]"
  fi

  ################################################
  # Get the Array of files changed in the comits #
  ################################################
  # shellcheck disable=SC2207
  RAW_FILE_ARRAY=($(cd "$GITHUB_WORKSPACE" || exit; git diff --name-only "master..$GITHUB_SHA" --diff-filter=d 2>&1))

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Error
    echo "ERROR! Failed to gain a list of all files changed!"
    echo "ERROR:[${RAW_FILE_ARRAY[*]}]"
    exit 1
  fi

  #################################################
  # Itterate through the array of all files found #
  #################################################
  echo ""
  echo "----------------------------------------------"
  echo "Files that have been modified in the commit(s):"
  for FILE in "${RAW_FILE_ARRAY[@]}"
  do
    ##############
    # Print file #
    ##############
    echo "File:[$FILE]"

    ###########################
    # Get the files extension #
    ###########################
    # Extract just the file and extension, reverse it, cut off extension,
    # reverse it back, substitute to lowercase
    FILE_TYPE=$(basename "$FILE" | rev | cut -f1 -d'.' | rev | awk '{print tolower($0)}')

    #########
    # DEBUG #
    #########
    #echo "FILE_TYPE:[$FILE_TYPE]"

    #####################
    # Get the YML files #
    #####################
    if [ "$FILE_TYPE" == "yml" ] || [ "$FILE_TYPE" == "yaml" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_YML+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ######################
    # Get the JSON files #
    ######################
    elif [ "$FILE_TYPE" == "json" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_JSON+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    #####################
    # Get the XML files #
    #####################
    elif [ "$FILE_TYPE" == "xml" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_XML+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ##########################
    # Get the MARKDOWN files #
    ##########################
    elif [ "$FILE_TYPE" == "md" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_MD+=("$FILE")
    ######################
    # Get the BASH files #
    ######################
    elif [ "$FILE_TYPE" == "sh" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_BASH+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ######################
    # Get the PERL files #
    ######################
    elif [ "$FILE_TYPE" == "pl" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_PERL+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ######################
    # Get the RUBY files #
    ######################
    elif [ "$FILE_TYPE" == "rb" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_RUBY+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ########################
    # Get the PYTHON files #
    ########################
    elif [ "$FILE_TYPE" == "py" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_PYTHON+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ########################
    # Get the COFFEE files #
    ########################
    elif [ "$FILE_TYPE" == "coffee" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_COFFEESCRIPT+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ############################
    # Get the JavaScript files #
    ############################
    elif [ "$FILE_TYPE" == "js" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_JAVASCRIPT_ES+=("$FILE")
      FILE_ARRAY_JAVASCRIPT_STANDARD+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ############################
    # Get the TypeScript files #
    ############################
    elif [ "$FILE_TYPE" == "ts" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_TYPESCRIPT_ES+=("$FILE")
      FILE_ARRAY_TYPESCRIPT_STANDARD+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ########################
    # Get the Golang files #
    ########################
    elif [ "$FILE_TYPE" == "go" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_GO+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    ###########################
    # Get the Terraform files #
    ###########################
    elif [ "$FILE_TYPE" == "tf" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_TERRAFORM+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    elif [ "$FILE" == "Dockerfile" ]; then
      ################################
      # Append the file to the array #
      ################################
      FILE_ARRAY_DOCKER+=("$FILE")
      ##########################################################
      # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
      ##########################################################
      READ_ONLY_CHANGE_FLAG=1
    else
      ##############################################
      # Use file to see if we can parse what it is #
      ##############################################
      GET_FILE_TYPE_CMD=$(file "$FILE" 2>&1)

      #################
      # Check if bash #
      #################
      if [[ "$GET_FILE_TYPE_CMD" == *"Bourne-Again shell script"* ]]; then
        #######################
        # It is a bash script #
        #######################
        echo "WARN! Found bash script without extension:[.sh]"
        echo "Please update file with proper extensions."
        ################################
        # Append the file to the array #
        ################################
        FILE_ARRAY_BASH+=("$FILE")
        ##########################################################
        # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
        ##########################################################
        READ_ONLY_CHANGE_FLAG=1
      elif [[ "$GET_FILE_TYPE_CMD" == *"Ruby script"* ]]; then
        #######################
        # It is a Ruby script #
        #######################
        echo "WARN! Found ruby script without extension:[.rb]"
        echo "Please update file with proper extensions."
        ################################
        # Append the file to the array #
        ################################
        FILE_ARRAY_RUBY+=("$FILE")
        ##########################################################
        # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
        ##########################################################
        READ_ONLY_CHANGE_FLAG=1
      else
        ############################
        # Extension was not found! #
        ############################
        echo "  - WARN! Failed to get filetype for:[$FILE]!"
        ##########################################################
        # Set the READ_ONLY_CHANGE_FLAG since this could be exec #
        ##########################################################
        READ_ONLY_CHANGE_FLAG=1
      fi
    fi
  done

  #########################################
  # Need to switch back to branch of code #
  #########################################
  SWITCH2_CMD=$(cd "$GITHUB_WORKSPACE" || exit; git checkout --progress --force "$GITHUB_SHA" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Error
    echo "Failed to switch back to branch!"
    echo "ERROR:[$SWITCH2_CMD]"
    exit 1
  fi

  ################
  # Footer print #
  ################
  echo ""
  echo "----------------------------------------------"
  echo "Successfully gathered list of files..."
}
################################################################################
#### Function LintCodebase #####################################################
LintCodebase()
{
  ####################
  # Pull in the vars #
  ####################
  FILE_TYPE="$1" && shift       # Pull the variable and remove from array path  (Example: JSON)
  LINTER_NAME="$1" && shift     # Pull the variable and remove from array path  (Example: jsonlint)
  LINTER_COMMAND="$1" && shift  # Pull the variable and remove from array path  (Example: jsonlint -c ConfigFile /path/to/file)
  FILE_EXTENSIONS="$1" && shift # Pull the variable and remove from array path  (Example: *.json)
  FILE_ARRAY=("$@")             # Array of files to validate                    (Example: $FILE_ARRAY_JSON)

  ######################
  # Create Print Array #
  ######################
  PRINT_ARRAY=()

  ################
  # print header #
  ################
  PRINT_ARRAY+=("")
  PRINT_ARRAY+=("----------------------------------------------")
  PRINT_ARRAY+=("----------------------------------------------")
  PRINT_ARRAY+=("Linting [$FILE_TYPE] files...")
  PRINT_ARRAY+=("----------------------------------------------")
  PRINT_ARRAY+=("----------------------------------------------")

  #######################################
  # Validate we have jsonlint installed #
  #######################################
  # shellcheck disable=SC2230
  VALIDATE_INSTALL_CMD=$(command -v "$LINTER_NAME" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Failed
    echo "ERROR! Failed to find [$LINTER_NAME] in system!"
    echo "ERROR:[$VALIDATE_INSTALL_CMD]"
    exit 1
  else
    # Success
    if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
      echo "Successfully found binary in system"
      echo "Location:[$VALIDATE_INSTALL_CMD]"
    fi
  fi

  ##########################
  # Initialize empty Array #
  ##########################
  LIST_FILES=()

  ################
  # Set the flag #
  ################
  SKIP_FLAG=0

  ############################################################
  # Check to see if we need to go through array or all files #
  ############################################################
  if [ ${#FILE_ARRAY[@]} -eq 0 ] && [ "$VALIDATE_ALL_CODEBASE" == "false" ]; then
    # No files found in commit and user has asked to not validate code base
    SKIP_FLAG=1
    # echo " - No files found in chageset to lint for language:[$FILE_TYPE]"
  elif [ ${#FILE_ARRAY[@]} -ne 0 ]; then
    # We have files added to array of files to check
    LIST_FILES=("${FILE_ARRAY[@]}") # Copy the array into list
  else
    #################################
    # Get list of all files to lint #
    #################################
    # shellcheck disable=SC2207,SC2086
    LIST_FILES=($(cd "$GITHUB_WORKSPACE" || exit; find . -type f -regex "$FILE_EXTENSIONS" 2>&1))

    ############################################################
    # Set it back to empty if loaded with blanks from scanning #
    ############################################################
    if [ ${#LIST_FILES[@]} -lt 1 ]; then
      LIST_FILES=()
    fi
  fi

  if [ $SKIP_FLAG -eq 0 ]; then
    ######################
    # Print Header array #
    ######################
    for LINE in "${PRINT_ARRAY[@]}"
    do
      #########################
      # Print the header info #
      #########################
      echo "$LINE"
    done

    ##################
    # Lint the files #
    ##################
    for FILE in "${LIST_FILES[@]}"
    do
      #####################
      # Get the file name #
      #####################
      FILE_NAME=$(basename "$FILE" 2>&1)

      #####################################################
      # Make sure we dont lint node modules or test cases #
      #####################################################
      if [[ $FILE == *"node_modules"* ]]; then
        # This is a node modules file
        continue
      elif [[ $FILE == *"$TEST_CASE_FOLDER"* ]]; then
        # This is the test cases, we should always skip
        continue
      fi

      ##############
      # File print #
      ##############
      echo "---------------------------"
      echo "File:[$FILE]"

      ################################
      # Lint the file with the rules #
      ################################
      LINT_CMD=$(cd "$GITHUB_WORKSPACE" || exit; $LINTER_COMMAND "$FILE" 2>&1)

      #######################
      # Load the error code #
      #######################
      ERROR_CODE=$?

      ##############################
      # Check the shell for errors #
      ##############################
      if [ $ERROR_CODE -ne 0 ]; then
        #########
        # Error #
        #########
        echo "ERROR! Found errors in [$LINTER_NAME] linter!"
        echo "ERROR:[$LINT_CMD]"
        # Increment the error count
        (("ERRORS_FOUND_$FILE_TYPE++"))
      else
        ###########
        # Success #
        ###########
        echo " - File:[$FILE_NAME] was linted with [$LINTER_NAME] successfully"
      fi
    done
  fi
}
################################################################################
#### Function TestCodebase #####################################################
TestCodebase()
{
  ####################
  # Pull in the vars #
  ####################
  FILE_TYPE="$1"        # Pull the variable and remove from array path  (Example: JSON)
  LINTER_NAME="$2"      # Pull the variable and remove from array path  (Example: jsonlint)
  LINTER_COMMAND="$3"   # Pull the variable and remove from array path  (Example: jsonlint -c ConfigFile /path/to/file)
  FILE_EXTENSIONS="$4"  # Pull the variable and remove from array path  (Example: *.json)

  ################
  # print header #
  ################
  echo ""
  echo "----------------------------------------------"
  echo "----------------------------------------------"
  echo "Testing Codebase [$FILE_TYPE] files..."
  echo "----------------------------------------------"
  echo "----------------------------------------------"
  echo ""

  #####################################
  # Validate we have linter installed #
  #####################################
  # shellcheck disable=SC2230
  VALIDATE_INSTALL_CMD=$(command -v "$LINTER_NAME" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Failed
    echo "ERROR! Failed to find [$LINTER_NAME] in system!"
    echo "ERROR:[$VALIDATE_INSTALL_CMD]"
    exit 1
  else
    # Success
    echo "Successfully found binary in system"
    echo "Location:[$VALIDATE_INSTALL_CMD]"
  fi

  ##########################
  # Initialize empty Array #
  ##########################
  LIST_FILES=()

  ############################################
  # Check if its ansible, as its the outlier #
  ############################################
  if [[ "$FILE_TYPE" == "ANSIBLE" ]]; then
    #################################
    # Get list of all files to lint #
    #################################
    # shellcheck disable=SC2207,SC2086,SC2010
    LIST_FILES=($(cd "$GITHUB_WORKSPACE/$TEST_CASE_FOLDER" || exit; ls ansible/ | grep ".yml" 2>&1))
  else
    #################################
    # Get list of all files to lint #
    #################################
    # shellcheck disable=SC2207,SC2086
    LIST_FILES=($(cd "$GITHUB_WORKSPACE/$TEST_CASE_FOLDER" || exit; find . -type f -regex "$FILE_EXTENSIONS" ! -path "*./ansible*" 2>&1))
  fi

  ##################
  # Lint the files #
  ##################
  for FILE in "${LIST_FILES[@]}"
  do
    #####################
    # Get the file name #
    #####################
    FILE_NAME=$(basename "$FILE" 2>&1)

    ############################
    # Get the file pass status #
    ############################
    # Example: markdown_good_1.md -> good
    FILE_STATUS=$(echo "$FILE_NAME" |cut -f2 -d'_')

    #########################################################
    # If not found, assume it should be linted successfully #
    #########################################################
    if [ -z "$FILE_STATUS" ] || [[ "$FILE" == *"README"* ]]; then
      ##################################
      # Set to good for proper linting #
      ##################################
      FILE_STATUS="good"
    fi

    ##############
    # File print #
    ##############
    echo "---------------------------"
    echo "File:[$FILE]"

    ########################
    # Set the lint command #
    ########################
    LINT_CMD=''

    #######################################
    # Check if docker and get folder name #
    #######################################
    if [[ "$FILE_TYPE" == "DOCKER" ]]; then
      if [[ "$FILE" == *"good"* ]]; then
        #############
        # Good file #
        #############
        FILE_STATUS='good'
      else
        ############
        # Bad file #
        ############
        FILE_STATUS='bad'
      fi
    fi

    #####################
    # Check for ansible #
    #####################
    if [[ "$FILE_TYPE" == "ANSIBLE" ]]; then
      ########################################
      # Make sure we dont lint certain files #
      ########################################
      if [[ $FILE == *"vault.yml"* ]] || [[ $FILE == *"galaxy.yml"* ]]; then
        # This is a file we dont look at
        continue
      fi

      ################################
      # Lint the file with the rules #
      ################################
      LINT_CMD=$(cd "$GITHUB_WORKSPACE/$TEST_CASE_FOLDER/ansible" || exit; $LINTER_COMMAND "$FILE" 2>&1)
    else
      ################################
      # Lint the file with the rules #
      ################################
      LINT_CMD=$(cd "$GITHUB_WORKSPACE/$TEST_CASE_FOLDER" || exit; $LINTER_COMMAND "$FILE" 2>&1)
    fi

    #######################
    # Load the error code #
    #######################
    ERROR_CODE=$?

    ########################################
    # Check for if it was supposed to pass #
    ########################################
    if [[ "$FILE_STATUS" == "good" ]]; then
      ##############################
      # Check the shell for errors #
      ##############################
      if [ $ERROR_CODE -ne 0 ]; then
        #########
        # Error #
        #########
        echo "ERROR! Found errors in [$LINTER_NAME] linter!"
        echo "ERROR:[$LINT_CMD]"
        echo "ERROR: Linter CMD:[$LINTER_COMMAND $FILE]"
        # Increment the error count
        (("ERRORS_FOUND_$FILE_TYPE++"))
      else
        ###########
        # Success #
        ###########
        echo " - File:[$FILE_NAME] was linted with [$LINTER_NAME] successfully"
      fi
    else
      #######################################
      # File status = bad, this should fail #
      #######################################
      ##############################
      # Check the shell for errors #
      ##############################
      if [ $ERROR_CODE -eq 0 ]; then
        #########
        # Error #
        #########
        echo "ERROR! Found errors in [$LINTER_NAME] linter!"
        echo "ERROR! This file should have failed test case!"
        echo "ERROR:[$LINT_CMD]"
        echo "ERROR: Linter CMD:[$LINTER_COMMAND $FILE]"
        # Increment the error count
        (("ERRORS_FOUND_$FILE_TYPE++"))
      else
        ###########
        # Success #
        ###########
        echo " - File:[$FILE_NAME] failed test case with [$LINTER_NAME] successfully"
      fi
    fi
  done
}
################################################################################
#### Function Footer ###########################################################
Footer()
{
  echo ""
  echo "----------------------------------------------"
  echo "----------------------------------------------"
  echo "The script has completed"
  echo "----------------------------------------------"
  echo "----------------------------------------------"
  echo ""
  echo "ERRORS FOUND in YAML:[$ERRORS_FOUND_YML]"
  echo "ERRORS FOUND in JSON:[$ERRORS_FOUND_JSON]"
  echo "ERRORS FOUND in XML:[$ERRORS_FOUND_XML]"
  echo "ERRORS FOUND in MARKDOWN:[$ERRORS_FOUND_MARKDOWN]"
  echo "ERRORS FOUND in BASH:[$ERRORS_FOUND_BASH]"
  echo "ERRORS FOUND in PERL:[$ERRORS_FOUND_PERL]"
  echo "ERRORS FOUND in PYTHON:[$ERRORS_FOUND_PYTHON]"
  echo "ERRORS FOUND in COFFEESCRIPT:[$ERRORS_FOUND_COFFEESCRIPT]"
  echo "ERRORS FOUND in RUBY:[$ERRORS_FOUND_RUBY]"
  echo "ERRORS FOUND in ANSIBLE:[$ERRORS_FOUND_ANSIBLE]"
  echo "ERRORS FOUND in JAVASCRIPT(eslint):[$ERRORS_FOUND_JAVASCRIPT_ES]"
  echo "ERRORS FOUND in JAVASCRIPT(Standard):[$ERRORS_FOUND_JAVASCRIPT_STANDARD]"
  echo "ERRORS FOUND in TYPESCRIPT(eslint):[$ERRORS_FOUND_TYPESCRIPT_ES]"
  echo "ERRORS FOUND in TYPESCRIPT(Standard):[$ERRORS_FOUND_TYPESCRIPT_STANDARD]"
  echo "ERRORS FOUND in DOCKER:[$ERRORS_FOUND_DOCKER]"
  echo "ERRORS FOUND in GO:[$ERRORS_FOUND_GO]"
  echo "ERRORS FOUND in TERRAFORM:[$ERRORS_FOUND_TERRAFORM]"
  echo ""
  echo "----------------------------------------------"
  echo ""

  ###############################
  # Exit with 1 if errors found #
  ###############################
  if [ "$ERRORS_FOUND_YML" -ne 0 ] || \
     [ "$ERRORS_FOUND_JSON" -ne 0 ] || \
     [ "$ERRORS_FOUND_XML" -ne 0 ] || \
     [ "$ERRORS_FOUND_MARKDOWN" -ne 0 ] || \
     [ "$ERRORS_FOUND_BASH" -ne 0 ] || \
     [ "$ERRORS_FOUND_PERL" -ne 0 ] || \
     [ "$ERRORS_FOUND_PYTHON" -ne 0 ] || \
     [ "$ERRORS_FOUND_COFFEESCRIPT" -ne 0 ] || \
     [ "$ERRORS_FOUND_ANSIBLE" -ne 0 ] || \
     [ "$ERRORS_FOUND_JAVASCRIPT_ES" -ne 0 ] || \
     [ "$ERRORS_FOUND_JAVASCRIPT_STANDARD" -ne 0 ] || \
     [ "$ERRORS_FOUND_TYPESCRIPT_ES" -ne 0 ] || \
     [ "$ERRORS_FOUND_TYPESCRIPT_STANDARD" -ne 0 ] || \
     [ "$ERRORS_FOUND_DOCKER" -ne 0 ] || \
     [ "$ERRORS_FOUND_GO" -ne 0 ] || \
     [ "$ERRORS_FOUND_TERRAFORM" -ne 0 ] || \
     [ "$ERRORS_FOUND_RUBY" -ne 0 ]; then
    # Failed exit
    echo "Exiting with errors found!"
    exit 1
  else
    # Successful exit
    exit 0
  fi
}
################################################################################
#### Function RunTestCases #####################################################
RunTestCases()
{
  # This loop will run the test cases and exclude user code
  # This is called from the automation process to validate new code
  # When a PR is opened, the new code is validated with the master branch
  # version of linter.sh, and a new container is built with the latest codebase
  # for testing. That container is spun up, and ran,
  # with the flag: TEST_CASE_RUN=true
  # So that the new code can be validated againt the test cases

  #################
  # Header prints #
  #################
  echo ""
  echo "----------------------------------------------"
  echo "-------------- TEST CASE RUN -----------------"
  echo "----------------------------------------------"
  echo ""

  #######################
  # Test case languages #
  #######################
  TestCodebase "YML" "yamllint" "yamllint -c $YAML_LINTER_RULES" ".*\.\(yml\|yaml\)\$"
  TestCodebase "JSON" "jsonlint" "jsonlint" ".*\.\(json\)\$"
  TestCodebase "XML" "xmllint" "xmllint" ".*\.\(xml\)\$"
  TestCodebase "MARKDOWN" "markdownlint" "markdownlint -c $MD_LINTER_RULES" ".*\.\(md\)\$"
  TestCodebase "BASH" "shellcheck" "shellcheck" ".*\.\(sh\)\$"
  TestCodebase "PYTHON" "pylint" "pylint --rcfile $PYTHON_LINTER_RULES -E" ".*\.\(py\)\$"
  TestCodebase "PERL" "perl" "perl -Mstrict -cw" ".*\.\(pl\)\$"
  TestCodebase "RUBY" "rubocop" "rubocop -c $RUBY_LINTER_RULES" ".*\.\(rb\)\$"
  TestCodebase "GO" "golangci-lint" "golangci-lint run -c $GO_LINTER_RULES" ".*\.\(go\)\$"
  TestCodebase "COFFEESCRIPT" "coffeelint" "coffeelint -f $COFFEESCRIPT_LINTER_RULES" ".*\.\(coffee\)\$"
  TestCodebase "JAVASCRIPT_ES" "eslint" "eslint --no-eslintrc -c $JAVASCRIPT_LINTER_RULES" ".*\.\(js\)\$"
  TestCodebase "JAVASCRIPT_STANDARD" "standard" "standard $JAVASCRIPT_STANDARD_LINTER_RULES" ".*\.\(js\)\$"
  TestCodebase "TYPESCRIPT_ES" "eslint" "eslint --no-eslintrc -c $TYPESCRIPT_LINTER_RULES" ".*\.\(ts\)\$"
  TestCodebase "TYPESCRIPT_STANDARD" "standard" "standard --parser @typescript-eslint/parser --plugin @typescript-eslint/eslint-plugin $TYPESCRIPT_STANDARD_LINTER_RULES" ".*\.\(ts\)\$"
  TestCodebase "DOCKER" "/dockerfilelint/bin/dockerfilelint" "/dockerfilelint/bin/dockerfilelint" ".*\(Dockerfile\)\$"
  TestCodebase "ANSIBLE" "ansible-lint" "ansible-lint -v -c $ANSIBLE_LINTER_RULES" "ansible-lint"
  TestCodebase "TERRAFORM" "tflint" "tflint -c $TERRAFORM_LINTER_RULES" ".*\.\(tf\)\$"

  #################
  # Footer prints #
  #################
  # Call the footer to display run information
  # and exit with error code
  Footer
}
################################################################################
############################### MAIN ###########################################
################################################################################

##########
# Header #
##########
Header

#######################
# Get Github Env Vars #
#######################
# Need to pull in all the Github variables
# needed to connect back and update checks
GetGitHubVars

##########################################
# Get the langugages we need to validate #
##########################################
if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
  # Get the flags for langugaes to validate
  GetValidationInfo
fi

########################
# Get the linter rules #
########################
# Get YML rules
GetLinterRules "$YAML_FILE_NAME" "$YAML_LINTER_RULES"
# Get Markdown rules
GetLinterRules "$MD_FILE_NAME" "$MD_LINTER_RULES"
# Get Python rules
GetLinterRules "$PYTHON_FILE_NAME" "$PYTHON_LINTER_RULES"
# Get Ruby rules
GetLinterRules "$RUBY_FILE_NAME" "$RUBY_LINTER_RULES"
# Get Coffeescript rules
GetLinterRules "$COFFEE_FILE_NAME" "$COFFEESCRIPT_LINTER_RULES"
# Get Ansible rules
GetLinterRules "$ANSIBLE_FILE_NAME" "$ANSIBLE_LINTER_RULES"
# Get JavaScript rules
GetLinterRules "$JAVASCRIPT_FILE_NAME" "$JAVASCRIPT_LINTER_RULES"
# Get TypeScript rules
GetLinterRules "$TYPESCRIPT_FILE_NAME" "$TYPESCRIPT_LINTER_RULES"
# Get Golang rules
GetLinterRules "$GO_FILE_NAME" "$GO_LINTER_RULES"
# Get Docker rules
GetLinterRules "$DOCKER_FILE_NAME" "$DOCKER_LINTER_RULES"
# Get Terraform rules
GetLinterRules "$TERRAFORM_FILE_NAME" "$TERRAFORM_LINTER_RULES"

#################################
# Check if were in verbose mode #
#################################
if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
  ##################################
  # Get and print all version info #
  ##################################
  GetLinterVersions
fi

###########################################
# Check to see if this is a test case run #
###########################################
if [[ "$TEST_CASE_RUN" != "false" ]]; then
  ###########################
  # Run only the test cases #
  ###########################
  # Code will exit from inside this loop
  RunTestCases
fi

#############################################
# check flag for validation of all codebase #
#############################################
if [ "$VALIDATE_ALL_CODEBASE" == "false" ]; then
  ########################################
  # Get list of files changed if env set #
  ########################################
  BuildFileList
fi

###############
# YML LINTING #
###############
if [ "$VALIDATE_YAML" == "true" ]; then
  ######################
  # Lint the Yml Files #
  ######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "YML" "yamllint" "yamllint -c $YAML_LINTER_RULES" ".*\.\(yml\|yaml\)\$" "${FILE_ARRAY_YML[@]}"
fi

################
# JSON LINTING #
################
if [ "$VALIDATE_JSON" == "true" ]; then
  #######################
  # Lint the json files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "JSON" "jsonlint" "jsonlint" ".*\.\(json\)\$" "${FILE_ARRAY_JSON[@]}"
fi

###############
# XML LINTING #
###############
if [ "$VALIDATE_XML" == "true" ]; then
  ######################
  # Lint the XML Files #
  ######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "XML" "xmllint" "xmllint" ".*\.\(xml\)\$" "${FILE_ARRAY_XML[@]}"
fi

####################
# MARKDOWN LINTING #
####################
if [ "$VALIDATE_MD" == "true" ]; then
  ###########################
  # Lint the Markdown Files #
  ###########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "MARKDOWN" "markdownlint" "markdownlint -c $MD_LINTER_RULES" ".*\.\(md\)\$" "${FILE_ARRAY_MD[@]}"
fi

################
# BASH LINTING #
################
if [ "$VALIDATE_BASH" == "true" ]; then
  #######################
  # Lint the bash files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "BASH" "shellcheck" "shellcheck" ".*\.\(sh\)\$" "${FILE_ARRAY_BASH[@]}"
fi

##################
# PYTHON LINTING #
##################
if [ "$VALIDATE_PYTHON" == "true" ]; then
  #########################
  # Lint the python files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "PYTHON" "pylint" "pylint --rcfile $PYTHON_LINTER_RULES -E" ".*\.\(py\)\$" "${FILE_ARRAY_PYTHON[@]}"
fi

################
# PERL LINTING #
################
if [ "$VALIDATE_PERL" == "true" ]; then
  #######################
  # Lint the perl files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "PERL" "perl" "perl -Mstrict -cw" ".*\.\(pl\)\$" "${FILE_ARRAY_PERL[@]}"
fi

################
# RUBY LINTING #
################
if [ "$VALIDATE_RUBY" == "true" ]; then
  #######################
  # Lint the ruby files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "RUBY" "rubocop" "rubocop -c $RUBY_LINTER_RULES" ".*\.\(rb\)\$" "${FILE_ARRAY_RUBY[@]}"
fi

########################
# COFFEESCRIPT LINTING #
########################
if [ "$VALIDATE_COFFEE" == "true" ]; then
  #########################
  # Lint the coffee files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "COFFEESCRIPT" "coffeelint" "coffeelint -f $COFFEESCRIPT_LINTER_RULES" ".*\.\(coffee\)\$" "${FILE_ARRAY_COFFEESCRIPT[@]}"
fi

##################
# GOLANG LINTING #
##################
if [ "$VALIDATE_GO" == "true" ]; then
  #########################
  # Lint the golang files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "GO" "golangci-lint" "golangci-lint run -c $GO_LINTER_RULES" ".*\.\(go\)\$" "${FILE_ARRAY_GO[@]}"
fi

#####################
# TERRAFORM LINTING #
#####################
if [ "$VALIDATE_TERRAFORM" == "true" ]; then
  ############################
  # Lint the Terraform files #
  ############################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "TERRAFORM" "tflint" "tflint -c $TERRAFORM_LINTER_RULES" ".*\.\(tf\)\$" "${FILE_ARRAY_TERRAFORM[@]}"
fi

###################
# ANSIBLE LINTING #
###################
if [ "$VALIDATE_ANSIBLE" == "true" ]; then
  ##########################
  # Lint the Ansible files #
  ##########################
  # Due to the nature of how we want to validate Ansible, we cannot use the
  # standard loop, since it looks for an ansible folder, excludes certain
  # files, and looks for additional changes, it should be an outlier
  LintAnsibleFiles
fi

######################
# JAVASCRIPT LINTING #
######################
if [ "$VALIDATE_JAVASCRIPT_ES" == "true" ]; then
  #############################
  # Lint the Javascript files #
  #############################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "JAVASCRIPT_ES" "eslint" "eslint --no-eslintrc -c $JAVASCRIPT_LINTER_RULES" ".*\.\(js\)\$" "${FILE_ARRAY_JAVASCRIPT_ES[@]}"
fi

######################
# JAVASCRIPT LINTING #
######################
if [ "$VALIDATE_JAVASCRIPT_STANDARD" == "true" ]; then
  #################################
  # Get Javascript standard rules #
  #################################
  GetStandardRules "javascript"
  #############################
  # Lint the Javascript files #
  #############################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "JAVASCRIPT_STANDARD" "standard" "standard $JAVASCRIPT_STANDARD_LINTER_RULES" ".*\.\(js\)\$" "${FILE_ARRAY_JAVASCRIPT_STANDARD[@]}"
fi

######################
# TYPESCRIPT LINTING #
######################
if [ "$VALIDATE_TYPESCRIPT_ES" == "true" ]; then
  #############################
  # Lint the Typescript files #
  #############################
  LintCodebase "TYPESCRIPT_ES" "eslint" "eslint --no-eslintrc -c $TYPESCRIPT_LINTER_RULES" ".*\.\(ts\)\$" "${FILE_ARRAY_TYPESCRIPT_ES[@]}"
fi
######################
# TYPESCRIPT LINTING #
######################
if [ "$VALIDATE_TYPESCRIPT_STANDARD" == "true" ]; then
  #################################
  # Get Typescript standard rules #
  #################################
  GetStandardRules "typescript"
  #############################
  # Lint the Typescript files #
  #############################
  LintCodebase "TYPESCRIPT_STANDARD" "standard" "standard --parser @typescript-eslint/parser --plugin @typescript-eslint/eslint-plugin $TYPESCRIPT_STANDARD_LINTER_RULES" ".*\.\(ts\)\$" "${FILE_ARRAY_TYPESCRIPT_STANDARD[@]}"
fi

##################
# DOCKER LINTING #
##################
if [ "$VALIDATE_DOCKER" == "true" ]; then
  #########################
  # Lint the docker files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "DOCKER" "/dockerfilelint/bin/dockerfilelint" "/dockerfilelint/bin/dockerfilelint" ".*\(Dockerfile\)\$" "${FILE_ARRAY_DOCKER[@]}"
fi

##########
# Footer #
##########
Footer
