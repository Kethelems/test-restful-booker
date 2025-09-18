*** Settings ***
Documentation    Testes de Autenticação da API
Library          RequestsLibrary
Library          Collections
Library          JSONLibrary
Library          String

Resource         ../resources/variables.robot
Resource         ../resources/keywords_auth.robot

Suite Setup      Create Session    restful_booker    ${BASE_URL}
Suite Teardown   Delete All Sessions

*** Test Cases ***
Test 06 - Gerar Token de Autenticação
    ${AUTH_TOKEN}=    Gerar Token de Teste
    Set Global Variable    ${AUTH_TOKEN}
    Log    Token de autenticação gerado: ${AUTH_TOKEN}

Test 10 - Teste de Autenticação Inválida
    ${invalid_auth}=    Create Dictionary    username=invalid    password=wrong
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    restful_booker    /auth    json=${invalid_auth}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${auth_response}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${auth_response['reason']}    Bad credentials
