*** Settings ***
Documentation  This a test suite that will test the generation of the user from /generate endpoint.
Resource  ../Resources/common.robot
Resource  ../Resources/Keywords/generate_keywords.robot
Suite Setup   Create Request Session

*** Variables ***
@{SUPPORTED_COUNTRY_CODES}      AL  AR  AM  AU  AT  AZ  BD  BE  BA  BR  BZ  BG  CA  CL  CN  CO  CR  DK  EG  GB
...                             EE  FI  FR  GE  DE  GR  HU  IN  IR  IL  IT  JP  KR  MX  MA  NP  NL  NZ  NG  NO
...                             PK  PL  PT  RO  RU  SA  SK  SI  ES  SE  CH  TR  UA  US  VN
@{UNSUPPORTED_COUNTRY_CODES}    AF  DZ  AS  AD  AO  AI  AQ  AG  AW  BS  BH  BB  BY  BJ  BM
...                             BT  BO  BQ  BW  BV  IO  BN  BF  BI  KH  CM  CV  KY  CF  TD  CX  CC  KM  CG  CD
...                             CK  HR  CU  CW  CY  CZ  CI  DJ  DM  DO  EC  SV  GQ  ER  ET  FK  FO  FJ  GF  PF
...                             TF  GA  GM  GH  GI  GL  GD  GP  GU  GT  GG  GN  GW  GY  HT  HM  VA  HN  HK  IS
...                             ID  IQ  IE  IM  JM  JE  JO  KZ  KE  KI  KP  KW  KG  LA  LV  LB  LS  LR  LY  LI
...                             LT  LU  MO  MK  MG  MW  MY  MV  ML  MT  MH  MQ  MR  MU  YT  FM  MD  MC  MN  ME
...                             MS  MZ  MM  NA  NR  NC  NI  NE  NU  NF  MP  OM  PW  PS  PA  PG  PY  PE  PH  PN
...                             PR  QA  RW  RE  BL  SH  KN  LC  MF  PM  VC  WS  SM  ST  SN  RS  SC  SL  SG  SX
...                             SB  SO  ZA  GS  SS  LK  SD  SR  SJ  SZ  SY  TW  TJ  TZ  TH  TL  TG  TK  TO  TN
...                             TR  TM  TC  TV  UG  AE  UM  UY  UZ  VU  VE  VG  VI  WF  EH  YE  ZM  ZW
${NONE_EXISTENT_COUNTRY_CODE}   XX
${BLANK_COUNTRY_CODE}           ${EMPTY}
${VALID_COUNTRY_CODE}           AL

*** Test Cases ***
Generate Supported Country Code User With No Null Values On Response
    [Documentation]  This test case will run ALL supported country codes.
    ...              Since this is a list, I've utilize the 'Test Template' function of Robot Framework
    ...              This will checks if the status code returns 200.
    ...              This will also check if the JSON response has no NULL values.
    [Template]  Supported Country Codes
    :FOR    ${item}    IN    @{SUPPORTED_COUNTRY_CODES}
    \     ${item}

Verify Unsupported Country Code Not Generating User
    [Documentation]  This will test ALL unsupported country codes and it should not generate any user.
    ...              Utilize 'Test Template' function of Robot Framework
    [Template]  Unsupported Country Codes
    :FOR    ${item}    IN    @{UNSUPPORTED_COUNTRY_CODES}
    \     ${item}

User Has Failed To Generate A User Using None Existent Country Code
    [Documentation]  This will test unsupported country codes not generating any user.
    ...              Used gherkin syntax for this test case.
    ...              API Request: http://localhost/generate
    ...              Body { locale="XX" }
    Given POST Request Of Invalid Country Code Sent To /generate Using JSON Parameter  ${NONE_EXISTENT_COUNTRY_CODE}
    When Response Returns Ok Status
    Then Response Message Should Not Be 'user generated'

User Has Failed To Generate A User Using Null Country Code
    [Documentation]  This will test how the endpoint handle when passing null values.
    ...              Used gherkin syntax.
    ...              API Request: http://localhost/generate
    ...              Body { locale= ""}
    Given POST Request Of Null Country Code Sent To /generate Using JSON Parameter  ${BLANK_COUNTRY_CODE}
    When Response Returns Ok Status
    Then Response Message Should Not Be 'user generated'

User Has Failed To Generate A User Using Invalid Parameter
    [Documentation]  This will test how the endpoint will handle when using incorrect parameter.
    ...              Used 'abcd' instead of 'locale'
    ...              API Request: http://localhost/generate
    ...              Body { abcd="AL" }
    Given POST Request Of Valid Country Code Sent To /generate Using Invalid JSON Parameter  ${VALID_COUNTRY_CODE}
    When Response Returns Internal Server Status
    Then Response Message Should Not Be 'user not generated'