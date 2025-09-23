*** Keywords ***
Criar Corpo de Reserva Valido
    [Documentation]    Cria estrutura de dados válida para reserva
    ${bookingdates}=    Create Dictionary    checkin=2024-01-15    checkout=2024-01-20
    ${booking}=    Create Dictionary
    ...    firstname=Kethelem
    ...    lastname=Socoowski
    ...    totalprice=200
    ...    depositpaid=${True}
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Breakfast
    RETURN    ${booking}

Criar Reserva de Teste
    [Documentation]    Cria uma reserva para testes e retorna o ID
    ${booking_data}=    Criar Corpo de Reserva Valido
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    restful_booker    /booking    json=${booking_data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${booking_id}=    Set Variable    ${response.json()['bookingid']}
    RETURN    ${booking_id}

Deletar Reserva de Teste
    [Arguments]    ${booking_id}
    [Documentation]    Deleta uma reserva de teste
    ${token}=    Gerar Token de Teste
    ${headers}=    Criar Headers Com Autenticacao    ${token}
    DELETE On Session    restful_booker    /booking/${booking_id}    headers=${headers}

Validar Estrutura da Resposta de Booking
    [Arguments]    ${response_json}
    [Documentation]    Valida se a resposta contém todos os campos obrigatórios
    Should Contain    ${response_json}    firstname
    Should Contain    ${response_json}    lastname
    Should Contain    ${response_json}    totalprice
    Should Contain    ${response_json}    depositpaid
    Should Contain    ${response_json}    bookingdates
    Should Contain    ${response_json['bookingdates']}    checkin
    Should Contain    ${response_json['bookingdates']}    checkout

Validar Dados da Reserva
    [Arguments]    ${booking_data}    ${expected_firstname}    ${expected_lastname}    ${expected_price}
    [Documentation]    Valida os dados específicos de uma reserva
    Should Be Equal As Strings    ${booking_data['firstname']}    ${expected_firstname}
    Should Be Equal As Strings    ${booking_data['lastname']}    ${expected_lastname}
    Should Be Equal As Numbers    ${booking_data['totalprice']}    ${expected_price}

Buscar Booking Por ID
    [Arguments]    ${booking_id}
    [Documentation]    Busca uma reserva específica pelo ID
    ${response}=    GET On Session    restful_booker    /booking/${booking_id}
    Should Be Equal As Strings    ${response.status_code}    200
    RETURN    ${response.json()}
