*** Settings ***
Documentation    Testes de Cenários Negativos da API Restful Booker
Library          RequestsLibrary
Library          Collections
Library          JSONLibrary
Library          String

Resource         ../resources/variables.robot
Resource         ../resources/keywords_booking.robot
Resource         ../resources/keywords_auth.robot
Resource         ../resources/keywords_advanced.robot

Suite Setup      Create Session    restful_booker    ${BASE_URL}
Suite Teardown   Delete All Sessions

*** Test Cases ***
Test Negative 01 - Buscar Reserva Inexistente
    [Documentation]    Tenta buscar uma reserva com ID que não existe
    [Tags]    negative    booking    error
    ${response}=    GET On Session    restful_booker    /booking/999999    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404

Test Negative 02 - Criar Reserva com Dados Inválidos
    [Documentation]    Tenta criar reserva com dados malformados
    [Tags]    negative    booking    validation
    ${invalid_booking}=    Create Dictionary
    ...    firstname=${EMPTY}
    ...    lastname=${EMPTY}
    ...    totalprice=abc
    ...    depositpaid=maybe
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    restful_booker    /booking    json=${invalid_booking}    headers=${headers}    expected_status=any
    Should Not Be Equal As Strings    ${response.status_code}    200

Test Negative 03 - Atualizar Reserva sem Autenticação
    [Documentation]    Tenta atualizar reserva sem token de autenticação
    [Tags]    negative    booking    auth
    ${booking_id}=    Criar Reserva de Teste
    ${update_data}=    Create Dictionary    firstname=Hacker
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    restful_booker    /booking/${booking_id}    json=${update_data}    headers=${headers}    expected_status=403
    Should Be Equal As Strings    ${response.status_code}    403
    Deletar Reserva de Teste    ${booking_id}

Test Negative 04 - Autenticação com Credenciais Inválidas
    [Documentation]    Testa autenticação com credenciais incorretas
    [Tags]    negative    auth    security
    ${invalid_auth}=    Create Dictionary    username=hacker    password=wrongpass
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    restful_booker    /auth    json=${invalid_auth}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${auth_response}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${auth_response['reason']}    Bad credentials