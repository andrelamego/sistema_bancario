<%@ page import="com.lamego.sistema_bancario.model.InstituicaoBancaria" %>
<%@ page import="com.lamego.sistema_bancario.service.InstituicaoBancariaService" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<InstituicaoBancaria> instituicoes = new ArrayList<>();
    String erroInstituicoes = null;
    try {
        instituicoes = new InstituicaoBancariaService().listarInstituicoesBancarias();
    } catch (Exception e) {
        erroInstituicoes = e.getMessage();
    }
    request.setAttribute("instituicoes", instituicoes);
    request.setAttribute("erroInstituicoes", erroInstituicoes);
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="includes/header.jsp" />

<section class="p-4 p-lg-5 mb-4 rounded-4 hero-panel">
    <h1 class="display-6 fw-bold mb-2">Sistema Bancário</h1>
    <p class="lead mb-0">Sistema de cadastro de Clientes, Contas e Agências</p>
</section>

<div class="row g-4">
    <div class="col-lg-6">
        <div class="card soft-panel h-100">
            <div class="card-body">
                <h2 class="h5 fw-bold mb-3"><i class="bi bi-people me-2"></i>Clientes</h2>
                <div class="d-grid gap-2">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/cliente?acao=cadastrar">Cadastrar</a>
                    <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/cliente?acao=login">Login</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="card soft-panel h-100">
            <div class="card-body">
                <h2 class="h5 fw-bold mb-3"><i class="bi bi-building me-2"></i>Agencias</h2>
                <div class="d-grid gap-2">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/agencia?acao=cadastrar">Cadastrar</a>
                    <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/agencia?acao=buscar">Buscar</a>
                    <a class="btn btn-outline-warning" href="${pageContext.request.contextPath}/agencia?acao=atualizar">Atualizar</a>
                    <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/agencia?acao=excluir">Excluir</a>
                    <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/agencia?acao=listar">Listar todas</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card soft-panel mt-4">
    <div class="card-body">
        <h2 class="h5 mb-3"><i class="bi bi-bank me-2"></i>Instituicoes bancarias cadastradas</h2>
        <c:if test="${not empty erroInstituicoes}">
            <div class="alert alert-danger mb-0">${erroInstituicoes}</div>
        </c:if>
        <c:if test="${empty erroInstituicoes}">
            <div class="table-responsive">
                <table class="table table-striped mb-0">
                    <thead><tr><th>ID</th><th>Nome</th></tr></thead>
                    <tbody>
                    <c:forEach var="instituicao" items="${instituicoes}">
                        <tr>
                            <td>${instituicao.id}</td>
                            <td>${instituicao.nome}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty instituicoes}">
                        <tr><td colspan="2" class="text-center text-muted">Nenhuma instituicao encontrada.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
