-- =============== CONTA CORRENTE ===============

-- INSERT VALIDO
EXEC sp_insert_conta_corrente
    @cpf_cliente = '12345678901',
    @id_agencia = 1;
GO

-- INSERT PARA CONTA CORRENTE INEXISTENTE
EXEC sp_insert_conta_corrente
    @cpf_cliente = '00000000000',
    @id_agencia = 1;
GO

-- INSERT PARA AGENCIA INEXISTENTE
EXEC sp_insert_conta_corrente
    @cpf_cliente = '12345678901',
    @id_agencia = 99;
GO

SELECT * FROM conta_bancaria;
SELECT * FROM conta_corrente;
SELECT * FROM titularidade;
GO

-- =============== CONTA POUPANCA ===============

-- INSERT VALIDO
EXEC sp_insert_conta_poupanca
    @cpf_cliente = '98765432100',
    @id_agencia = 1;
GO

SELECT * FROM conta_bancaria;
SELECT * FROM conta_poupanca;
SELECT * FROM titularidade;
GO

-- =============== SELECTS E UPDATES ===============

-- SELECT CONTA ESPECIFICA
EXEC sp_select_conta
    @codigo_conta = '00011002';
GO

-- SELECT CONTAS DO CLIENTE
EXEC sp_select_contas_cliente
    @cpf_cliente = '12345678901';
GO

EXEC sp_select_contas_cliente
    @cpf_cliente = '98765432100';
GO

-- UPDATE SALDO VALIDO
EXEC sp_update_saldo_conta
    @codigo_conta = '00019011',
    @novo_saldo = 250.00;
GO

-- UPDATE SALDO INVALIDO
EXEC sp_update_saldo_conta
    @codigo_conta = '00019011',
    @novo_saldo = -10.00;
GO

-- UPDATE LIMITE VALIDO
EXEC sp_update_limite_credito
    @codigo_conta = '00019011',
    @novo_limite = 1000.00;
GO

-- UPDATE LIMITE EM CONTA NÃO CORRENTE
EXEC sp_update_limite_credito
    @codigo_conta = '00011002',
    @novo_limite = 1000.00;
GO

-- UPDATE RENDIMENTO VALIDO
EXEC sp_update_rendimento_poupanca
    @codigo_conta = '00011002',
    @novo_percentual = 1.50;
GO

-- UPDATE RENDIMENTO EM CONTA NAO POUPANCA
EXEC sp_update_rendimento_poupanca
    @codigo_conta = '00019011',
    @novo_percentual = 2.00;
GO

-- UPDATE ANIVERSARIO VALIDO
EXEC sp_update_dia_aniversario_poupanca
    @codigo_conta = '00011002',
    @novo_dia = 15;
GO

-- UPDATE ANIVERSARIO INVALIDO
EXEC sp_update_dia_aniversario_poupanca
    @codigo_conta = '00011002',
    @novo_dia = 40;
GO

-- =============== CONTA CONJUNTA ===============

-- CASO VALIDO
EXEC sp_add_segundo_titular
    @codigo_conta = '00019011',
    @cpf_titular_atual = '12345678901',
    @senha_titular_atual = 'nova1234',
    @cpf_novo_titular = '11122233344';
GO

-- VER TITULARES
SELECT * FROM titularidade
WHERE codigo_conta = '00019011';
GO

-- TENTAR ADD TERCEIRO TITULAR
EXEC sp_add_segundo_titular
    @codigo_conta = '00019011',
    @cpf_titular_atual = '12345678901',
    @senha_titular_atual = 'nova1234',
    @cpf_novo_titular = '98765432100';
GO

-- SENHA INCORRETA
EXEC sp_add_segundo_titular
    @codigo_conta = '00011002',
    @cpf_titular_atual = '98765432100',
    @senha_titular_atual = 'senhaerr',
    @cpf_novo_titular = '11122233344';
GO

-- CLIENTE JA TITULAR DA CONTA
EXEC sp_add_segundo_titular
    @codigo_conta = '00019011',
    @cpf_titular_atual = '12345678901',
    @senha_titular_atual = 'nova1234',
    @cpf_novo_titular = '11122233344';
GO

-- =============== DELETES ===============

-- DELETE VALIDO
EXEC sp_delete_conta
    @codigo_conta = '00011002';
GO

-- DELETE CODIGO INVALIDO
EXEC sp_delete_conta
    @codigo_conta = 'CONTA_INEXISTENTE';
GO