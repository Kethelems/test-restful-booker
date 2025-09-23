*** Settings ***
Documentation    Suite de Integração - Executa cenários completos da API
Library          RequestsLibrary
Library          Collections
Library          JSONLibrary
Library          String
Library          DateTime

Resource         ../resources/variables.robot
Resource         ../resources/keywords_booking.robot
Resource         ../resources/keywords_auth.robot
Resource         ../resources/keywords_advanced.robot

Suite Setup      Create Session    restful_booker    ${BASE_URL}
Suite Teardown   Delete All Sessions

*** Test Cases ***
Integration Test 01 - Fluxo Completo de Reserva
    [Documentation]    Testa o fluxo completo: criar, buscar, atualizar e deletar reserva
    [Tags]    integration    booking    full_flow
    
    # Criar reserva com dados dinâmicos
    ${booking_id}    ${original_booking}=    Criar Reserva Com Dados Dinamicos
    Log    Reserva criada com ID: ${booking_id}
    
    # Buscar e validar reserva criada
    ${booking}=    Buscar Booking Por ID    ${booking_id}
    Validar Schema de Resposta Booking    ${booking}
    Should Be Equal As Strings    ${booking['firstname']}    ${original_booking['firstname']}
    
    # Atualizar reserva
    ${token}=    Gerar Token de Teste
    ${headers}=    Criar Headers Com Autenticacao    ${token}
    ${update_data}=    Create Dictionary    firstname=Updated    totalprice=500
    ${response}=    PATCH On Session    restful_booker    /booking/${booking_id}    json=${update_data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    
    # Verificar atualização
    ${updated_booking}=    Buscar Booking Por ID    ${booking_id}
    Should Be Equal As Strings    ${updated_booking['firstname']}    Updated
    Should Be Equal As Numbers    ${updated_booking['totalprice']}    500
    
    # Deletar reserva
    Deletar Reserva de Teste    ${booking_id}

Integration Test 02 - Teste de Segurança Básica
    [Documentation]    Verifica aspectos básicos de segurança da API
    [Tags]    integration    security    auth
    
    # Criar reserva para testes de segurança
    ${booking_id}=    Criar Reserva de Teste
    
    # Tentar operações sem autenticação
    ${update_data}=    Create Dictionary    firstname=Hacker
    ${headers}=    Create Dictionary    Content-Type=application/json
    
    # PUT sem auth deve falhar
    ${response}=    PUT On Session    restful_booker    /booking/${booking_id}    json=${update_data}    headers=${headers}    expected_status=403
    Should Be Equal As Strings    ${response.status_code}    403
    
    # DELETE sem auth deve falhar
    ${response}=    DELETE On Session    restful_booker    /booking/${booking_id}    headers=${headers}    expected_status=403
    Should Be Equal As Strings    ${response.status_code}    403
    
    # Verificar que a reserva não foi alterada
    ${booking}=    Buscar Booking Por ID    ${booking_id}
    Should Not Be Equal As Strings    ${booking['firstname']}    Hacker
    
    # Limpeza com autenticação adequada
    Deletar Reserva de Teste    ${booking_id}