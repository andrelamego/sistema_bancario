package com.lamego.sistema_bancario.controller;

import com.lamego.sistema_bancario.model.Agencia;
import com.lamego.sistema_bancario.model.InstituicaoBancaria;
import com.lamego.sistema_bancario.service.AgenciaService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/agencia")
public class AgenciaServlet extends HttpServlet {

    // SOLID (SRP): controller apenas orquestra HTTP e delega regra para service.
    private static final long serialVersionUID = 1L;
    private AgenciaService agenciaService;

    @Override
    public void init() throws ServletException {
        this.agenciaService = new AgenciaService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String acao = request.getParameter("acao");
        String view = resolveViewByAction(acao);

        if ("views/agencia/listar.jsp".equals(view)) {
            carregarListaAgencias(request);
        }

        request.getRequestDispatcher(view).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String saida = "";
        String erro = "";

        String cmd = request.getParameter("button");
        Agencia agencia = null;
        String view = resolveViewByCommand(cmd);

        try {
            agencia = validaCampos(cmd, request);

            if (cmd != null && cmd.contains("Cadastrar")) {
                if (agencia != null) {
                    agenciaService.cadastrarAgencia(agencia);
                    saida = "Agencia cadastrada com sucesso.";
                    agencia = null;
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Atualizar")) {
                if (agencia != null) {
                    agenciaService.atualizarAgencia(agencia);
                    saida = "Agencia atualizada com sucesso.";
                    agencia = null;
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Excluir")) {
                if (agencia != null && agencia.getId() != null) {
                    agenciaService.excluirAgencia(agencia.getId());
                    saida = "Agencia excluida com sucesso.";
                    agencia = null;
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Buscar")) {
                if (agencia != null && agencia.getId() != null) {
                    agencia = agenciaService.buscarAgencia(agencia.getId());
                    if (agencia == null) {
                        erro = "Agencia nao encontrada.";
                    } else {
                        saida = "Agencia encontrada.";
                    }
                } else {
                    erro = "Preencha os campos !";
                }
            }

            if (cmd != null && cmd.contains("Listar")) {
                carregarListaAgencias(request);
                saida = "Lista de agencias carregada.";
            }
        } catch (IllegalArgumentException | SQLException e) {
            erro = e.getMessage();
        } finally {
            if ("views/agencia/listar.jsp".equals(view)) {
                carregarListaAgencias(request);
            }
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(view);
            request.setAttribute("agencia", agencia);
            request.setAttribute("saida", saida);
            request.setAttribute("erro", erro);
            requestDispatcher.forward(request, response);
        }
    }

    private String resolveViewByAction(String acao) {
        if (acao == null || acao.isBlank()) {
            return "views/agencia/agencia.jsp";
        }
        switch (acao) {
            case "cadastrar":
                return "views/agencia/cadastrar.jsp";
            case "buscar":
                return "views/agencia/buscar.jsp";
            case "atualizar":
                return "views/agencia/atualizar.jsp";
            case "excluir":
                return "views/agencia/excluir.jsp";
            case "listar":
                return "views/agencia/listar.jsp";
            default:
                return "views/agencia/agencia.jsp";
        }
    }

    private String resolveViewByCommand(String cmd) {
        if (cmd == null || cmd.isBlank()) {
            return "views/agencia/agencia.jsp";
        }
        if (cmd.contains("Cadastrar")) {
            return "views/agencia/cadastrar.jsp";
        }
        if (cmd.contains("Buscar")) {
            return "views/agencia/buscar.jsp";
        }
        if (cmd.contains("Atualizar")) {
            return "views/agencia/atualizar.jsp";
        }
        if (cmd.contains("Excluir")) {
            return "views/agencia/excluir.jsp";
        }
        if (cmd.contains("Listar")) {
            return "views/agencia/listar.jsp";
        }
        return "views/agencia/agencia.jsp";
    }

    private void carregarListaAgencias(HttpServletRequest request) {
        try {
            List<Agencia> agencias = agenciaService.listarAgencias();
            request.setAttribute("agencias", agencias);
        } catch (SQLException e) {
            request.setAttribute("erro", e.getMessage());
        }
    }

    private Agencia validaCampos(String cmd, HttpServletRequest request) {
        if (cmd == null || cmd.isBlank()) {
            return null;
        }

        if (cmd.contains("Cadastrar") || cmd.contains("Atualizar")) {
            String idParam = request.getParameter("id");
            String codigoParam = request.getParameter("codigo");
            String cepParam = request.getParameter("cep");
            String cidadeParam = request.getParameter("cidade");
            String idInstituicaoParam = request.getParameter("idInstituicao");

            if (isBlank(idParam) || isBlank(codigoParam) || isBlank(cepParam) || isBlank(cidadeParam) || isBlank(idInstituicaoParam)) {
                return null;
            }

            Long id = parseLongSafe(idParam.trim());
            Long idInstituicao = parseLongSafe(idInstituicaoParam.trim());

            if (id == null || id <= 0 || idInstituicao == null || idInstituicao <= 0) {
                return null;
            }

            Agencia agencia = new Agencia();
            agencia.setId(id);
            agencia.setCodigo(codigoParam.trim());
            agencia.setCep(cepParam.trim());
            agencia.setCidade(cidadeParam.trim());
            agencia.setInstituicaoBancaria(InstituicaoBancaria.builder().id(idInstituicao).build());
            return agencia;
        }

        if (cmd.contains("Excluir") || cmd.contains("Buscar")) {
            String idParam = request.getParameter("id");
            if (isBlank(idParam)) {
                return null;
            }

            Long id = parseLongSafe(idParam.trim());
            if (id == null || id <= 0) {
                return null;
            }

            Agencia agencia = new Agencia();
            agencia.setId(id);
            return agencia;
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
