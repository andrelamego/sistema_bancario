<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />

<h1 class="h4 mb-3">Painel do cliente</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<c:url var="painelUrl" value="/cliente">
    <c:param name="acao" value="painel" />
</c:url>
<c:url var="abrirCorrenteUrl" value="/conta">
    <c:param name="acao" value="abrirCorrente" />
    <c:param name="cpfCliente" value="${cliente.cpf}" />
    <c:param name="returnUrl" value="${painelUrl}" />
</c:url>
<c:url var="abrirPoupancaUrl" value="/conta">
    <c:param name="acao" value="abrirPoupanca" />
    <c:param name="cpfCliente" value="${cliente.cpf}" />
    <c:param name="returnUrl" value="${painelUrl}" />
</c:url>
<c:url var="atualizarSenhaUrl" value="/cliente">
    <c:param name="acao" value="atualizar" />
    <c:param name="cpf" value="${cliente.cpf}" />
    <c:param name="returnUrl" value="${painelUrl}" />
</c:url>
<c:url var="sairClienteUrl" value="/cliente">
    <c:param name="acao" value="sair" />
</c:url>

<div class="card soft-panel p-3 mb-3">
    <div class="row align-items-center">
        <div class="col-md-4"><strong>CPF:</strong> ${cliente.cpf}</div>
        <div class="col-md-8"><strong>Nome:</strong> ${cliente.nome}</div>
        <div class="col-md-12 mt-2">
            <a class="btn btn-outline-danger btn-sm" href="${sairClienteUrl}">Sair</a>
        </div>
    </div>
    <div class="d-flex gap-2 mt-3 flex-wrap">
        <a class="btn btn-primary" href="${abrirCorrenteUrl}">Abrir conta corrente</a>
        <a class="btn btn-primary" href="${abrirPoupancaUrl}">Abrir conta poupanca</a>
        <a class="btn btn-outline-warning" href="${atualizarSenhaUrl}">Atualizar senha</a>
        <form action="${pageContext.request.contextPath}/cliente" method="post" class="d-inline" onsubmit="return confirm('Confirma a exclusao da conta do cliente? Esta acao nao pode ser desfeita.');">
            <input type="hidden" name="cpf" value="${cliente.cpf}">
            <input type="hidden" name="fromPainel" value="true">
            <button class="btn btn-outline-danger" type="submit" name="button" value="Excluir">Excluir Conta</button>
        </form>
    </div>
</div>

<div class="card soft-panel p-3">
    <h2 class="h5 mb-3">Minhas contas</h2>
    <div class="table-responsive">
        <table class="table table-striped mb-0">
            <thead>
            <tr>
                <th>Codigo</th>
                <th>Tipo</th>
                <th>Data abertura</th>
                <th>Saldo</th>
                <th>Agencia</th>
                <th>Cidade</th>
                <th>Limite credito</th>
                <th>Rendimento (%)</th>
                <th>Dia aniversario</th>
                <th>Acoes</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${contas}">
                <tr>
                    <td>${item.codigo}</td>
                    <td>${item.tipoConta}</td>
                    <td>${item.dataAbertura}</td>
                    <td>${item.saldo}</td>
                    <td>${item.agencia.codigo}</td>
                    <td>${item.agencia.cidade}</td>
                    <c:choose>
                        <c:when test="${item.tipoConta == 'CORRENTE'}">
                            <td>${item.limiteCredito}</td>
                            <td>-</td>
                            <td>-</td>
                        </c:when>
                        <c:when test="${item.tipoConta == 'POUPANCA'}">
                            <td>-</td>
                            <td>${item.percentualRendimento}</td>
                            <td>${item.diaAniversario}</td>
                        </c:when>
                        <c:otherwise>
                            <td>-</td>
                            <td>-</td>
                            <td>-</td>
                        </c:otherwise>
                    </c:choose>
                    <td>
                        <div class="d-flex gap-1 flex-wrap">
                            <c:url var="atualizarContaUrl" value="/conta">
                                <c:param name="acao" value="atualizarConta" />
                                <c:param name="codigoConta" value="${item.codigo}" />
                                <c:param name="tipoConta" value="${item.tipoConta}" />
                                <c:param name="returnUrl" value="${painelUrl}" />
                            </c:url>
                            <c:url var="excluirContaUrl" value="/conta">
                                <c:param name="acao" value="excluir" />
                                <c:param name="codigoConta" value="${item.codigo}" />
                                <c:param name="returnUrl" value="${painelUrl}" />
                            </c:url>
                            <c:url var="segundoTitularUrl" value="/conta">
                                <c:param name="acao" value="segundoTitular" />
                                <c:param name="codigoConta" value="${item.codigo}" />
                                <c:param name="returnUrl" value="${painelUrl}" />
                            </c:url>
                            <a class="btn btn-sm btn-outline-warning" href="${atualizarContaUrl}">Atualizar</a>
                            <a class="btn btn-sm btn-outline-danger" href="${excluirContaUrl}">Remover</a>
                            <a class="btn btn-sm btn-outline-info" href="${segundoTitularUrl}">Adicionar segundo titular</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty contas}">
                <tr><td colspan="10" class="text-center text-muted">Nenhuma conta encontrada para este cliente.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp" />
