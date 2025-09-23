*** Settings ***
Documentation    Testes de remoção de reservas
Library          RequestsLibrary
Library          Collections
Library          JSONLibrary
Library          String

Resource         ../resources/variables.robot
Resource         ../resources/keywords_booking.robot
Resource         ../resources/keywords_auth.robot

Suite Setup      Create Session    restful_booker    ${BASE_URL}
Suite Teardown   Delete All Sessions

*** Test Cases ***
Test 09 - Deletar Reserva
    [Documentation]    Remove uma reserva existente
    [Tags]    booking    delete    auth
    ${BOOKING_ID}=    Criar Reserva de Teste
    ${AUTH_TOKEN}=    Gerar Token de Teste
    ${headers}=    Criar Headers Com Autenticacao    ${AUTH_TOKEN}
    ${response}=    DELETE On Session    restful_booker    /booking/${BOOKING_ID}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.text}    Created
