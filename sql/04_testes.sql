/* =========================================================
   LIMPEZA INICIAL
========================================================= */
DELETE FROM titularidade;
DELETE FROM conta_corrente;
DELETE FROM conta_poupanca;
DELETE FROM conta_bancaria;
DELETE FROM cliente;
DELETE FROM agencia;
DELETE FROM instituicao_bancaria;
GO


/* =========================================================
   TESTES - INSTITUICAO BANCARIA
========================================================= */

-- TESTE 1: insert válido
EXEC sp_insert_instituicao_bancaria
     @id_instituicao = 1,
     @nome = 'Banco FATEC'
GO

-- TESTE 2: insert válido
EXEC sp_insert_instituicao_bancaria
     @id_instituicao = 2,
     @nome = 'Banco Centro'
GO

-- TESTE 3: insert duplicado
EXEC sp_insert_instituicao_bancaria
     @id_instituicao = 1,
     @nome = 'Banco Duplicado'
GO

-- TESTE 4: select unitário
EXEC sp_select_instituicao_bancaria
     @id_instituicao = 1;
GO

-- TESTE 5: select geral
EXEC sp_select_instituicoes_bancarias;
GO

-- TESTE 6: update válido
EXEC sp_update_instituicao_bancaria
     @id_instituicao = 1,
     @nome = 'Banco FATEC Atualizado'
GO

-- TESTE 7: select após update
EXEC sp_select_instituicao_bancaria
     @id_instituicao = 1;
GO


/* =========================================================
   TESTES - AGENCIA
========================================================= */

-- TESTE 8: insert válido
EXEC sp_insert_agencia
     @id_agencia = 1,
     @codigo = '0001',
     @cep = '08230000',
     @cidade = 'Sao Paulo',
     @id_instituicao = 1;
GO

-- TESTE 9: insert válido
EXEC sp_insert_agencia
     @id_agencia = 2,
     @codigo = '0002',
     @cep = '08240000',
     @cidade = 'Guarulhos',
     @id_instituicao = 1;
GO

-- TESTE 10: insert com instituição inexistente
EXEC sp_insert_agencia
     @id_agencia = 3,
     @codigo = '0003',
     @cep = '08250000',
     @cidade = 'Osasco',
     @id_instituicao = 99;
GO

-- TESTE 11: insert com código duplicado
EXEC sp_insert_agencia
     @id_agencia = 4,
     @codigo = '0001',
     @cep = '08235555',
     @cidade = 'Santo Andre',
     @id_instituicao = 1;
GO

-- TESTE 12: select unitário
EXEC sp_select_agencia
     @id_agencia = 1;
GO

-- TESTE 13: select geral
EXEC sp_select_agencias;
GO

-- TESTE 14: update válido
EXEC sp_update_agencia
     @id_agencia = 1,
     @codigo = '0001',
     @cep = '08231111',
     @cidade = 'Sao Paulo',
     @id_instituicao = 1;
GO

-- TESTE 15: select após update
EXEC sp_select_agencia
     @id_agencia = 1;
GO


/* =========================================================
   TESTES - CLIENTE
========================================================= */

-- TESTE 16: insert válido
EXEC sp_insert_cliente
     @cpf = '12345678901',
     @nome = 'Andre Lamego',
     @senha = 'abc12345';
GO

-- TESTE 17: insert válido
EXEC sp_insert_cliente
     @cpf = '98765432100',
     @nome = 'Julia Jorge',
     @senha = 'xy9123za';
GO

-- TESTE 18: insert válido
EXEC sp_insert_cliente
     @cpf = '11122233344',
     @nome = 'Murillo Reis',
     @senha = 'm123n456';
GO

-- TESTE 19: CPF duplicado
EXEC sp_insert_cliente
     @cpf = '12345678901',
     @nome = 'Cliente Duplicado',
     @senha = 'abc12345';
GO

-- TESTE 20: senha inválida por tamanho
EXEC sp_insert_cliente
     @cpf = '55566677788',
     @nome = 'Teste Curto',
     @senha = 'abc12';
GO

-- TESTE 21: senha inválida por poucos números
EXEC sp_insert_cliente
     @cpf = '99988877766',
     @nome = 'Teste Letras',
     @senha = 'abcdef1g';
GO

-- TESTE 22: select unitário
EXEC sp_select_cliente
     @cpf = '12345678901';
GO

-- TESTE 23: select geral
EXEC sp_select_clientes;
GO

-- TESTE 24: login válido
EXEC sp_login_cliente
     @cpf = '12345678901',
     @senha = 'abc12345';
GO

-- TESTE 25: login inválido
EXEC sp_login_cliente
     @cpf = '12345678901',
     @senha = 'zzz99999';
GO

-- TESTE 26: update senha válido
EXEC sp_update_senha_cliente
     @cpf = '12345678901',
     @nova_senha = 'nova1234';
GO

-- TESTE 27: login com senha nova
EXEC sp_login_cliente
     @cpf = '12345678901',
     @senha = 'nova1234';
GO

-- TESTE 28: update senha inválida
EXEC sp_update_senha_cliente
     @cpf = '12345678901',
     @nova_senha = 'abcdefff';
GO


/* =========================================================
   TESTES - CONTA CORRENTE
========================================================= */

-- TESTE 29: insert conta corrente válida
EXEC sp_insert_conta_corrente
     @cpf_cliente = '12345678901',
     @id_agencia = 1;
GO

-- TESTE 30: insert conta corrente para cliente inexistente
EXEC sp_insert_conta_corrente
     @cpf_cliente = '00000000000',
     @id_agencia = 1;
GO

-- TESTE 31: insert conta corrente para agência inexistente
EXEC sp_insert_conta_corrente
     @cpf_cliente = '12345678901',
     @id_agencia = 99;
GO


/* =========================================================
   TESTES - CONTA POUPANCA
========================================================= */

-- TESTE 32: insert conta poupança válida
EXEC sp_insert_conta_poupanca
     @cpf_cliente = '98765432100',
     @id_agencia = 1;
GO

-- TESTE 33: visualizar contas criadas
SELECT * FROM conta_bancaria;
SELECT * FROM conta_corrente;
SELECT * FROM conta_poupanca;
SELECT * FROM titularidade;
GO


/* =========================================================
   TESTES - SELECT CONTA
========================================================= */

-- TESTE 34: select conta específica
EXEC sp_select_conta
     @codigo_conta = 'COD_CONTA_1';
GO

-- TESTE 35: select contas do cliente Andre
EXEC sp_select_contas_cliente
     @cpf_cliente = '12345678901';
GO

-- TESTE 36: select contas da Julia
EXEC sp_select_contas_cliente
     @cpf_cliente = '98765432100';
GO


/* =========================================================
   TESTES - UPDATE CONTA
========================================================= */

-- TESTE 37: update saldo válido
EXEC sp_update_saldo_conta
     @codigo_conta = 'COD_CONTA_1',
     @novo_saldo = 250.00;
GO

-- TESTE 38: update saldo inválido
EXEC sp_update_saldo_conta
     @codigo_conta = 'COD_CONTA_1',
     @novo_saldo = -10.00;
GO

-- TESTE 39: update limite válido
EXEC sp_update_limite_credito
     @codigo_conta = 'COD_CONTA_1',
     @novo_limite = 1000.00;
GO

-- TESTE 40: update limite em conta não corrente
EXEC sp_update_limite_credito
     @codigo_conta = 'COD_CONTA_2',
     @novo_limite = 1000.00;
GO

-- TESTE 41: update rendimento válido
EXEC sp_update_rendimento_poupanca
     @codigo_conta = 'COD_CONTA_2',
     @novo_percentual = 1.50;
GO

-- TESTE 42: update rendimento em conta não poupança
EXEC sp_update_rendimento_poupanca
     @codigo_conta = 'COD_CONTA_1',
     @novo_percentual = 2.00;
GO

-- TESTE 43: update dia aniversário válido
EXEC sp_update_dia_aniversario_poupanca
     @codigo_conta = 'COD_CONTA_2',
     @novo_dia = 15;
GO

-- TESTE 44: update dia aniversário inválido
EXEC sp_update_dia_aniversario_poupanca
     @codigo_conta = 'COD_CONTA_2',
     @novo_dia = 40;
GO


/* =========================================================
   TESTES - CONTA CONJUNTA
========================================================= */

-- TESTE 45: adicionar segundo titular válido
EXEC sp_add_segundo_titular
     @codigo_conta = 'COD_CONTA_1',
     @cpf_titular_atual = '12345678901',
     @senha_titular_atual = 'nova1234',
     @cpf_novo_titular = '11122233344';
GO

-- TESTE 46: verificar titulares da conta
SELECT *
FROM titularidade
WHERE codigo_conta = 'COD_CONTA_1';
GO

-- TESTE 47: tentar adicionar terceiro titular
EXEC sp_add_segundo_titular
     @codigo_conta = 'COD_CONTA_1',
     @cpf_titular_atual = '12345678901',
     @senha_titular_atual = 'nova1234',
     @cpf_novo_titular = '98765432100';
GO

-- TESTE 48: senha incorreta
EXEC sp_add_segundo_titular
     @codigo_conta = 'COD_CONTA_2',
     @cpf_titular_atual = '98765432100',
     @senha_titular_atual = 'senhaerr',
     @cpf_novo_titular = '11122233344';
GO

-- TESTE 49: cliente já titular da conta
EXEC sp_add_segundo_titular
     @codigo_conta = 'COD_CONTA_1',
     @cpf_titular_atual = '12345678901',
     @senha_titular_atual = 'nova1234',
     @cpf_novo_titular = '11122233344';
GO


/* =========================================================
   TESTES - DELETE CLIENTE
========================================================= */

-- TESTE 50: excluir cliente com conta conjunta
EXEC sp_delete_cliente
     @cpf = '12345678901';
GO

-- TESTE 51: excluir segundo titular da conta conjunta
EXEC sp_delete_cliente
     @cpf = '11122233344';
GO


/* =========================================================
   TESTES - DELETE CONTA
========================================================= */

-- TESTE 52: delete conta poupanca válida
EXEC sp_delete_conta
     @codigo_conta = 'COD_CONTA_2';
GO

-- TESTE 53: conferir remoção
SELECT * FROM conta_bancaria WHERE codigo_conta = 'COD_CONTA_2';
SELECT * FROM conta_poupanca WHERE codigo_conta = 'COD_CONTA_2';
SELECT * FROM titularidade WHERE codigo_conta = 'COD_CONTA_2';
GO

-- TESTE 54: delete conta inexistente
EXEC sp_delete_conta
     @codigo_conta = 'CONTA_INEXISTENTE';
GO


/* =========================================================
   TESTES - DELETE AGENCIA / INSTITUICAO
========================================================= */

-- TESTE 55: tentar excluir agência com conta vinculada
EXEC sp_delete_agencia
     @id_agencia = 1;
GO

-- TESTE 56: tentar excluir instituição com agência vinculada
EXEC sp_delete_instituicao_bancaria
     @id_instituicao = 1;
GO


/* =========================================================
   LIMPEZA FINAL PARA TESTAR DELETES COMPLETOS
========================================================= */

-- TESTE 57: apagar conta conjunta
EXEC sp_delete_conta
     @codigo_conta = 'COD_CONTA_1';
GO

-- TESTE 58: excluir cliente Andre
EXEC sp_delete_cliente
     @cpf = '12345678901';
GO

-- TESTE 59: excluir cliente Murillo
EXEC sp_delete_cliente
     @cpf = '11122233344';
GO

-- TESTE 60: excluir cliente Julia
EXEC sp_delete_cliente
     @cpf = '98765432100';
GO

-- TESTE 61: excluir agência 1
EXEC sp_delete_agencia
     @id_agencia = 1;
GO

-- TESTE 62: excluir agência 2
EXEC sp_delete_agencia
     @id_agencia = 2;
GO

-- TESTE 63: excluir instituição 1
EXEC sp_delete_instituicao_bancaria
     @id_instituicao = 1;
GO

-- TESTE 64: excluir instituição 2
EXEC sp_delete_instituicao_bancaria
     @id_instituicao = 2;
GO


/* =========================================================
   CONFERENCIA FINAL
========================================================= */
SELECT * FROM instituicao_bancaria;
SELECT * FROM agencia;
SELECT * FROM cliente;
SELECT * FROM conta_bancaria;
SELECT * FROM conta_corrente;
SELECT * FROM conta_poupanca;
SELECT * FROM titularidade;
GO