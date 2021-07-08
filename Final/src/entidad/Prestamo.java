package entidad;

import java.util.Date;

public class Prestamo {
	private long idPrestamo;
	private Cuenta cuenta;
	private Cliente cliente;
	private Date fecha;
	private double importeSolicitado;
	private double importeAPagar;
	private double montoMensual;
	private int cuotas;
	private int estado;
	private Cuota[] listaCuotas;
	
	public Prestamo() {
		
	}
	
	public long getIdPrestamo() {
		return idPrestamo;
	}
	public void setIdPrestamo(long idPrestamo) {
		this.idPrestamo = idPrestamo;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public double getImporteSolicitado() {
		return importeSolicitado;
	}
	public void setImporteSolicitado(double importeSolicitado) {
		this.importeSolicitado = importeSolicitado;
	}
	public double getImporteAPagar() {
		return importeAPagar;
	}
	public void setImporteAPagar(double importeAPagar) {
		this.importeAPagar = importeAPagar;
	}
	public double getMontoMensual() {
		return montoMensual;
	}
	public void setMontoMensual(double montoMensual) {
		this.montoMensual = montoMensual;
	}
	public int getCuotas() {
		return cuotas;
	}
	public void setCuotas(int cuotas) {
		this.cuotas = cuotas;
	}
	public int getEstado() {
		return estado;
	}
	public void setEstado(int estado) {
		this.estado = estado;
	}

	public Cuenta getCuenta() {
		return cuenta;
	}

	public void setCuenta(Cuenta cuenta) {
		this.cuenta = cuenta;
	}

	public Cliente getCliente() {
		return cliente;
	}

	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
	}

	public Cuota[] getListaCuotas() {
		return listaCuotas;
	}

	public void setListaCuotas(Cuota[] listaCuotas) {
		this.listaCuotas = listaCuotas;
	}
}
