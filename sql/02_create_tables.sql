USE bd_sistema_bancario
GO

CREATE TABLE instituicao_bancaria
(
    id_instituicao BIGINT       NOT NULL,
    nome           VARCHAR(100) NOT NULL,
    CONSTRAINT pk_instituicao_bancaria PRIMARY KEY (id_instituicao)
)

CREATE TABLE agencia
(
    id_agencia     BIGINT       NOT NULL,
    codigo         VARCHAR(6)   NOT NULL,
    cep            VARCHAR(8)   NOT NULL,
    cidade         VARCHAR(100) NOT NULL,
    id_instituicao BIGINT       NOT NULL,
    CONSTRAINT pk_agencia PRIMARY KEY (id_agencia),
    CONSTRAINT uq_agencia_codigo UNIQUE (codigo),
    CONSTRAINT fk_agencia_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicao_bancaria (id_instituicao)
)

CREATE TABLE conta_bancaria
(
    codigo_conta  VARCHAR(20) UNIQUE NOT NULL,
    data_abertura DATE               NOT NULL,
    saldo         DECIMAL(12, 2)     NOT NULL,
    id_agencia    BIGINT             NOT NULL,
    CONSTRAINT pk_conta_bancaria PRIMARY KEY (codigo_conta),
    CONSTRAINT ck_conta_bancaria_saldo CHECK (saldo >= 0),
    CONSTRAINT fk_conta_bancaria_agencia FOREIGN KEY (id_agencia) REFERENCES agencia (id_agencia)
)

CREATE TABLE conta_corrente
(
    codigo_conta   VARCHAR(20)    NOT NULL,
    limite_credito DECIMAL(12, 2) NOT NULL,
    CONSTRAINT pk_conta_corrente PRIMARY KEY (codigo_conta),
    CONSTRAINT ck_conta_corrente_limite CHECK (limite_credito >= 0),
    CONSTRAINT fk_conta_corrente_conta FOREIGN KEY (codigo_conta) REFERENCES conta_bancaria (codigo_conta)
)

CREATE TABLE conta_poupanca
(
    codigo_conta          VARCHAR(20)   NOT NULL,
    percentual_rendimento DECIMAL(5, 2) NOT NULL,
    dia_aniversario       INT           NOT NULL,
    CONSTRAINT pk_conta_poupanca PRIMARY KEY (codigo_conta),
    CONSTRAINT ck_conta_poupanca_rendimento CHECK (percentual_rendimento >= 0),
    CONSTRAINT ck_conta_poupanca_dia CHECK (dia_aniversario BETWEEN 1 AND 31),
    CONSTRAINT fk_conta_poupanca_conta FOREIGN KEY (codigo_conta) REFERENCES conta_bancaria (codigo_conta)
)

CREATE TABLE cliente
(
    cpf                 CHAR(11) UNIQUE NOT NULL,
    nome                VARCHAR(100)    NOT NULL,
    data_primeira_conta DATE            NULL,
    senha               CHAR(8)         NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (cpf),
    CONSTRAINT ck_cliente_senha_tamanho CHECK (LEN(senha) = 8)
)

CREATE TABLE titularidade
(
    codigo_conta  VARCHAR(20) NOT NULL,
    cpf_cliente   CHAR(11)    NOT NULL,
    ordem_titular INT         NOT NULL,
    CONSTRAINT pk_titularidade PRIMARY KEY (codigo_conta, cpf_cliente),
    CONSTRAINT uq_titularidade_conta_ordem UNIQUE (codigo_conta, ordem_titular),
    CONSTRAINT ck_titularidade_ordem CHECK (ordem_titular IN (1, 2)),
    CONSTRAINT fk_titularidade_conta FOREIGN KEY (codigo_conta) REFERENCES conta_bancaria (codigo_conta),
    CONSTRAINT fk_titularidade_cliente FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf)
)

INSERT INTO instituicao_bancaria (id_instituicao, nome) VALUES (1, 'Banco do Brasil');
INSERT INTO instituicao_bancaria (id_instituicao, nome) VALUES (2, 'Banco Inter');
INSERT INTO instituicao_bancaria (id_instituicao, nome) VALUES (3, 'Banco Santander');
INSERT INTO instituicao_bancaria (id_instituicao, nome) VALUES (4, 'Banco Bradesco');