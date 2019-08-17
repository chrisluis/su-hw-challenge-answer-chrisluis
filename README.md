# Set up the environment
Answers for Sum Up challenge for Test Analyst applicants

**Docker Image**
```
docker pull chrisluis/su-hw-challenge-chrisluis
```

## How to run the test script

**Set the environment**

1. Clone and go to the root directory: https://github.com/ugobriasco/su-hw-challenge-2019-08-14_1
Run the command
```
docker-compose up
```
2. Pull the docker image
```
docker pull chrisluis/su-hw-challenge-chrisluis
```
**Run the test**
```
docker run --network=host su-hw-challenge-chrisluis bash -c "./run_test.sh"
```
The shell script will use the host machine *localhost:3000* network.

3. After running the script successfully. It will generate a comprehensive test report. However container don't save the 
generated test result. You can view a sample of test result by cloning this repository then go to **Results** folder.
Open log.html using your browser.

## About the test strategy and test cases

**Supported country codes**
- Checked the responses of JSON keys for it's NULL values. There shouldn't be any.
- Validates if passed country code is the same with the country code from the JSON responses.

```
AL AR AM AU AT AZ BD BE BA BR BZ BG CA CL CN CO CR DK EG GB EE FI FR GE DE GR HU IN IR IL IT JP KR MX MA NP NL NZ NG NO PK PL PT RO RU SA SK SI ES SE CH TR UA US VN
```
**Unsupported country codes**

Gathered all country that should not generate a user since it is not part of the scope.
- Validates if the response message is not 'user generated'

```
AF  DZ  AS  AD  AO  AI  AQ  AG  AW  BS  BH  BB  BY  BJ  BM  BT  BO  BQ  BW  BV  IO  BN  BF  BI  KH  CM  CV  KY  CF  TD  CX  CC  KM  CG  CD  CK  HR  CU  CW  CY  CZ  CI  DJ  DM  DO  EC  SV  GQ  ER  ET  FK  FO  FJ  GF  PF   TF  GA  GM  GH  GI  GL  GD  GP  GU  GT  GG  GN  GW  GY  HT  HM  VA  HN  HK  IS   ID  IQ  IE  IM  JM  JE  JO  KZ  KE  KI  KP  KW  KG  LA  LV  LB  LS  LR  LY  LI   LT  LU  MO  MK  MG  MW  MY  MV  ML  MT  MH  MQ  MR  MU  YT  FM  MD  MC  MN  ME  MS  MZ  MM  NA  NR  NC  NI  NE  NU  NF  MP  OM  PW  PS  PA  PG  PY  PE  PH  PN  PR  QA  RW  RE  BL  SH  KN  LC  MF  PM  VC  WS  SM  ST  SN  RS  SC  SL  SG  SX SB  SO  ZA  GS  SS  LK  SD  SR  SJ  SZ  SY  TW  TJ  TZ  TH  TL  TG  TK  TO  TN  TR  TM  TC  TV  UG  AE  UM  UY  UZ  VU  VE  VG  VI  WF  EH  YE  ZM  ZW

```

**Also checks how the endpoint will handle blank value passed on it.**

**Checks how the endpoint will handle if the JSON key of the post request body is not supported (not locale)**

```
Generate Supported Country Code User With No Null Values On Response
    [Documentation]  This test case will run ALL supported country codes.
    ...              Since this is a list, I've utilize the 'Test Template' function of Robot Framework
    ...              This will checks if the status code returns 200.
    ...              This will also check if the JSON response has no NULL values.

Verify Unsupported Country Code Not Generating User
    [Documentation]  This will test ALL unsupported country codes and it should not generate any user.
    ...              Utilize 'Test Template' function of Robot Framework

User Has Failed To Generate A User Using None Existent Country Code
    [Documentation]  This will test unsupported country codes not generating any user.
    ...              Used gherkin syntax for this test case.
    ...              API Request: http://localhost/generate
    ...              Body { locale="XX" }

User Has Failed To Generate A User Using Null Country Code
    [Documentation]  This will test how the endpoint handle when passing null values.
    ...              Used gherkin syntax.
    ...              API Request: http://localhost/generate
    ...              Body { locale= ""}

User Has Failed To Generate A User Using Invalid Parameter
    [Documentation]  This will test how the endpoint will handle when using incorrect parameter.
    ...              Used 'abcd' instead of 'locale'
    ...              API Request: http://localhost/generate
    ...              Body { abcd="AL" }

```

## The test result

1 out 5 test cases passed.
Issues found:
  - ALL SUPPORTED country codes returns NULL values in one or more JSON keys. (181 out of 935 JSON keys returns null values) 
  - UNSUPPORTED country codes generates a user (193 out of 193 unsupported country codes generated a user)
  - NULL value passed to Request BODY generates a user
  - Invalid country code generates a user
  

### Tools used
- Postman
- Robot Framework
