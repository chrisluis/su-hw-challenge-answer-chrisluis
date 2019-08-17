*** Settings ***
Documentation  This file is where you can find common variables and keywords that will be used
...            accross the test suite.
Library        RequestsLibrary

*** Variables ***
# Adding prefix 'g' to annotate it is a global variable
${g_SESSION_NAME}         hardware_test
${g_API_URL}              http://localhost:3000
${g_GENERATE_URL}         /generate
${g_STATUS_CODE_OK}       200
${g_RESPONSE}             ${EMPTY}
${g_STATUS_CODE_INTERNAL_SERVER_ERROR}   500


*** Keywords ***
Create Request Session
    Create Session     ${g_SESSION_NAME}   ${g_API_URL}