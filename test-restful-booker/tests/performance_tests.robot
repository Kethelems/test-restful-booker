*** Settings ***
Documentation    Testes de Performance da API Restful Booker
Library          RequestsLibrary
Library          Collections
Library          DateTime

Resource         ../resources/variables.robot
Resource         ../resources/keywords_booking.robot
Resource         ../resources/keywords_auth.robot

Suite Setup      Create Session    restful_booker    ${BASE_URL}
Suite Teardown   Delete All Sessions

*** Test Cases ***
Test Performance 01 - Tempo de Resposta Health Check
    [Documentation]    Verifica se o health check responde rapidamente
    [Tags]    performance    health
    ${start_time}=    Get Current Date    result_format=epoch
    ${response}=    GET On Session    restful_booker    /ping
    ${end_time}=    Get Current Date    result_format=epoch
    ${elapsed_ms}=    Evaluate    (${end_time} - ${start_time}) * 1000
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be True    ${elapsed_ms} < 2000    Tempo de resposta muito alto: ${elapsed_ms}ms
    Log    Tempo de resposta: ${elapsed_ms}ms

Test Performance 02 - Carga na Listagem de Reservas
    [Documentation]    Testa a performance da listagem com múltiplas requisições
    [Tags]    performance    load
    FOR    ${i}    IN RANGE    10
        ${response}=    GET On Session    restful_booker    /booking
        Should Be Equal As Strings    ${response.status_code}    200
    END