<div align="center">

# Sistema Bancário - Java Web

![Java](https://img.shields.io/badge/Java-17-orange)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Database-red)
![Maven](https://img.shields.io/badge/Maven-Build-blue)
![Architecture](https://img.shields.io/badge/Architecture-MVC-green)
![SOLID](https://img.shields.io/badge/Design-SOLID-purple)
![Status](https://img.shields.io/badge/Status-Academic%20Project-yellow)
![License](https://img.shields.io/badge/License-Academic-lightgrey)

</div>

Projeto acadêmico de sistema bancário web com Java, Servlet/JSP e SQL Server.  
A aplicação foi estruturada em camadas (`Controller`, `Service`, `Persistence` e `Model`) e combina validações na aplicação com regras no banco de dados, por meio de stored procedures e constraints.

![](docs/telas/index.png)

## Visão Geral

O sistema permite gerenciar clientes, agências e contas bancárias em um fluxo completo de operações administrativas e de cliente autenticado, incluindo conta conjunta com segundo titular.

## Funcionalidades

![](docs/telas/painel-cliente.png)

### Módulo de Clientes

- **Cadastro de cliente**: cria cliente com CPF, nome e senha.
- **Busca por CPF**: consulta dados de um cliente existente.
- **Login de cliente**: autentica o usuário e libera acesso ao painel.
- **Atualização de senha**: altera senha com validações de formato.
- **Exclusão de cliente**: remove cliente conforme regras de negócio.
- **Painel do cliente**: exibe dados do cliente logado e suas contas, com ações diretas sobre as contas.

### Módulo de Agências

- **Cadastro de agência**: registra agência com vínculo a uma instituição bancária.
- **Busca por ID**: consulta dados de uma agência específica.
- **Atualização de agência**: altera os dados cadastrados.
- **Exclusão de agência**: remove agência, respeitando integridade referencial.
- **Listagem de agências**: exibe todas as agências cadastradas.

### Módulo de Contas

- **Abertura de conta corrente**.
- **Abertura de conta poupança**.
- **Busca de conta por código**.
- **Listagem de contas por cliente (CPF)**.
- **Atualização de saldo**.
- **Atualização de limite de crédito (conta corrente)**.
- **Atualização de rendimento (conta poupança)**.
- **Atualização de dia de aniversário (conta poupança)**.
- **Exclusão de conta**.
- **Adição de segundo titular (conta conjunta)**.

## Regras de Negócio

- O código da conta é formado por:
  código da agência + últimos 3 dígitos do CPF do titular.
  Em conta conjunta, o código deve considerar os últimos 3 dígitos dos dois titulares.
  Ao final, é concatenado um dígito verificador.
- O dígito verificador é calculado pela soma de todos os dígitos do código parcial e aplicação de módulo 5 (`soma % 5`), considerando apenas o resto inteiro da divisão.
- A senha do cliente é definida pelo usuário e deve ter exatamente 8 caracteres, com pelo menos 3 caracteres numéricos.
- Clientes com contas conjuntas não podem ser excluídos da base.
- O sistema permite atualizar apenas:
  senha do cliente, saldo da conta, limite de crédito e percentual de rendimento da poupança.
  Os demais atributos não podem ser atualizados.
- Um novo cliente deve informar seus dados e o tipo de conta desejado.
  A conta é criada com saldo inicial zero e, para conta corrente, limite de crédito inicial de 500,00.
  Para conta poupança, o dia de aniversário padrão é 10 e o rendimento inicial é 1%.
- Uma conta conjunta sempre começa com o cadastro de um único titular.
- Para incluir companheiro(a) em conta conjunta, a conta deve existir e já ter titular cadastrado.
  A inclusão exige autenticação do titular atual (login e senha) para autorização.
- Não é permitido incluir companheiro(a) em conta conjunta com saldo menor ou igual a zero, salvo quando a conta foi criada no mesmo dia.

## Tecnologias

- Java 17
- Jakarta Servlet / JSP
- JDBC (jTDS)
- SQL Server
- Maven (`mvnw`)
- Bootstrap 5

## Arquitetura

Fluxo principal:

`JSP -> Servlet -> Service -> DAO -> Stored Procedure -> SQL Server`

Camadas:

- `model`: entidades de domínio
- `controller`: entrada HTTP e navegação
- `service`: validações e regras de negócio
- `persistence`: acesso a dados e mapeamento
- `webapp/views`: interface JSP

## Modelagem

O projeto contém:

- Diagrama ER

![](docs/entityRelationshipDiagram/entityRelationshipDiagram.png)

- Diagrama de Classes

![](docs/classDiagram/classDiagram.png)

## Como Executar

1. Configure o banco com os scripts em `sql/`:

- `01_create_database.sql`
- `02_create_tables.sql`
- `03_stored_procedures.sql`
- `04_testes.sql`

2. Ajuste conexão em:

`src/main/java/com/lamego/sistema_bancario/persistence/GenericDAO.java`

3. Compile:

```bash
./mvnw clean compile
```

4. Gere o pacote:

```bash
./mvnw clean package
```

## Observações

- O projeto não possui foco em segurança da informação. Por esse motivo, não há criptografia de senhas no estado atual da aplicação.
- Operações financeiras bancárias reais (como transferências, TED/PIX, pagamento de boletos, extrato financeiro completo ou liquidação contábil) não são consideradas no escopo deste projeto.
- O fluxo de instituição bancária não está exposto como módulo completo no front-end.
- Projeto desenvolvido para fins didáticos na disciplina de Laboratório de Banco de Dados.

