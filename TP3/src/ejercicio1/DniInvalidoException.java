package ejercicio1;

import java.io.IOException;

public class DniInvalidoException extends IOException {
	
	public static final String LONGITUD_NO_VALIDA = "La longitud debe ser de 8 caracteres.";
	
	public static final String FORMATO_NO_VALIDO = "El Dni debe estar conformado por 8 caracteres entre el 0 al 9.";
	
	public DniInvalidoException() {
		//codigo que ejecutar si se produce la excepcion
	}
	
	public DniInvalidoException(String exception) {
		
	}

	@Override
	public String getMessage() {

		return "El DNI ingresado no es v�lido.";
	}
	
	
	
}
