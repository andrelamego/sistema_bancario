-- INSERT VALIDO
EXEC sp_insert_agencia
    @id_agencia = 1,
    @codigo = '0001',
    @cep = '08230000',
    @cidade = 'Sao Paulo',
    @id_instituicao = 1;
GO

EXEC sp_insert_agencia
    @id_agencia = 2,
    @codigo = '0002',
    @cep = '08240000',
    @cidade = 'Guarulhos',
    @id_instituicao = 1;
GO

-- INSERT COM INSTITUICAO INEXISTENTE
EXEC sp_insert_agencia
    @id_agencia = 3,
    @codigo = '0003',
    @cep = '08250000',
    @cidade = 'Osasco',
    @id_instituicao = 99;
GO

-- INSERT COM CODIGO DUPLICADO
EXEC sp_insert_agencia
    @id_agencia = 4,
    @codigo = '0001',
    @cep = '08235555',
    @cidade = 'Santo Andre',
    @id_instituicao = 1;
GO

-- SELECTS
EXEC sp_select_agencia
    @id_agencia = 1;
GO

EXEC sp_select_agencias;
GO

-- UPDATE
EXEC sp_update_agencia
    @id_agencia = 1,
    @codigo = '0001',
    @cep = '08231111',
    @cidade = 'Sao Paulo',
    @id_instituicao = 1;
GO

-- DELETE
EXEC sp_delete_agencia
    @id_agencia = 2;
GO