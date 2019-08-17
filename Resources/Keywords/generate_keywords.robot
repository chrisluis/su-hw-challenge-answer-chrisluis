*** Settings ***
Resource  ../common.robot
Resource  ../Variables/generate_variables.robot

*** Keywords ***
#--------------------------------------
#         TEST TEMPLATE
#--------------------------------------
Supported Country Codes
    [Arguments]  ${supported_country_code}
    &{parameter} =  Create Dictionary    locale=${supported_country_code}
    ${response} =  Post Request  ${g_SESSION_NAME}   ${g_GENERATE_URL}   json=${parameter}
    Should Be Equal As Strings   ${response.status_code}     ${g_STATUS_CODE_OK}
    ${json_data} =   To Json     ${response.content}
    Run Keyword And Continue On Failure   Should Be Equal As Strings   ${json_data['message']}    ${USER_GENERATED_RESPONSE_MESSAGE}
    Run Keyword And Continue On Failure   Should Be Equal As Strings   ${json_data['user']['country']}   ${supported_country_code}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['personal_profile']['first_name']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['personal_profile']['last_name']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['personal_profile']['date_of_birth']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['personal_profile']['mobile_phone']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['personal_profile']['national_id']} #Error

    Run Keyword And Continue On Failure   Should Be Equal As Strings   ${json_data['user']['address']['country']}    ${supported_country_code}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['address_line1']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['address_line2']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['city']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['post_code']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['region_name']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['landline']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['first_name']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['last_name']}
    Run Keyword And Continue On Failure   Should Not Be Empty          ${json_data['user']['address']['company']}

Unsupported Country Codes
    [Arguments]  ${unsupported_country_code}
    &{parameter} =  Create Dictionary    locale=${unsupported_country_code}
    ${response} =  Post Request  ${g_SESSION_NAME}   ${g_GENERATE_URL}   json=${parameter}
    Should Be Equal As Strings   ${response.status_code}     ${g_STATUS_CODE_OK}
    ${json_data} =   To Json     ${response.content}
    Run Keyword And Continue On Failure   Should Not Be Equal As Strings   ${json_data['message']}    ${USER_GENERATED_RESPONSE_MESSAGE}

#-----------------------------------------------
#                   GIVEN
#-----------------------------------------------
POST Request Of Invalid Country Code Sent To /generate Using JSON Parameter
    [Arguments]    ${locale}
    &{parameter} =   Create Dictionary    locale=${locale}
    ${g_RESPONSE} =  Post Request  ${g_SESSION_NAME}   ${g_GENERATE_URL}   json=${parameter}
    Set Global Variable    ${g_RESPONSE}

POST Request Of Null Country Code Sent To /generate Using JSON Parameter
    [Arguments]    ${locale}
    &{parameter} =   Create Dictionary    locale=${locale}
    ${g_RESPONSE} =  Post Request  ${g_SESSION_NAME}   ${g_GENERATE_URL}   json=${parameter}
    Set Global Variable    ${g_RESPONSE}

POST Request Of Valid Country Code Sent To /generate Using Invalid JSON Parameter
    [Arguments]    ${locale}
    &{parameter} =   Create Dictionary    abcd=${locale}
    ${g_RESPONSE} =  Post Request  ${g_SESSION_NAME}   ${g_GENERATE_URL}   json=${parameter}
    Set Global Variable    ${g_RESPONSE}
#-----------------------------------------------
#                 WHEN
#-----------------------------------------------
Response Returns Ok Status
    Should Be Equal As Strings   ${g_RESPONSE.status_code}     ${g_STATUS_CODE_OK}

Response Returns Internal Server Status
    Should Be Equal As Strings   ${g_RESPONSE.status_code}     ${g_STATUS_CODE_INTERNAL_SERVER_ERROR}

#-----------------------------------------------
#                 THEN
#-----------------------------------------------
Response Message Should Not Be 'user generated'
   ${json_data} =  To Json    ${g_RESPONSE.content}
   Should Not Be Equal As Strings   ${json_data['message']}    ${USER_GENERATED_RESPONSE_MESSAGE}

Response Message Should Not Be 'user not generated'
   ${json_data} =  To Json    ${g_RESPONSE.content}
   Should Be Equal As Strings   ${json_data['message']}    ${USER_NOT_GENERATED_RESPONSE_MESSAGE}