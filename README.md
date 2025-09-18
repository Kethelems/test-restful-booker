# Testes de API - Restful-Booker

Este repositório contém testes automatizados da API https://restful-booker.herokuapp.com/ usando Robot Framework.

## Estrutura do Projeto
```
test-restful-booker/
├─ .gitignore
├─ tests/
│ ├─ auth_tests.robot
│ ├─ booking_tests.robot
│ ├─ delete_tests.robot
│ ├─ health_check.robot
│ └─ update_tests.robot
├─ resources/
│ ├─ keywords_auth.robot
│ ├─ keywords_booking.robot
│ └─ variables.robot
```
- tests/ → Contém os casos de teste.
- resources/ → Contém palavras-chave e variáveis reutilizáveis.
- .gitignore → Ignora arquivos de saída do Robot Framework (output.xml, log.html, report.html) e outros arquivos desnecessários.
- README.md → Documentação do projeto.

## Pré-requisitos
```
- Python 3.x
- Robot Framework
- RequestsLibrary
- JSONLibrary
- String
```
## Como Executar os Testes

1. Instale os pacotes necessários:
```
   pip install robotframework
   pip install robotframework-requests
   pip install robotframework-jsonlibrary
   pip install robotframework-string
```
2. Navegue até a pasta do projeto:
```
   cd test-restful-booker
```
3. Execute todos os testes:
```
   robot tests/
```
4. Os relatórios serão gerados automaticamente:
```
- log.html
- report.html
- output.xml
```
## Observações

- As saídas do Robot Framework estão ignoradas pelo Git através do `.gitignore`.
- Todos os testes foram organizados nas pastas `tests` e `resources`.
