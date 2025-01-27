package servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.Cliente;
import entidad.Cuenta;
import entidad.Cuota;
import entidad.Prestamo;
import negocio.ClienteNegocio;
import negocio.IAdminNegocio;
import negocio.IPrestamoNegocio;
import negocio.MovimientoNegocio;
import negocioImpl.AdminNegocioImpl;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.MovimientoNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;

/**
 * Servlet implementation class ServletPagarPrestamo
 */
@WebServlet("/ServletPagarPrestamo")
public class ServletPagarPrestamo extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ArrayList<Prestamo> listaPrestamos;
	private ArrayList<Cuenta> listaCuentas;
	private ClienteNegocio cliNeg = new ClienteNegocioImpl();
	private IPrestamoNegocio preNeg = new PrestamoNegocioImpl();
	private IAdminNegocio admNeg = new AdminNegocioImpl();
	private MovimientoNegocio movNeg = new MovimientoNegocioImpl();

	public ServletPagarPrestamo() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (cliNeg.validarUsuarioCliente(request)) {
			if(request.getSession().getAttribute("listaPrestMostrada")==null || 
				!String.valueOf(request.getAttribute("cuotasSelecc")).equals(String.valueOf(request.getParameter("cantCuotas")))) {
				cargarSelect(request);
				cargarPrestamos(request);
				cargarCuentasUsuario(request);				
			}	
			
			cargarSelect(request);
			cargarSaldos(request);
			pagarPrestamo(request);
		} else {
			response.sendRedirect("Login.jsp");
			return;
		}
		
		RequestDispatcher rd = request.getRequestDispatcher("/PagarPrestamos.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (cliNeg.validarUsuarioCliente(request)) {

		} else {
			response.sendRedirect("Login.jsp");
			return;
		}

		RequestDispatcher rd = request.getRequestDispatcher("/PagarPrestamos.jsp");
		rd.forward(request, response);

	}

	//////////////// -------------------------//////////////////////

	private void cargarSaldos(HttpServletRequest request) {
		request.setAttribute("listaSaldos", preNeg.cargarSaldos(listaPrestamos));
	}

	private void cargarPrestamos(HttpServletRequest request) {	
		String nombreUsuario = String.valueOf(request.getSession().getAttribute("nombreUsuarioLogeado"));
		Cliente cli = cliNeg.traerClientePorNombreUsuario(nombreUsuario);
		listaPrestamos = cliNeg.listarPrestamosPorCliente(cli.getDni());
		ArrayList<Prestamo> listaPrestAux = new ArrayList<Prestamo>();
		Prestamo prestamo = new Prestamo();
		for (Prestamo p : listaPrestamos) {
			ArrayList<Cuota> listaCuotas = p.getListaCuotas();
			int numeroCuotasMostradas = Integer.valueOf(String.valueOf(request.getAttribute("cuotasSelecc")));
			if (listaCuotas.size() < numeroCuotasMostradas) { // Si el tama�o de la lista es menor a la cant. de cuotas
																// que se quiere mostrar,
				numeroCuotasMostradas = listaCuotas.size(); // en la l�nea 96 le recortamos hasta el tama�o de la lista.
			}
			listaCuotas = new ArrayList<Cuota>(listaCuotas.subList(0, numeroCuotasMostradas));
			prestamo = new Prestamo(p.getIdPrestamo(), p.getCliente(), p.getCuenta(), p.getFechaSQL(),
					p.getImporteSolicitado(), p.getImporteAPagar(), p.getMontoMensual(), p.getCuotas(), p.getEstado(),
					listaCuotas);
			prestamo.setListaCuotas(listaCuotas);
			listaPrestAux.add(prestamo);
		}
		request.getSession().setAttribute("listaPrestMostrada", listaPrestAux);
	}

	private void cargarCuentasUsuario(HttpServletRequest request) {
		String nombreUsuario = String.valueOf(request.getSession().getAttribute("nombreUsuarioLogeado"));
		Cliente cli = cliNeg.traerClientePorNombreUsuario(nombreUsuario);
		listaCuentas = admNeg.listarCuentas(cli.getDni());
		request.getSession().setAttribute("listaCtasUsuario", listaCuentas);
	}
	
	private void cargarSelect(HttpServletRequest request) {
		if (request.getParameter("cuentaSelecc") != null) {
			Cuenta c = preNeg.buscarCuenta(listaCuentas, String.valueOf(request.getParameter("cuentaSelecc")));
			request.setAttribute("cuentaSeleccionada", c);
		}
		if(request.getParameter("cantCuotas")!=null) {
			request.setAttribute("cuotasSelecc", request.getParameter("cantCuotas"));
		} else {
			request.setAttribute("cuotasSelecc", 1);
		}
	}

	private void pagarPrestamo(HttpServletRequest request) {
		ArrayList<Prestamo> listaPrestamosAPagar = validarInputSaldo(request);
			if (request.getParameter("InputBandera") != null && !(String.valueOf(request.getParameter("InputBandera"))).equals("")) {		
			ArrayList<Boolean> resultados = new ArrayList<Boolean>();
			for (Prestamo p : listaPrestamosAPagar) {
				ArrayList<Cuota> listaCuotas = p.getListaCuotas();
				if (listaCuotas.size() > 0) {
					for (Cuota c : listaCuotas) {
						if (movNeg.validarFondosSuficientes(String.valueOf(request.getParameter("cuentaSelecc")), c.getImporte())) 
						{
							if(preNeg.registrarPagoPrestamo(request.getParameter("cuentaSelecc"), c, p.getIdPrestamo(), String.valueOf(request.getParameter("detallePago"))))
								{resultados.add(true);} else {resultados.add(false);}
						} else {
							resultados.add(false);
						}
					}
				}
			}
			if(resultados.size() == 0) {
				request.setAttribute("msjToast", "Debe seleccionar al menos una cuota a pagar.");
			} else {
				if(resultados.indexOf(false)!=-1) {
					request.setAttribute("msjToast", "No dispone del saldo suficiente para realizar el pago.");
				}
				else {
					request.setAttribute("msjToast", "Su pago se realiz� satisfactoriamente.");
				}
			}
		
		cargarSelect(request);
		cargarPrestamos(request);
		cargarCuentasUsuario(request);
		cargarSaldos(request);
		}
	}

	private ArrayList<Prestamo> validarInputSaldo(HttpServletRequest request) {
		BigDecimal totalAPagar = new BigDecimal(0);
		ArrayList<Prestamo> listaPrestMostrados = (ArrayList<Prestamo>) request.getSession().getAttribute("listaPrestMostrada");
		ArrayList<Prestamo> listaPrestLocalMostrados = admNeg.duplicarListaPrestamos(listaPrestMostrados);
		for (Prestamo p : listaPrestLocalMostrados) {
			ArrayList<Cuota> listaCuotasAPagar = new ArrayList<Cuota>();
			ArrayList<Cuota> listaCuotasMostradas = p.getListaCuotas();
			String indexPrestamo = String.valueOf(listaPrestLocalMostrados.indexOf(p));
			for (Cuota c : listaCuotasMostradas) {
				String indexCuota = String.valueOf(listaCuotasMostradas.indexOf(c));	
				if (request.getParameter("cbPrestamo"+indexPrestamo+indexCuota) != null) {
					totalAPagar.add(c.getImporte());
					listaCuotasAPagar.add(c);
				}
			}
			p.setListaCuotas(listaCuotasAPagar);
		}
		if(request.getParameter("cuentaSelecc")!=null && !(request.getParameter("cuentaSelecc").equals("No hay cuentas disponibles")) && !(request.getParameter("cuentaSelecc").equals("Seleccione una Cuenta"))) {
			Cuenta cuentaSeleccionada = (Cuenta)(request.getAttribute("cuentaSeleccionada"));
			BigDecimal nuevoSaldo = cuentaSeleccionada.getSaldo().subtract(totalAPagar);
			request.setAttribute("msjModal", "Desea pagar las cuotas seleccionadas? Saldo actual de la cuenta: $ "+cuentaSeleccionada.getSaldo());//+ " .-\n Total a pagar: $ "+ totalAPagar + " .-\n Nuevo saldo: $ "+nuevoSaldo+ " .-");			
			if (nuevoSaldo.compareTo(BigDecimal.ZERO) >= 0) {
				return listaPrestLocalMostrados;
			}
		}
		return new ArrayList<Prestamo>();
	}
}
