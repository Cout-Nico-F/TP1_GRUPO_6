package daoImpl;

import java.sql.SQLException;
import entidad.Usuario;
import daoImpl.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDaoImpl {
	
	private static final String searchUser = "Select * From usuarios Where nombreUsuario=? and contrasenia=?";
	
	public boolean buscarUsuario(Usuario u) throws SQLException
	{
		//Codigo para buscar el usuario y que devuelve un bool en caso de existir
		//Cuando la bd este terminada haria un procedimiento almacenado
		PreparedStatement statement;
		Connection conexion = Conexion.getConexion().getSQLConexion();
		ResultSet rs = null;
		boolean busquedaExitosa = false;
		try {
			statement = conexion.prepareStatement(searchUser);
			statement.setString(1,u.getNombreUsuario());
			statement.setString(2,u.getContrasenia());
			rs = statement.executeQuery();
			while(rs.next())
			{
				busquedaExitosa = true;
				return busquedaExitosa;
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return busquedaExitosa;
	}
}
