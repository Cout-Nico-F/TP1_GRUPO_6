<%@page import="sun.reflect.generics.tree.ClassTypeSignature"%>
<%@page import="entidad.Cuenta"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="entidad.Cuota"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="entidad.Prestamo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Pagar un pr�stamo</title>
<%@ include file="HeaderCliente.jsp"%>

<script>
    $(document).ready(function() {
        var table = $('#clientes').DataTable( {
            language: {
            	"decimal":        "",
                "emptyTable":     "No hay informaci�n disponible en la tabla",
                "info":           "Mostrando _START_ a _END_ de _TOTAL_ registros",
                "infoEmpty":      "Mostrando 0 a 0 de 0 registro(s)",
                "infoFiltered":   "(filtrado de _MAX_ registros totales)",
                "infoPostFix":    "",
                "thousands":      ".",
                "loadingRecords": "Cargando...",
                "processing":     "Procesando...",
                "search":         "Buscar:",
                "zeroRecords":    "No se encontraron resultados",
                "paginate": {
                    "first":      "Primera",
                    "last":       "�ltima",
                    "next":       "Siguiente",
                    "previous":   "Anterior"
                }
            },
            lengthChange: false
        } );
        <%if (request.getAttribute("msjTituloModal") != null) {%>
	 		$('.toast-body').html('<span><%=request.getAttribute("msjModal")%></span><button class="btn" type="button" data-bs-dismiss="toast"><i class="bi bi-x-lg"></i></button>')
			</span><button class="btn" type="button" data-bs-dismiss="toast"><i class="bi bi-x-lg"></i></button>')
			$('.toast').toast('show');
<%}%>
	$(document).on("click",".abrir-modal", function() {
		var accion = $(this).data("accion")
		var mensaje = "�Est� seguro de que desea "+ accion + " esta cuenta?"
			$('input[name="accion"]').val(accion)
			$(".modal-body").html(mensaje)
		});
	});

	function submitForm() {
		if ("eliminar" == $('input[name="accion"]').val()) {
			$("#formPost").submit()
		} else if ("asignar" == $('input[name="accion"]').val()) {
			$("#formGet").submit()
		}
	}
</script>
</head>

<body>
	<br>

	<div class="titlePrestamos"></div>
	<br><br><br>
	<form action="ServletPagarPrestamo" method="get">
		<div align="center">		
			<label for="standard-select">Seleccione la cuenta a debitar</label>
			<div class="select">
				<select name="cuentaSelecc" onchange="this.form.submit()">
				<option selected> Seleccione una Cuenta </option>
					<%
						ArrayList<Cuenta> listaCuentas = null;
						if (request.getSession().getAttribute("listaCtasUsuario") != null) {
							listaCuentas = (ArrayList<Cuenta>) request.getSession().getAttribute("listaCtasUsuario");
							for (Cuenta c : listaCuentas) {
								if (c.getNumeroCuenta().equals(request.getParameter("cuentaSelecc"))) {
									%>
									<option label="<%=c.getTipoDeCuenta().getDescripcion()%> - <%=c.getNumeroCuenta()%>"value="<%=c.getNumeroCuenta() %>" selected><%=c.getTipoDeCuenta().getDescripcion() %>- <%=c.getNumeroCuenta() %></option>
									<% } else { %>
										<option label="<%=c.getTipoDeCuenta().getDescripcion()%> - <%=c.getNumeroCuenta()%>"value="<%=c.getNumeroCuenta() %>"><%=c.getTipoDeCuenta().getDescripcion() %> - <%=c.getNumeroCuenta() %></option>
									<% }									 					 
							 }		
						}
						else {
							%>
							<option value="1">No hay cuentas disponibles</option>
						<%
						}							
					%>
				</select>
				
			</div> <% 
			if(request.getAttribute("cuentaSeleccionada") != null &&
			!("Seleccione una Cuenta".equals(request.getParameter("cuentaSelecc")))){%>
			<label><b>Saldo de cuenta: $ <%=((Cuenta)(request.getAttribute("cuentaSeleccionada"))).getSaldo() %> .- </b></label>
			<%} else {%>
				<label><b>Saldo de cuenta: </b> <i> Sin cuenta seleccionada </i> </label>
			<% }%>
		</div>
	<table id="clientes" class="table table-hover nowrap">
		<thead>
			<tr>
				<th scope="col" class="text-center">C�digo de Pr�stamo</th>
				<th scope="col" class="text-center">N�mero de cuota</th>
				<th scope="col" class="text-center">Fecha de vencimiento</th>
				<th scope="col" class="text-center">Valor de cuota</th>
				<th scope="col" class="text-center">Saldo pr�stamo</th>
				<th scope="col" class="text-center">Total prestamo</th>
				<th scope="col" class="text-center">Pagar cuota</th>

			</tr>
		</thead>
		<tbody>
			<%
				ArrayList<Prestamo> listaPrestamos = null;
				listaPrestamos = (ArrayList<Prestamo>) request.getSession().getAttribute("listaPrestMostrada");
				if (listaPrestamos != null) {
					for (Prestamo p : listaPrestamos) {
					final String indexPrestamo = String.valueOf(listaPrestamos.indexOf(p));
			%>
			<%
				ArrayList<Cuota> listaCuotas = p.getListaCuotas();
					for (Cuota c : listaCuotas) {
					final String indexCuotas = String.valueOf(listaCuotas.indexOf(c));
			%>
			
			<tr>
					<td class="dt-body-center"><%=p.getIdPrestamo()%></td>
					<td class="dt-body-center"><%=c.getNumeroCuota()%> / <%=p.getCuotas()%>
					</td>
					<td class="dt-body-center"><%=c.getFechaDeVencimientoSQL()%> <input
						type="hidden" name="nroCuenta"></td>
					<td class="dt-body-center">$ <%=p.getMontoMensual()%> .-
					</td>
					<td class="dt-body-center">$ <%=((ArrayList<BigDecimal>) request.getAttribute("listaSaldos")).get(listaPrestamos.indexOf(p))%>
						.-
					</td>
					<td class="dt-body-center">$ <%=p.getImporteSolicitado()%> .-
					</td>
					<td class="dt-body-center"><div class="form-check">
							<input class="form-check-input" type="checkbox" value="." name="cbPrestamo<%=indexPrestamo%><%=indexCuotas%>"
					<%if(request.getParameter("cuentaSelecc") == null ||
					("Seleccione una Cuenta".equals(request.getParameter("cuentaSelecc")))){ %>
						disabled></div></td> 
						<% } else {%>
						></div></td>
						<%} %>
			</tr>				 
			<%
				}
						
					}
				} %>
		</tbody>
	</table>
		<% if(request.getParameter("cuentaSelecc") != null &&
						!("Seleccione una Cuenta".equals(request.getParameter("cuentaSelecc")))){ %>
							<div class="row g-3">
							<div class ="container" align="right">	 
							  <div class="col-auto">
							    <input type="text" class="form-control" name="detallePago" required placeholder="Detalle del pago">
							  </div>
							  <div class="col-auto">
							    <button type="submit" name="btnPagar" class="btn btn-success mb-3">Pagar</button>
							  </div>
							 </div>
							 </div>
							<% } %>
			
</form>
</body>
</html>
