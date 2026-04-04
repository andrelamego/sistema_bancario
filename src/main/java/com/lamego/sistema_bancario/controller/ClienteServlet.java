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
import java.sql.SQLException;
import java.util.List;

@WebServlet("/cliente")
public class ClienteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ClienteService clienteService;
    private ContaService contaService;

    @Override
    public void init() throws ServletException {
        this.clienteService = new ClienteService();
        this.contaService = new ContaService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String acao = request.getParameter("acao");
        if ("sair".equals(acao)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        if ("painel".equals(acao)) {
            carregarPainelCliente(request);
            request.getRequestDispatcher("views/cliente/painel.jsp").forward(request, response);
            return;
        }
        String view = resolveViewByAction(acao);
        request.getRequestDispatcher(view).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String saida = "";
        String erro = "";
        String returnUrl = request.getParameter("returnUrl");
        boolean fromPainel = "true".equals(request.getParameter("fromPainel"));

        String cmd = request.getParameter("button");
        Cliente cliente = null;
        String view = resolveViewByCommand(cmd);

        try {
            cliente = validaCampos(cmd, request);

            if (cmd != null && cmd.contains("Cadastrar")) {
                if (cliente != null) {
                    clienteService.cadastrarCliente(cliente);
                    saida = "Cliente cadastrado com sucesso.";
                    cliente = null;
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Atualizar")) {
                if (cliente != null && cliente.getCpf() != null && cliente.getSenha() != null) {
                    clienteService.atualizarSenhaCliente(cliente.getCpf(), cliente.getSenha());
                    saida = "Senha atualizada com sucesso.";
                    cliente = null;
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Excluir")) {
                if (cliente != null && cliente.getCpf() != null) {
                    clienteService.excluirCliente(cliente.getCpf());
                    saida = "Cliente excluido com sucesso.";
                    if (fromPainel) {
                        HttpSession session = request.getSession(false);
                        if (session != null) {
                            session.invalidate();
                        }
                        response.sendRedirect(request.getContextPath() + "/");
                        return;
                    }
                    cliente = null;
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Buscar")) {
                if (cliente != null && cliente.getCpf() != null) {
                    cliente = clienteService.buscarCliente(cliente.getCpf());
                    if (cliente == null) {
                        erro = "Cliente nao encontrado.";
                    } else {
                        saida = "Cliente encontrado.";
                    }
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Login")) {
                if (cliente != null && cliente.getCpf() != null && cliente.getSenha() != null) {
                    Cliente clienteLogado = clienteService.loginCliente(cliente.getCpf(), cliente.getSenha());
                    if (clienteLogado != null) {
                        HttpSession session = request.getSession();
                        session.setAttribute("clienteLogado", clienteLogado);
                        session.setAttribute("contaAutenticado", true);
                        saida = "Login realizado com sucesso.";
                        cliente = clienteLogado;
                        view = "views/cliente/painel.jsp";
                        carregarPainelCliente(request);
                    } else {
                        erro = "CPF ou senha invalidos.";
                    }
                } else {
                    erro = "Preencha os campos !";
                }
            }
        } catch (IllegalArgumentException | SQLException e) {
            erro = e.getMessage();
            if (fromPainel && cmd != null && cmd.contains("Excluir")) {
                view = "views/cliente/painel.jsp";
                carregarPainelCliente(request);
            }
        } finally {
            if (response.isCommitted()) {
                return;
            }
            if (!isBlank(saida) && isBlank(erro) && !isBlank(returnUrl) && cmd != null && cmd.contains("Atualizar")) {
                response.sendRedirect(returnUrl);
                return;
            }
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(view);
            request.setAttribute("cliente", cliente);
            request.setAttribute("saida", saida);
            request.setAttribute("erro", erro);
            requestDispatcher.forward(request, response);
        }
    }

    private String resolveViewByAction(String acao) {
        if (acao == null || acao.isBlank()) {
            return "views/cliente/cliente.jsp";
        }
        switch (acao) {
            case "cadastrar":
                return "views/cliente/cadastrar.jsp";
            case "buscar":
                return "views/cliente/buscar.jsp";
            case "atualizar":
                return "views/cliente/atualizar.jsp";
            case "excluir":
                return "views/cliente/excluir.jsp";
            case "login":
                return "views/cliente/login.jsp";
            case "painel":
                return "views/cliente/painel.jsp";
            default:
                return "views/cliente/cliente.jsp";
        }
    }

    private String resolveViewByCommand(String cmd) {
        if (cmd == null || cmd.isBlank()) {
            return "views/cliente/cliente.jsp";
        }
        if (cmd.contains("Cadastrar")) {
            return "views/cliente/cadastrar.jsp";
        }
        if (cmd.contains("Buscar")) {
            return "views/cliente/buscar.jsp";
        }
        if (cmd.contains("Atualizar")) {
            return "views/cliente/atualizar.jsp";
        }
        if (cmd.contains("Excluir")) {
            return "views/cliente/excluir.jsp";
        }
        if (cmd.contains("Login")) {
            return "views/cliente/login.jsp";
        }
        return "views/cliente/cliente.jsp";
    }

    private Cliente validaCampos(String cmd, HttpServletRequest request) {
        if (cmd == null || cmd.isBlank()) {
            return null;
        }

        if (cmd.contains("Cadastrar")) {
            String cpfParam = request.getParameter("cpf");
            String nomeParam = request.getParameter("nome");
            String senhaParam = request.getParameter("senha");

            if (isBlank(cpfParam) || isBlank(nomeParam) || isBlank(senhaParam)) {
                return null;
            }

            Cliente cliente = new Cliente();
            cliente.setCpf(cpfParam.trim());
            cliente.setNome(nomeParam.trim());
            cliente.setSenha(senhaParam.trim());
            return cliente;
        }

        if (cmd.contains("Atualizar") || cmd.contains("Login")) {
            String cpfParam = request.getParameter("cpf");
            String senhaParam = request.getParameter("senha");

            if (isBlank(cpfParam) || isBlank(senhaParam)) {
                return null;
            }

            Cliente cliente = new Cliente();
            cliente.setCpf(cpfParam.trim());
            cliente.setSenha(senhaParam.trim());
            return cliente;
        }

        if (cmd.contains("Excluir") || cmd.contains("Buscar")) {
            String cpfParam = request.getParameter("cpf");
            if (isBlank(cpfParam)) {
                return null;
            }

            Cliente cliente = new Cliente();
            cliente.setCpf(cpfParam.trim());
            return cliente;
        }

        return null;
    }

    private void carregarPainelCliente(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("clienteLogado") == null) {
            request.setAttribute("erro", "Realize login para acessar o painel do cliente.");
            return;
        }
        Cliente clienteLogado = (Cliente) session.getAttribute("clienteLogado");
        request.setAttribute("cliente", clienteLogado);
        try {
            List<ContaBancaria> contas = contaService.listarContasCliente(clienteLogado.getCpf());
            request.setAttribute("contas", contas);
        } catch (SQLException e) {
            request.setAttribute("erro", e.getMessage());
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
