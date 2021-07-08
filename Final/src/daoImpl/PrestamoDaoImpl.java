package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import dao.CuotaDao;
import dao.PrestamoDao;
import entidad.Cliente;
import entidad.Cuenta;
import entidad.Prestamo;
import entidad.TipoDeCuenta;

public class PrestamoDaoImpl implements PrestamoDao {
	private static final String traerPrestamosParaAutorizar = "select * from prestamos pr inner join clientes cl on pr.Dni = cl.Dni inner join cuentas cu on pr.NumeroCuenta = cu.NumeroCuenta inner join tiposdecuenta tc on tc.IdTipoCuenta = cu.IdTipoCuenta where pr.Estado = 1 and cl.Eliminado = 0 and cu.Eliminado = 0;";
	private static final String ActualizarPrestamo = "update prestamos set estado = ? where IdPrestamo = ?";
	
	//idPrestamo estado MontoMensual Cuotas Fecha 
	@Override
	public int actualizarPrestamo(Prestamo prestamo) {
		PreparedStatement ps;
		Connection conexion = Conexion.getConexion().getSQLConexion();
		int resultado = -1;
		try {
			ps = conexion.prepareStatement(ActualizarPrestamo);
			ps.setInt(1, prestamo.getEstado());
			ps.setLong(2, prestamo.getIdPrestamo());
			resultado = ps.executeUpdate();
			if (resultado > 0) {
				conexion.commit();
				//Si est� aprobado, se insertan las cuotas
				if(prestamo.getEstado() == 3) {
					CuotaDao cuotaDao = new CuotaDaoImpl();
					cuotaDao.insertarCuotas(prestamo);					
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conexion.rollback();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return resultado;
	}
	
	@Override
	public ArrayList<Prestamo> traerPrestamosParaAutorizar(){
		PreparedStatement statement;
		ArrayList<Prestamo> listaPrestamos = new ArrayList<Prestamo>();
		Connection conexion = Conexion.getConexion().getSQLConexion();
		ResultSet rs = null;
		try {
			statement = conexion.prepareStatement(traerPrestamosParaAutorizar);
			rs = statement.executeQuery();
			while(rs.next()) {
				Prestamo p = new Prestamo();
				p.setIdPrestamo(rs.getLong("pr.IdPrestamo"));
				p.setFecha(rs.getDate("pr.Fecha"));
				p.setImporteSolicitado(rs.getDouble("pr.ImporteSolicitado"));
				p.setImporteAPagar(rs.getDouble("pr.ImporteAPagar"));
				p.setMontoMensual(rs.getDouble("pr.MontoMensual"));
				p.setCuotas(rs.getInt("pr.Cuotas"));
				p.setEstado(rs.getInt("pr.Estado"));
				Cliente cl = new Cliente();
				cl.setDni(rs.getInt("cl.Dni"));
				cl.setCuil(rs.getString("cl.Cuil"));
				cl.setNombre(rs.getString("cl.Nombre"));
				cl.setApellido(rs.getString("cl.Apellido"));
				cl.setSexo(rs.getString("cl.Sexo"));
				cl.setFechaNacimiento(rs.getDate("cl.FechaNacimiento"));
				cl.setDireccion(rs.getString("cl.Direccion"));
				cl.setCorreoElectronico(rs.getString("cl.CorreoElectronico"));
				cl.setTelefonoFijo(rs.getString("cl.TelefonoFijo"));
				cl.setCelular(rs.getString("cl.Celular"));
				p.setCliente(cl);
				Cuenta cu = new Cuenta();
				cu.setNumeroCuenta(((Long)rs.getLong("cu.NumeroCuenta")).toString());
				cu.setDNI(rs.getInt("cu.Dni"));
				cu.setSaldo(rs.getBigDecimal("cu.Saldo"));
				cu.setCBU(rs.getString("cu.Cbu"));
				cu.setFecha(rs.getDate("cu.FechaCreacion"));
				TipoDeCuenta tc = new TipoDeCuenta();
				tc.setIdTipoCuenta(rs.getShort("tc.IdTipoCuenta"));
				tc.setDescripcion(rs.getString("tc.Descripcion"));
				cu.setTipoDeCuenta(tc);
				p.setCuenta(cu);
				listaPrestamos.add(p);
			}
			return listaPrestamos; 
		}
		catch(SQLException e) {
			e.printStackTrace();
			return listaPrestamos; 
		}
	}
		
}
