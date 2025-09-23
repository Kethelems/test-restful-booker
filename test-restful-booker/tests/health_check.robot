*** Settings ***
Documentation    Testes de Health Check da API
Library          RequestsLibrary
Library          Collections
Library          JSONLibrary
Library          String

Resource         ../resources/variables.robot

Suite Setup      Create Session    restful_booker    ${BASE_URL}
Suite Teardown   Delete All Sessions

*** Test Cases ***
Test 01 - Health Check da API
    [Documentation]    Verifica se a API está funcionando
    [Tags]    health    get
    ${response}=    GET On Session    restful_booker    /ping
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.text}    Created
    Log    Status: ${response.status_code} | Body: ${response.text}
