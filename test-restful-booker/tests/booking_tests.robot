*** Settings ***
Documentation    Testes de Booking da API
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
Test 02 - Listar Todas as Reservas
    ${response}=    GET On Session    restful_booker    /booking
    Should Be Equal As Strings    ${response.status_code}    200
    ${bookings}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${bookings}
    Log    Total de reservas: ${bookings.__len__()}

Test 03 - Listar Reservas com Filtros
    ${params}=    Create Dictionary    firstname=Sally    lastname=Brown
    ${response}=    GET On Session    restful_booker    /booking    params=${params}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Reservas filtradas: ${response.json()}

Test 04 - Criar Nova Reserva
    ${booking_data}=    Criar Corpo de Reserva Valido
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    restful_booker    /booking    json=${booking_data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${booking_response}=    Set Variable    ${response.json()}
    Set Global Variable    ${BOOKING_ID}    ${booking_response['bookingid']}
    Log    Nova reserva criada com ID: ${BOOKING_ID}

Test 05 - Buscar Reserva por ID
    ${BOOKING_ID}=    Criar Reserva de Teste
    ${booking}=    Buscar Booking Por ID    ${BOOKING_ID}
    Validar Estrutura da Resposta de Booking    ${booking}
    Validar Dados da Reserva    ${booking}    Kethelem    Socoowski    200
    Deletar Reserva de Teste    ${BOOKING_ID}

Test 09 - Deletar Reserva
    ${BOOKING_ID}=    Criar Reserva de Teste
    ${AUTH_TOKEN}=    Gerar Token de Teste
    ${headers}=    Criar Headers Com Autenticacao    ${AUTH_TOKEN}
    ${response}=    DELETE On Session    restful_booker    /booking/${BOOKING_ID}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.text}    Created
