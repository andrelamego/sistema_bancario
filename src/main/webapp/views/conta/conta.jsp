<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 mb-0 section-title"><i class="bi bi-wallet2 me-2"></i>Modulo de Contas</h1>
    <a href="${pageContext.request.contextPath}/conta?acao=sair" class="btn btn-outline-danger btn-sm">Sair do modulo</a>
</div>

<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>

<div class="row g-3">
    <div class="col-md-4"><a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/conta?acao=abrirCorrente">Abrir conta corrente</a></div>
    <div class="col-md-4"><a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/conta?acao=abrirPoupanca">Abrir conta poupanca</a></div>
    <div class="col-md-4"><a class="btn btn-outline-primary w-100" href="${pageContext.request.contextPath}/conta?acao=buscar">Buscar conta</a></div>
    <div class="col-md-4"><a class="btn btn-outline-primary w-100" href="${pageContext.request.contextPath}/conta?acao=listar">Listar contas</a></div>
    <div class="col-md-4"><a class="btn btn-outline-warning w-100" href="${pageContext.request.contextPath}/conta?acao=atualizarConta">Atualizar conta</a></div>
    <div class="col-md-4"><a class="btn btn-outline-info w-100" href="${pageContext.request.contextPath}/conta?acao=segundoTitular">Adicionar segundo titular</a></div>
    <div class="col-md-12"><a class="btn btn-outline-danger w-100" href="${pageContext.request.contextPath}/conta?acao=excluir">Excluir conta</a></div>
</div>

<c:if test="${not empty conta}">
    <div class="card soft-panel p-3 mt-4">
        <h2 class="h5 mb-3">Detalhes da conta selecionada</h2>
        <div class="row g-2">
            <div class="col-md-3"><strong>Codigo:</strong> ${conta.codigo}</div>
            <div class="col-md-3"><strong>Data abertura:</strong> ${conta.dataAbertura}</div>
            <div class="col-md-3"><strong>Saldo:</strong> ${conta.saldo}</div>
            <div class="col-md-3"><strong>Agencia:</strong> ${conta.agencia.codigo}</div>
            <div class="col-md-3"><strong>Cidade agencia:</strong> ${conta.agencia.cidade}</div>
            <div class="col-md-3"><strong>Tipo:</strong> ${conta.class.simpleName}</div>
            <div class="col-md-3"><strong>Limite credito:</strong> ${conta.limiteCredito}</div>
            <div class="col-md-3"><strong>Rendimento:</strong> ${conta.percentualRendimento}</div>
            <div class="col-md-3"><strong>Dia aniversario:</strong> ${conta.diaAniversario}</div>
        </div>
    </div>
</c:if>

<c:if test="${not empty contas}">
    <div class="card soft-panel p-3 mt-4">
        <h2 class="h5 mb-3">Contas listadas</h2>
        <div class="table-responsive">
            <table class="table table-striped mb-0">
                <thead><tr><th>Codigo</th><th>Tipo</th><th>Data abertura</th><th>Saldo</th><th>Agencia</th><th>Acoes</th></tr></thead>
                <tbody>
                <c:forEach var="item" items="${contas}">
                    <tr>
                        <td>${item.codigo}</td>
                        <td>${item.class.simpleName}</td>
                        <td>${item.dataAbertura}</td>
                        <td>${item.saldo}</td>
                        <td>${item.agencia.codigo}</td>
                        <td>
                            <div class="d-flex gap-1 flex-wrap">
                                <a class="btn btn-sm btn-outline-warning" href="${pageContext.request.contextPath}/conta?acao=atualizarConta&codigoConta=${item.codigo}">Atualizar</a>
                                <a class="btn btn-sm btn-outline-danger" href="${pageContext.request.contextPath}/conta?acao=excluir&codigoConta=${item.codigo}">Excluir</a>
                                <a class="btn btn-sm btn-outline-info" href="${pageContext.request.contextPath}/conta?acao=segundoTitular&codigoConta=${item.codigo}">Segundo titular</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<jsp:include page="../../includes/footer.jsp" />
