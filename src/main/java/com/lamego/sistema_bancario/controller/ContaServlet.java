package com.lamego.sistema_bancario.controller;

import com.lamego.sistema_bancario.model.Cliente;
import com.lamego.sistema_bancario.model.ContaBancaria;
import com.lamego.sistema_bancario.service.ClienteService;
import com.lamego.sistema_bancario.service.ContaService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/conta")
public class ContaServlet extends HttpServlet {

    // SOLID (SRP): servlet atua como adaptador web, enquanto regras de conta ficam em ContaService.
    private static final long serialVersionUID = 1L;
    private ContaService contaService;
    private ClienteService clienteService;

    @Override
    public void init() throws ServletException {
        this.contaService = new ContaService();
        this.clienteService = new ClienteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String acao = request.getParameter("acao");

        if (acao == null || acao.isBlank()) {
            request.getRequestDispatcher("views/conta/login.jsp").forward(request, response);
            return;
        }

        if ("login".equals(acao)) {
            request.getRequestDispatcher("views/conta/login.jsp").forward(request, response);
            return;
        }

        if ("sair".equals(acao)) {
            request.getSession().removeAttribute("contaAutenticado");
            request.setAttribute("saida", "Sessao de contas encerrada.");
            request.getRequestDispatcher("views/conta/login.jsp").forward(request, response);
            return;
        }

        if (!isContaAutenticado(request)) {
            request.setAttribute("erro", "Realize login para acessar operacoes de conta.");
            request.getRequestDispatcher("views/conta/login.jsp").forward(request, response);
            return;
        }

        String view = resolveViewByAction(acao);
        if ("views/conta/conta.jsp".equals(view)) {
            carregarContasDoClienteLogado(request);
        }
        request.getRequestDispatcher(view).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String saida = "";
        String erro = "";
        String returnUrl = request.getParameter("returnUrl");

        String cmd = request.getParameter("button");
        String view = resolveViewByCommand(cmd);
        ContaInput input = null;
        ContaBancaria conta = null;
        List<ContaBancaria> contas = null;

        try {
                if (cmd != null && cmd.contains("Login Conta")) {
                String cpf = request.getParameter("cpf");
                String senha = request.getParameter("senha");
                Cliente clienteLogado = clienteService.loginCliente(cpf, senha);
                    if (clienteLogado == null) {
                        erro = "CPF ou senha invalidos.";
                    } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("clienteLogado", clienteLogado);
                        session.setAttribute("contaAutenticado", true);
                        saida = "Acesso ao modulo de contas liberado.";
                        view = "views/conta/conta.jsp";
                        carregarContasDoClienteLogado(request);
                    }
                } else {
                if (!isContaAutenticado(request)) {
                    erro = "Realize login para acessar operacoes de conta.";
                    view = "views/conta/login.jsp";
                } else {
                    input = validaCampos(cmd, request);

                    if (cmd != null && cmd.contains("Abrir Conta Corrente")) {
                        if (input != null && input.cpfCliente != null && input.idAgencia != null) {
                            String codigoConta = contaService.cadastrarContaCorrente(input.cpfCliente, input.idAgencia);
                            saida = "Conta corrente criada com codigo: " + codigoConta;
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Abrir Conta Poupanca")) {
                        if (input != null && input.cpfCliente != null && input.idAgencia != null) {
                            String codigoConta = contaService.cadastrarContaPoupanca(input.cpfCliente, input.idAgencia);
                            saida = "Conta poupanca criada com codigo: " + codigoConta;
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Excluir")) {
                        if (input != null && input.codigoConta != null) {
                            contaService.excluirConta(input.codigoConta);
                            saida = "Conta excluida com sucesso.";
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Buscar")) {
                        if (input != null && input.codigoConta != null) {
                            conta = contaService.buscarConta(input.codigoConta);
                            if (conta == null) {
                                erro = "Conta nao encontrada.";
                            } else {
                                saida = "Conta encontrada.";
                            }
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Listar Contas")) {
                        if (input != null && input.cpfCliente != null) {
                            contas = contaService.listarContasCliente(input.cpfCliente);
                            saida = "Consulta realizada.";
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Atualizar Saldo")) {
                        if (input != null && input.codigoConta != null && input.valor != null) {
                            contaService.atualizarSaldoConta(input.codigoConta, input.valor);
                            saida = "Saldo atualizado com sucesso.";
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Atualizar Limite")) {
                        if (input != null && input.codigoConta != null && input.valor != null) {
                            contaService.atualizarLimiteCredito(input.codigoConta, input.valor);
                            saida = "Limite atualizado com sucesso.";
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Atualizar Rendimento")) {
                        if (input != null && input.codigoConta != null && input.valor != null) {
                            contaService.atualizarRendimentoPoupanca(input.codigoConta, input.valor);
                            saida = "Rendimento atualizado com sucesso.";
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Atualizar Dia Aniversario")) {
                        if (input != null && input.codigoConta != null && input.diaAniversario != null) {
                            contaService.atualizarDiaAniversarioPoupanca(input.codigoConta, input.diaAniversario);
                            saida = "Dia de aniversario atualizado com sucesso.";
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }

                    if (cmd != null && cmd.contains("Adicionar Segundo Titular")) {
                        if (input != null && input.codigoConta != null && input.cpfTitularAtual != null
                                && input.senhaTitularAtual != null && input.cpfNovoTitular != null) {
                            contaService.adicionarSegundoTitular(
                                    input.codigoConta,
                                    input.cpfTitularAtual,
                                    input.senhaTitularAtual,
                                    input.cpfNovoTitular
                            );
                            saida = "Segundo titular adicionado com sucesso.";
                        } else {
                            erro = "Preencha os campos !";
                        }
                    }
                }
            }
        } catch (IllegalArgumentException | SQLException e) {
            erro = e.getMessage();
        } finally {
            if (deveRedirecionarParaRetorno(cmd, saida, erro, returnUrl)) {
                response.sendRedirect(returnUrl);
                return;
            }
            if ("views/conta/conta.jsp".equals(view)) {
                carregarContasDoClienteLogado(request);
            }
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(view);
            request.setAttribute("conta", conta);
            if (contas != null) {
                request.setAttribute("contas", contas);
            }
            request.setAttribute("saida", saida);
            request.setAttribute("erro", erro);
            requestDispatcher.forward(request, response);
        }
    }

    private void carregarContasDoClienteLogado(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("clienteLogado") == null) {
            return;
        }
        Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
        try {
            List<ContaBancaria> contas = contaService.listarContasCliente(cliente.getCpf());
            request.setAttribute("contas", contas);
        } catch (SQLException e) {
            request.setAttribute("erro", e.getMessage());
        }
    }

    private void carregarContaSelecionada(HttpServletRequest request, String codigoConta) {
        if (isBlank(codigoConta)) {
            return;
        }
        try {
            ContaBancaria contaSelecionada = contaService.buscarConta(codigoConta.trim());
            if (contaSelecionada == null) {
                request.setAttribute("erro", "Conta nao encontrada.");
                return;
            }
            request.setAttribute("contaSelecionada", contaSelecionada);
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("erro", e.getMessage());
        }
    }

    private boolean deveRedirecionarParaRetorno(String cmd, String saida, String erro, String returnUrl) {
        if (isBlank(cmd) || isBlank(saida) || !isBlank(erro) || isBlank(returnUrl)) {
            return false;
        }
        return cmd.contains("Abrir Conta Corrente")
                || cmd.contains("Abrir Conta Poupanca")
                || cmd.contains("Excluir")
                || cmd.contains("Adicionar Segundo Titular")
                || cmd.contains("Atualizar Saldo")
                || cmd.contains("Atualizar Limite")
                || cmd.contains("Atualizar Rendimento")
                || cmd.contains("Atualizar Dia Aniversario");
    }

    private boolean isContaAutenticado(HttpServletRequest request) {
        Object autenticado = request.getSession().getAttribute("contaAutenticado");
        return autenticado instanceof Boolean && (Boolean) autenticado;
    }

    private String resolveViewByAction(String acao) {
        switch (acao) {
            case "menu":
                return "views/conta/conta.jsp";
            case "abrirCorrente":
                return "views/conta/abrir-corrente.jsp";
            case "abrirPoupanca":
                return "views/conta/abrir-poupanca.jsp";
            case "buscar":
                return "views/conta/buscar.jsp";
            case "listar":
                return "views/conta/listar.jsp";
            case "atualizarConta":
                return "views/conta/atualizar-conta.jsp";
            case "atualizarSaldo":
                return "views/conta/atualizar-conta.jsp";
            case "atualizarLimite":
                return "views/conta/atualizar-conta.jsp";
            case "atualizarRendimento":
                return "views/conta/atualizar-conta.jsp";
            case "atualizarDia":
                return "views/conta/atualizar-conta.jsp";
            case "segundoTitular":
                return "views/conta/segundo-titular.jsp";
            case "excluir":
                return "views/conta/excluir.jsp";
            default:
                return "views/conta/login.jsp";
        }
    }

    private String resolveViewByCommand(String cmd) {
        if (cmd == null || cmd.isBlank()) {
            return "views/conta/login.jsp";
        }
        if (cmd.contains("Login Conta")) {
            return "views/conta/login.jsp";
        }
        if (cmd.contains("Abrir Conta Corrente")) {
            return "views/conta/abrir-corrente.jsp";
        }
        if (cmd.contains("Abrir Conta Poupanca")) {
            return "views/conta/abrir-poupanca.jsp";
        }
        if (cmd.contains("Buscar")) {
            return "views/conta/buscar.jsp";
        }
        if (cmd.contains("Listar Contas")) {
            return "views/conta/listar.jsp";
        }
        if (cmd.contains("Atualizar Saldo")) {
            return "views/conta/atualizar-conta.jsp";
        }
        if (cmd.contains("Atualizar Limite")) {
            return "views/conta/atualizar-conta.jsp";
        }
        if (cmd.contains("Atualizar Rendimento")) {
            return "views/conta/atualizar-conta.jsp";
        }
        if (cmd.contains("Atualizar Dia Aniversario")) {
            return "views/conta/atualizar-conta.jsp";
        }
        if (cmd.contains("Adicionar Segundo Titular")) {
            return "views/conta/segundo-titular.jsp";
        }
        if (cmd.contains("Excluir")) {
            return "views/conta/excluir.jsp";
        }
        return "views/conta/conta.jsp";
    }

    private ContaInput validaCampos(String cmd, HttpServletRequest request) {
        if (cmd == null || cmd.isBlank()) {
            return null;
        }

        ContaInput input = new ContaInput();

        if (cmd.contains("Abrir Conta Corrente") || cmd.contains("Abrir Conta Poupanca")) {
            String cpfClienteParam = request.getParameter("cpfCliente");
            String idAgenciaParam = request.getParameter("idAgencia");

            if (isBlank(cpfClienteParam) || isBlank(idAgenciaParam)) {
                return null;
            }

            Long idAgencia = parseLongSafe(idAgenciaParam.trim());
            if (idAgencia == null || idAgencia <= 0) {
                return null;
            }

            input.cpfCliente = cpfClienteParam.trim();
            input.idAgencia = idAgencia;
            return input;
        }

        if (cmd.contains("Excluir") || cmd.contains("Buscar")) {
            String codigoContaParam = request.getParameter("codigoConta");
            if (isBlank(codigoContaParam)) {
                return null;
            }

            input.codigoConta = codigoContaParam.trim();
            return input;
        }

        if (cmd.contains("Listar Contas")) {
            String cpfClienteParam = request.getParameter("cpfCliente");
            if (isBlank(cpfClienteParam)) {
                return null;
            }

            input.cpfCliente = cpfClienteParam.trim();
            return input;
        }

        if (cmd.contains("Atualizar Saldo") || cmd.contains("Atualizar Limite") || cmd.contains("Atualizar Rendimento")) {
            String codigoContaParam = request.getParameter("codigoConta");
            String valorParam = request.getParameter("valor");

            if (isBlank(codigoContaParam) || isBlank(valorParam)) {
                return null;
            }

            BigDecimal valor = parseBigDecimalSafe(valorParam.trim());
            if (valor == null) {
                return null;
            }

            input.codigoConta = codigoContaParam.trim();
            input.valor = valor;
            return input;
        }

        if (cmd.contains("Atualizar Dia Aniversario")) {
            String codigoContaParam = request.getParameter("codigoConta");
            String diaParam = request.getParameter("dia");

            if (isBlank(codigoContaParam) || isBlank(diaParam)) {
                return null;
            }

            Integer dia = parseIntegerSafe(diaParam.trim());
            if (dia == null) {
                return null;
            }

            input.codigoConta = codigoContaParam.trim();
            input.diaAniversario = dia;
            return input;
        }

        if (cmd.contains("Adicionar Segundo Titular")) {
            String codigoContaParam = request.getParameter("codigoConta");
            String cpfTitularAtualParam = request.getParameter("cpfTitularAtual");
            String senhaTitularAtualParam = request.getParameter("senhaTitularAtual");
            String cpfNovoTitularParam = request.getParameter("cpfNovoTitular");

            if (isBlank(codigoContaParam) || isBlank(cpfTitularAtualParam)
                    || isBlank(senhaTitularAtualParam) || isBlank(cpfNovoTitularParam)) {
                return null;
            }

            input.codigoConta = codigoContaParam.trim();
            input.cpfTitularAtual = cpfTitularAtualParam.trim();
            input.senhaTitularAtual = senhaTitularAtualParam.trim();
            input.cpfNovoTitular = cpfNovoTitularParam.trim();
            return input;
        }

        return null;
    }

    private Long parseLongSafe(String value) {
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseIntegerSafe(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal parseBigDecimalSafe(String value) {
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private static class ContaInput {
        private String cpfCliente;
        private Long idAgencia;
        private String codigoConta;
        private BigDecimal valor;
        private Integer diaAniversario;
        private String cpfTitularAtual;
        private String senhaTitularAtual;
        private String cpfNovoTitular;
    }
}
