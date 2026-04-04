<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<c:url var="inicioUrl" value="/index.jsp" />
<h1 class="h4 mb-3">Todas as agencias</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<a class="btn btn-outline-secondary btn-sm mb-3" href="${inicioUrl}">Voltar</a>
<form action="${pageContext.request.contextPath}/agencia" method="post" class="mb-3">
    <button class="btn btn-outline-primary" type="submit" name="button" value="Listar">Atualizar lista</button>
</form>
<div class="card soft-panel p-3">
    <div class="table-responsive">
        <table class="table table-striped mb-0">
            <thead><tr><th>ID</th><th>Codigo</th><th>CEP</th><th>Cidade</th><th>ID Instituicao</th><th>Acoes</th></tr></thead>
            <tbody>
            <c:forEach var="ag" items="${agencias}">
                <tr>
                    <td>${ag.id}</td>
                    <td>${ag.codigo}</td>
                    <td>${ag.cep}</td>
                    <td>${ag.cidade}</td>
                    <td>${ag.instituicaoBancaria.id}</td>
                    <td>
                        <div class="d-flex gap-1">
                            <a class="btn btn-sm btn-outline-warning" href="${pageContext.request.contextPath}/agencia?acao=atualizar&id=${ag.id}&codigo=${ag.codigo}&cep=${ag.cep}&cidade=${ag.cidade}&idInstituicao=${ag.instituicaoBancaria.id}">Atualizar</a>
                            <a class="btn btn-sm btn-outline-danger" href="${pageContext.request.contextPath}/agencia?acao=excluir&id=${ag.id}">Excluir</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty agencias}">
                <tr><td colspan="6" class="text-center text-muted">Nenhuma agencia encontrada.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="../../includes/footer.jsp" />
