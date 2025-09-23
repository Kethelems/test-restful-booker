*** Settings ***
Documentation    Testes de Atualização da API
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
Test 07 - Atualizar Reserva Completa (PUT)
    ${BOOKING_ID}=    Criar Reserva de Teste
    ${AUTH_TOKEN}=    Gerar Token de Teste
    ${bookingdates}=    Create Dictionary    checkin=2024-02-10    checkout=2024-02-15
    ${updated_booking}=    Create Dictionary
    ...    firstname=Kethelem
    ...    lastname=Socoowski
    ...    totalprice=350
    ...    depositpaid=${False}
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Dinner
    ${headers}=    Criar Headers Com Autenticacao    ${AUTH_TOKEN}
    ${response}=    PUT On Session    restful_booker    /booking/${BOOKING_ID}    json=${updated_booking}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${booking}=    Set Variable    ${response.json()}
    Validar Dados da Reserva    ${booking}    Kethelem    Socoowski    350
    Should Be Equal    ${booking['depositpaid']}    ${False}
    Deletar Reserva de Teste    ${BOOKING_ID}

Test 08 - Atualização Parcial da Reserva (PATCH)
    ${BOOKING_ID}=    Criar Reserva de Teste
    ${AUTH_TOKEN}=    Gerar Token de Teste
    ${partial_update}=    Create Dictionary    firstname=Carlos    totalprice=500
    ${headers}=    Criar Headers Com Autenticacao    ${AUTH_TOKEN}
    ${response}=    PATCH On Session    restful_booker    /booking/${BOOKING_ID}    json=${partial_update}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${booking}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${booking['firstname']}    Carlos
    Should Be Equal As Numbers    ${booking['totalprice']}    500
    Deletar Reserva de Teste    ${BOOKING_ID}

Test 11 - Teste de Operação sem Autenticação
    ${BOOKING_ID}=    Criar Reserva de Teste
    ${update_data}=    Create Dictionary    firstname=TesteFalha
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    restful_booker    /booking/${BOOKING_ID}    json=${update_data}    headers=${headers}    expected_status=403
    Should Be Equal As Strings    ${response.status_code}    403
    Deletar Reserva de Teste    ${BOOKING_ID}