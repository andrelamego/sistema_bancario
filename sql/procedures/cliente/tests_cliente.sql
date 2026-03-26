-- INSERTS VALIDOS --
EXEC sp_insert_cliente
    @cpf = '12345678901',
    @nome = 'Andre Lamego',
    @senha = 'abc12345';
GO

EXEC sp_insert_cliente
    @cpf = '98765432100',
    @nome = 'Julia Jorge',
    @senha = 'xy9123za';
GO

EXEC sp_insert_cliente
    @cpf = '11122233344',
    @nome = 'Murillo Reis',
    @senha = 'm123n456';
GO

-- INSERT INVALIDO POR CPF
EXEC sp_insert_cliente
    @cpf = '12345678901',
    @nome = 'Cliente Duplicado',
    @senha = 'abc12345';
GO

-- INSERT INVALIDO POR SENHA CURTA
EXEC sp_insert_cliente
    @cpf = '55566677788',
    @nome = 'Teste Curto',
    @senha = 'abc12';
GO
 -- INSERT INVALIDO POR SENHA COM POUCOS NUMEROS
EXEC sp_insert_cliente
    @cpf = '99988877766',
    @nome = 'Teste Letras',
    @senha = 'abcdef1g';
GO

-- SELECTS 
EXEC sp_select_cliente
    @cpf = '12345678901';
GO

EXEC sp_select_clientes;
GO

-- LOGIN VALIDO
EXEC sp_login_cliente
    @cpf = '12345678901',
    @senha = 'abc12345';
GO

-- LOGIN INVALIDO
EXEC sp_login_cliente
    @cpf = '12345678901',
    @senha = 'zzz99999';
GO

-- UPDATE DE SENHA VALIDO
EXEC sp_update_senha_cliente
    @cpf = '12345678901',
    @nova_senha = 'nova1234';
GO

-- LOGIN COM SENHA NOVA
EXEC sp_login_cliente
    @cpf = '12345678901',
    @senha = 'nova1234';
GO

-- UPDATE COM SENHA INVALIDA
EXEC sp_update_senha_cliente
    @cpf = '12345678901',
    @nova_senha = 'abcdefff';
GO

-- TENTAR EXCLUIR CLIENTE COM CONTA CONJUNTA
EXEC sp_delete_cliente
    @cpf = '12345678901';
GO

EXEC sp_delete_cliente
    @cpf = '11122233344';
GO

-- TENTAR EXCLUIR SEM CONTA CONJUNTA
EXEC sp_delete_cliente
    @cpf = '98765432100';
GO