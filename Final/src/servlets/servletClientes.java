package servlets;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.Cliente;
import entidad.Usuario;
import negocio.ClienteNegocio;
import negocio.UsuarioNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.UsuarioNegocioImpl;

@WebServlet("/servletClientes")
public class servletClientes extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public servletClientes() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//Se ejecuta sin llamarlo?
		ClienteNegocio cNeg = new ClienteNegocioImpl();
		ArrayList<Cliente> c = new ArrayList<Cliente>();
		String op;
		op = (request.getParameter("op") != null) ? request.getParameter("op") : "mostrarClientes"; 
		//Como no esta recibiendo nada por parametro primero el String op va a ser igual a list
		
		if(op.equals("mostrarClientes")) {
			c = cNeg.traerClientes();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if(request.getParameter("btnRegistrar") != null) {
			
		}
	}

}
