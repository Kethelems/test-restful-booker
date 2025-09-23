*** Keywords ***
Validar Tempo de Resposta
    [Arguments]    ${response}    ${max_time_ms}=2000
    [Documentation]    Valida se o tempo de resposta está dentro do limite aceitável
    ${elapsed_ms}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Should Be True    ${elapsed_ms} < ${max_time_ms}    Tempo de resposta muito alto: ${elapsed_ms}ms
    Log    Tempo de resposta: ${elapsed_ms}ms

Gerar Dados de Teste Dinamicos
    [Arguments]    ${prefix}=Test
    [Documentation]    Gera dados únicos para cada execução de teste
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${random_number}=    Evaluate    random.randint(1000, 9999)    modules=random
    ${firstname}=    Set Variable    ${prefix}_${timestamp}
    ${lastname}=    Set Variable    User_${random_number}
    ${price}=    Evaluate    random.randint(100, 1000)    modules=random
    RETURN    ${firstname}    ${lastname}    ${price}

Criar Reserva Com Dados Dinamicos
    [Documentation]    Cria reserva com dados únicos para evitar conflitos
    ${firstname}    ${lastname}    ${price}=    Gerar Dados de Teste Dinamicos
    ${bookingdates}=    Create Dictionary    checkin=2024-01-15    checkout=2024-01-20
    ${booking}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${price}
    ...    depositpaid=${True}
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Breakfast
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    restful_booker    /booking    json=${booking}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Validar Tempo de Resposta    ${response}
    ${booking_id}=    Set Variable    ${response.json()['bookingid']}
    RETURN    ${booking_id}    ${booking}

Validar Schema de Resposta Booking
    [Arguments]    ${response_json}
    [Documentation]    Validação completa do schema da resposta
    Should Contain    ${response_json}    firstname
    Should Contain    ${response_json}    lastname
    Should Contain    ${response_json}    totalprice
    Should Contain    ${response_json}    depositpaid
    Should Contain    ${response_json}    bookingdates
    Should Be String    ${response_json['firstname']}
    Should Be String    ${response_json['lastname']}
    Should Be True    isinstance($response_json['totalprice'], (int, float))
    Should Be True    isinstance($response_json['depositpaid'], bool)
    Should Contain    ${response_json['bookingdates']}    checkin
    Should Contain    ${response_json['bookingdates']}    checkout
    Should Match Regexp    ${response_json['bookingdates']['checkin']}    \\d{4}-\\d{2}-\\d{2}
    Should Match Regexp    ${response_json['bookingdates']['checkout']}    \\d{4}-\\d{2}-\\d{2}