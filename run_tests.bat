@echo off
echo ========================================
echo  Robot Framework - Restful Booker Tests
echo  Melhorado com Amazon Q
echo ========================================

echo Instalando dependencias...
pip install -r requirements.txt

echo.
echo Executando testes de health check...
robot -d results -i health test-restful-booker/tests/health_check.robot

echo.
echo Executando testes de performance...
robot -d results -i performance test-restful-booker/tests/performance_tests.robot

echo.
echo Executando testes negativos...
robot -d results -i negative test-restful-booker/tests/negative_tests.robot

echo.
echo Executando suite de integracao...
robot -d results -i integration test-restful-booker/tests/integration_suite.robot

echo.
echo ========================================
echo  Execucao completa!
echo  Resultados em: results/
echo ========================================
pause