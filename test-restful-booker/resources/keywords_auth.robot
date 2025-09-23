*** Keywords ***
Gerar Token de Teste
    [Documentation]    Gera token de autenticação para testes
    ${auth_data}=    Create Dictionary    username=admin    password=password123
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    restful_booker    /auth    json=${auth_data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${token}=    Set Variable    ${response.json()['token']}
    RETURN    ${token}

Criar Headers Com Autenticacao
    [Arguments]    ${token}
    [Documentation]    Cria headers com token de autenticação
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${token}
    RETURN    ${headers}

Validar Token Gerado
    [Arguments]    ${token}
    [Documentation]    Valida se o token foi gerado corretamente
    Should Not Be Empty    ${token}
    Should Not Be Equal    ${token}    ${None}
    ${token_length}=    Get Length    ${token}
    Should Be True    ${token_length} > 10    Token muito curto: ${token}
