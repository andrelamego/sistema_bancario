<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />

<h1 class="h4 mb-3">Atualizar conta</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<c:url var="painelUrl" value="/cliente"><c:param name="acao" value="painel" /></c:url>
<c:set var="returnUrl" value="${empty param.returnUrl ? painelUrl : param.returnUrl}" />
<c:set var="codigoContaSelecionada" value="${param.codigoConta}" />
<c:set var="tipoContaSelecionada" value="${param.tipoConta}" />
<a class="btn btn-outline-secondary btn-sm mb-3" href="${returnUrl}">Voltar</a>

<div class="row g-3">
    <div class="col-lg-6">
        <form action="${pageContext.request.contextPath}/conta" method="post" class="card soft-panel p-3 h-100">
            <input type="hidden" name="returnUrl" value="${returnUrl}">
            <h2 class="h6 mb-3">Saldo</h2>
            <label class="form-label">Codigo da conta</label>
            <input class="form-control mb-3" type="text" name="codigoConta" value="${codigoContaSelecionada}" required>
            <label class="form-label">Novo saldo</label>
            <input class="form-control mb-3" type="text" name="valor" required>
            <button class="btn btn-warning" type="submit" name="button" value="Atualizar Saldo">Atualizar Saldo</button>
        </form>
    </div>
    <c:if test="${tipoContaSelecionada == 'CORRENTE'}">
        <div class="col-lg-6">
            <form action="${pageContext.request.contextPath}/conta" method="post" class="card soft-panel p-3 h-100">
                <input type="hidden" name="returnUrl" value="${returnUrl}">
                <h2 class="h6 mb-3">Limite de credito</h2>
                <label class="form-label">Codigo da conta</label>
                <input class="form-control mb-3" type="text" name="codigoConta" value="${codigoContaSelecionada}" required>
                <label class="form-label">Novo limite</label>
                <input class="form-control mb-3" type="text" name="valor" required>
                <button class="btn btn-warning" type="submit" name="button" value="Atualizar Limite">Atualizar Limite</button>
            </form>
        </div>
    </c:if>
    <c:if test="${tipoContaSelecionada == 'POUPANCA'}">
        <div class="col-lg-6">
            <form action="${pageContext.request.contextPath}/conta" method="post" class="card soft-panel p-3 h-100">
                <input type="hidden" name="returnUrl" value="${returnUrl}">
                <h2 class="h6 mb-3">Rendimento poupanca</h2>
                <label class="form-label">Codigo da conta</label>
                <input class="form-control mb-3" type="text" name="codigoConta" value="${codigoContaSelecionada}" required>
                <label class="form-label">Novo rendimento</label>
                <input class="form-control mb-3" type="text" name="valor" required>
                <button class="btn btn-warning" type="submit" name="button" value="Atualizar Rendimento">Atualizar Rendimento</button>
            </form>
        </div>
        <div class="col-lg-6">
            <form action="${pageContext.request.contextPath}/conta" method="post" class="card soft-panel p-3 h-100">
                <input type="hidden" name="returnUrl" value="${returnUrl}">
                <h2 class="h6 mb-3">Dia de aniversario poupanca</h2>
                <label class="form-label">Codigo da conta</label>
                <input class="form-control mb-3" type="text" name="codigoConta" value="${codigoContaSelecionada}" required>
                <label class="form-label">Dia (1 a 31)</label>
                <input class="form-control mb-3" type="number" name="dia" min="1" max="31" required>
                <button class="btn btn-warning" type="submit" name="button" value="Atualizar Dia Aniversario">Atualizar Dia Aniversario</button>
            </form>
        </div>
    </c:if>
</div>

<jsp:include page="../../includes/footer.jsp" />
