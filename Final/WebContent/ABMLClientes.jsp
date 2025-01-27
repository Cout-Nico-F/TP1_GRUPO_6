<%@page import="entidad.*"%>
<%@page import = "java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>ABML Clientes</title>
    <%@ include file="HeaderAdmin.jsp" %>  
    <script>
    $(document).ready(function() {
        var table = $('#clientes').DataTable( {
        	processing: true,
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
        <% if(request.getAttribute("mensajeAlert") != null){ %>
	 		$('.toast-body').html('<span><%=request.getAttribute("mensajeAlert") %></span><button class="btn" type="button" data-bs-dismiss="toast"><i class="bi bi-x-lg"></i></button>')
	        $('.toast').toast('show');
	 		<% } %>
 		$(document).on("click", ".abrir-modal", function () {
 			var accion = $(this).data("accion")
 			var mensaje = "�Est� seguro de que desea " + accion + " este cliente?"
 	    	$('input[name="accion"]').val(accion)
 		    $(".modal-body").html(mensaje)
 		    $('input[name="dniActual"]').val($(this).data("dni"))
 		});
        $("#provincia").change(llenarLocalidades)
        window.onload = llenarLocalidades()
    });
    
    function submitForm() {
    	if("eliminar" == $('input[name="accion"]').val()) {
        	$("#formPost"+$('input[name="dniActual"]').val()).submit()
    	} else {
        	$("#formGet").submit()
    	}
    }
    
    function llenarLocalidades() {
        var str = ""
        <%ArrayList<Localidad> ls = (ArrayList<Localidad>) request.getAttribute("localidades");
        if(ls != null && !ls.isEmpty())
           for(Localidad l : ls) { %>
               if( $('select[name="provincia"]').val() == <%=l.getProvincia().getIdProvincia()%>) {
                     <%Cliente c = (Cliente) request.getAttribute("clienteActual");
                     int idLocalidad = 0;
                     if(c != null) {
                  	   idLocalidad = c.getLocalidad().getIdLocalidad();
                     }%>
                     if(<%=idLocalidad%> != 0) {
                  	   str += "<option value='<%=l.getIdLocalidad()%>' <%=l.getIdLocalidad() == idLocalidad ? "selected" : ""%>><%=l.getNombre()%></option>"
                  	} else {
                  		str += "<option value='<%=l.getIdLocalidad()%>'><%=l.getNombre()%></option>"
                    }
               }
        <%}%>
        $('select[name="localidad"]').html(str)
    }
    </script>
  </head>
  <body>
  <br><br><br><br><br>
   <div class="toast" style="left: 50%; position: fixed; transform: translate(-50%, 0px); z-index: 9999;" data-bs-autohide="false">
      <div class="toast-body"></div>
  </div>
	<div class="modal fade" id="modal" tabindex="-1" aria-hidden="true">
	  <input type="hidden" name="dniActual" >
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-body"></div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
	        <button type="button" class="btn btn-primary" onclick="submitForm()">Guardar cambios</button>
	      </div>
	    </div>
	  </div>
	</div>
  <div class="row">
      <div class="col  px-4 py-2">
        <form id="formGet" method="get" action="Clientes">
          		 <input type="hidden" name="accion">
          <fieldset>
            <legend>Nuevo cliente</legend>
              <%
              String vista = (String) request.getAttribute("vista");
	if ("detalle".equals(vista)) {
		Cliente cActual = (Cliente) request.getAttribute("clienteActual");
 %>
  <div class="form-group row my-2">
              <label for="nombre" class="col-sm-3 col-form-label">Nombre</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="nombre" value="<%=cActual.getNombre()%>" readonly>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="apellido" class="col-sm-3 col-form-label">Apellido</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="apellido" value="<%=cActual.getApellido()%>" readonly>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="dni" class="col-sm-3 col-form-label">DNI</label>
              <div class="col-sm-9">      
                <input type="number" class="form-control" id="dni" value="<%=cActual.getDni()%>" readonly>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="cuil" class="col-sm-3 col-form-label">CUIL</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="cuil" value="<%=cActual.getCuil()%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="fecha" class="col-sm-3 col-form-label">Fecha de nacimiento</label>
              <div class="col-sm-9">      
                <input type="date" class="form-control" id="fecha" value="<%=cActual.getFechaNacimiento()%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="sexo" class="col-sm-3 col-form-label">Sexo</label>
                <div class="col-sm-9">      
                  <input type="text" class="form-control" id="sexo" value="<%=cActual.getSexo()%>" readonly>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="nacionalidad" class="col-sm-3 col-form-label">Nacionalidad</label>
                <div class="col-sm-9">      
                   <input type="text" class="form-control" id="nacionalidad" value="<%=cActual.getNacionalidad().getNombre()%>" readonly>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="provincia" class="col-sm-3 col-form-label">Provincia</label>
                <div class="col-sm-9">      
                   <input type="text" class="form-control" id="provincia" value="<%=cActual.getLocalidad().getProvincia().getNombre()%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="localidad" class="col-sm-3 col-form-label">Localidad</label>
                <div class="col-sm-9">      
                 <input type="text" class="form-control" id="localidad" value="<%=cActual.getLocalidad().getNombre()%>" readonly>
                 </div>
            </div>
            <div class="form-group row my-2">
              <label for="direccion" class="col-sm-3 col-form-label">Direcci�n</label>
                <div class="col-sm-9">      
                 <input type="text" class="form-control" id="direccion" value="<%=cActual.getDireccion()%>" readonly>
                 </div>
            </div>
             <div class="form-group row my-2">
              <label for="telefono" class="col-sm-3 col-form-label">Tel�fono fijo</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="telefono" value="<%=cActual.getTelefonoFijo()%>" readonly>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="celular" class="col-sm-3 col-form-label">Celular</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="celular" value="<%=cActual.getCelular()%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="correo" class="col-sm-3 col-form-label">Correo electr�nico</label>
              <div class="col-sm-9">      
                <input type="email" class="form-control" id="correo" value="<%=cActual.getCorreoElectronico()%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="tipo" class="col-sm-3 col-form-label">Tipo de usuario</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="tipo" value="<%=cActual.getUsuario().getEsAdmin() ? "Administrador" : "Cliente"%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="usuario" class="col-sm-3 col-form-label">Usuario</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="usuario" value="<%=cActual.getUsuario().getNombreUsuario()%>" readonly>
              </div>
            </div>
            <div class="mt-3 py-4">
			<a href="Clientes" class="btn btn-primary">Nuevo cliente</a>
            </div>
 <%
	} else if ("modificacion".equals(vista)) {
		Cliente cActual = (Cliente) request.getAttribute("clienteActual");
 %>
            <input type="hidden" name="idUsuario" value="<%=cActual.getUsuario().getIdUsuario()%>">
 			<div class="form-group row my-2">
              <label for="nombre" class="col-sm-3 col-form-label">Nombre</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="nombre" name="nombre" value="<%=cActual.getNombre()%>">
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="apellido" class="col-sm-3 col-form-label">Apellido</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="apellido" name="apellido" value="<%=cActual.getApellido()%>">
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="dni" class="col-sm-3 col-form-label">DNI</label>
              <div class="col-sm-9">      
                <input type="number" class="form-control" id="dni" name="dni" value="<%=cActual.getDni()%>" readonly>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="cuil" class="col-sm-3 col-form-label">CUIL</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="cuil" name="cuil" value="<%=cActual.getCuil()%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="fecha" class="col-sm-3 col-form-label">Fecha de nacimiento</label>
              <div class="col-sm-9">      
                <input type="date" class="form-control" id="fecha" name="fecha" value="<%=cActual.getFechaNacimiento()%>">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="sexo" class="col-sm-3 col-form-label">Sexo</label>
                <div class="col-sm-9">      
                <select class="form-control" id="sexo" name="sexo">
                <option <%="Femenino".equals(cActual.getSexo()) ? "selected" : ""%>>Femenino</option>
                <option <%="Masculino".equals(cActual.getSexo()) ? "selected" : ""%>>Masculino</option>
              </select>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="nacionalidad" class="col-sm-3 col-form-label">Nacionalidad</label>
                <div class="col-sm-9">
                <select class="form-control" id="nacionalidad" name="nacionalidad">
                <%  
     ArrayList<Nacionalidad> nacionalidades = (ArrayList<Nacionalidad>) request.getAttribute("nacionalidades");
     if(nacionalidades != null && !nacionalidades.isEmpty())
		for(Nacionalidad n : nacionalidades) 
		{
	%>      
                <option value="<%=n.getIdNacionalidad()%>" <%=n.getIdNacionalidad() == cActual.getNacionalidad().getIdNacionalidad() ? "selected" : ""%>><%=n.getNombre()%></option>
                <%  } %>
              </select>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="provincia" class="col-sm-3 col-form-label">Provincia</label>
                <div class="col-sm-9">      
                <select class="form-control" id="provincia" name="provincia">
                        <%  
     ArrayList<Provincia> provincias = (ArrayList<Provincia>) request.getAttribute("provincias");
     if(provincias != null && !provincias.isEmpty())
		for(Provincia p : provincias) 
		{
	%>      
                <option value="<%=p.getIdProvincia()%>" <%=p.getIdProvincia() == cActual.getLocalidad().getProvincia().getIdProvincia() ? "selected" : ""%>><%=p.getNombre()%></option>
                <%  } %>
              </select>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="localidad" class="col-sm-3 col-form-label">Localidad</label>
                <div class="col-sm-9">      
                <select class="form-control" id="localidad" name="localidad">
                        <%  
     ArrayList<Localidad> localidades = (ArrayList<Localidad>) request.getAttribute("localidades");
     if(localidades != null && !localidades.isEmpty())
		for(Localidad l : localidades) 
		{
	%>      
                <option value="<%=l.getIdLocalidad()%>" <%=l.getIdLocalidad() ==cActual.getLocalidad().getIdLocalidad() ? "selected" : ""%>><%=l.getNombre()%></option>
                <%  } %>
              </select>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="direccion" class="col-sm-3 col-form-label">Direcci�n</label>
                <div class="col-sm-9">      
                 <input type="text" class="form-control" id="direccion" name="direccion" value="<%=cActual.getDireccion()%>">
                 </div>
            </div>
             <div class="form-group row my-2">
              <label for="telefono" class="col-sm-3 col-form-label">Tel�fono fijo</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="telefono" name="telefono" value="<%=cActual.getTelefonoFijo()%>">
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="celular" class="col-sm-3 col-form-label">Celular</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="celular" name="celular" value="<%=cActual.getCelular()%>">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="correo" class="col-sm-3 col-form-label">Correo electr�nico</label>
              <div class="col-sm-9">      
                <input type="email" class="form-control" id="correo" name="correo" value="<%=cActual.getCorreoElectronico()%>">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="tipo" class="col-sm-3 col-form-label">Tipo de usuario</label>
              <div class="col-sm-9">      
                 <input type="text" class="form-control" id="tipo" value="<%=cActual.getUsuario().getEsAdmin() ? "Administrador" : "Cliente"%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="usuario" class="col-sm-3 col-form-label">Usuario</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="usuario" name="usuario" value="<%=cActual.getUsuario().getNombreUsuario()%>" readonly>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="contrasena" class="col-sm-3 col-form-label">Contrase�a</label>
              <div class="col-sm-9">      
                <input type="password" class="form-control" id="contrasena" name="contrasena" value="<%=cActual.getUsuario().getContrasenia()%>">
              </div>
            </div>
            <div class="mt-3 py-4">
            <button class="btn btn-primary abrir-modal" type="button" data-bs-toggle="modal" data-bs-target="#modal" data-accion="actualizar">Actualizar</button>
            </div>
 <%
	} else {
 %>
            <div class="form-group row my-2">
              <label for="nombre" class="col-sm-3 col-form-label">Nombre</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Ingrese el nombre">
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="apellido" class="col-sm-3 col-form-label">Apellido</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="apellido" name="apellido" placeholder="Ingrese el apellido">
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="dni" class="col-sm-3 col-form-label">DNI</label>
              <div class="col-sm-9">      
                <input type="number" class="form-control" id="dni" name="dni" placeholder="Ingrese el DNI">
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="cuil" class="col-sm-3 col-form-label">CUIL</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="cuil" name="cuil" placeholder="Ingrese el CUIL">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="fecha" class="col-sm-3 col-form-label">Fecha de nacimiento</label>
              <div class="col-sm-9">      
                <input type="date" class="form-control" id="fecha" name="fecha" value="2000-01-01">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="sexo" class="col-sm-3 col-form-label">Sexo</label>
                <div class="col-sm-9">      
                <select class="form-control" id="sexo" name="sexo">
                <option>Femenino</option>
                <option>Masculino</option>
              </select>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="nacionalidad" class="col-sm-3 col-form-label">Nacionalidad</label>
                <div class="col-sm-9">      
                <select class="form-control" id="nacionalidad" name="nacionalidad">
                 <%  
     ArrayList<Nacionalidad> nacionalidades = (ArrayList<Nacionalidad>) request.getAttribute("nacionalidades");
     if(nacionalidades != null && !nacionalidades.isEmpty())
		for(Nacionalidad n : nacionalidades) 
		{
	%>      
                <option value="<%=n.getIdNacionalidad()%>"><%=n.getNombre()%></option>
                <%  } %>
              </select>
              </div>
            </div>
             <div class="form-group row my-2">
              <label for="provincia" class="col-sm-3 col-form-label">Provincia</label>
                <div class="col-sm-9">      
                <select class="form-control" id="provincia" name="provincia">
                 <%  
                ArrayList<Provincia> provincias = (ArrayList<Provincia>) request.getAttribute("provincias");
     if(provincias != null && !provincias.isEmpty())
		for(Provincia p : provincias) 
		{
	%>      
                <option value="<%=p.getIdProvincia()%>"><%=p.getNombre()%></option>
                <%  } %>
              </select>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="localidad" class="col-sm-3 col-form-label">Localidad</label>
                <div class="col-sm-9">      
                <select class="form-control" id="localidad" name="localidad">
               <%  
     ArrayList<Localidad> localidades = (ArrayList<Localidad>) request.getAttribute("localidades");
     if(localidades != null && !localidades.isEmpty())
		for(Localidad l : localidades) 
		{
	%>      
                <option value="<%=l.getIdLocalidad()%>"><%=l.getNombre()%></option>
                <%  } %>
              </select>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="direccion" class="col-sm-3 col-form-label">Direcci�n</label>
                <div class="col-sm-9">      
                 <input type="text" class="form-control" id="direccion" name="direccion" placeholder="Ingrese la direcci�n">
                 </div>
            </div>
             <div class="form-group row my-2">
              <label for="telefono" class="col-sm-3 col-form-label">Tel�fono fijo</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="telefono" name="telefono" placeholder="Ingrese el tel�fono">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="celular" class="col-sm-3 col-form-label">Celular</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="celular" name="celular" placeholder="Ingrese el tel�fono">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="correo" class="col-sm-3 col-form-label">Correo electr�nico</label>
              <div class="col-sm-9">      
                <input type="email" class="form-control" id="correo" name="correo" placeholder="Ingrese el correo electr�nico">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="tipo" class="col-sm-3 col-form-label">Tipo de usuario</label>
              <div class="col-sm-9">      
              <select class="form-control" id="tipo" name="tipo">
                <option>Cliente</option>
                <option>Administrador</option>
                </select>
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="usuario" class="col-sm-3 col-form-label">Usuario</label>
              <div class="col-sm-9">      
                <input type="text" class="form-control" id="usuario" name="usuario" placeholder="Ingrese el usuario">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="contrasena" class="col-sm-3 col-form-label">Contrase�a</label>
              <div class="col-sm-9">      
                <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="Ingrese la contrase�a">
              </div>
            </div>
            <div class="form-group row my-2">
              <label for="contrasena" class="col-sm-3 col-form-label">Repetir contrase�a</label>
              <div class="col-sm-9">      
                <input type="password" class="form-control" id="contrasenaRep" name="contrasenaRep" placeholder="Ingrese la contrase�a nuevamente">
              </div>
            </div>
            <div class="mt-3 py-4">
            <button class="btn btn-primary abrir-modal" type="button" data-bs-toggle="modal" data-bs-target="#modal" data-accion="registrar">Registrar</button>
            <button type="reset" class="btn btn-secondary">Limpiar</button>
            </div>
             <% } %>
          </fieldset>
        </form>        
      </div>
      <div class="col px-4 py-2">
        <table id="clientes" class="table table-hover nowrap">
          <thead>
            <tr>
              <th scope="col" class="text-center">Usuario</th>
              <th scope="col" class="text-center">Nombre</th>
              <th scope="col" class="text-center">Apellido</th>
              <th scope="col" class="text-center">DNI</th>
              <th scope="col" class="text-center">Acciones</th>
            </tr>
          </thead>
            <tbody>
     <%  
     ArrayList<Cliente> clientes = (ArrayList<Cliente>) request.getAttribute("clientes");
     if(clientes != null && !clientes.isEmpty())
		for(Cliente c : clientes) 
		{
	%>
	<tr>
      <form id="formPost<%=c.getDni()%>" action="Clientes" method="post">
		 <input type="hidden" name="dni" value="<%=c.getDni()%>">
		 <td><%=c.getUsuario().getNombreUsuario() %></td>    
	     <td><%=c.getNombre() %></td>   
	     <td><%=c.getApellido() %></td>   
	     <td><%=c.getDni() %></td>
	     <td class="text-center">
	     <button class="btn" type="submit" name="btnDetalle"><i class="bi bi-info-lg"></i></button>
	     <button class="btn" type="submit" name="btnModificar"><i class="bi bi-pencil-fill"></i></button>
	     <button class="btn abrir-modal" type="button" data-bs-toggle="modal" data-bs-target="#modal" data-accion="eliminar" data-dni="<%=c.getDni()%>"><i class="bi bi-trash-fill"></i></button>
	     </td>     
      </form>
	</tr>
	<%  } %>
  </tbody>
        </table>     
      </div>
     </div>
     
  </body>
</html>