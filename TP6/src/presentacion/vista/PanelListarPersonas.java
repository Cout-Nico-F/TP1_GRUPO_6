package presentacion.vista;

import java.util.List;

import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import entidad.Persona;
import negocio.IPersonaNegocio;
import negocioImpl.PersonaNegocioImpl;

public class PanelListarPersonas extends JPanel {
	
	private JTable tablaPersonas;
	private DefaultTableModel modelPersonas;
	private String[] nombreColumnas = {"Nombre", "Apellido", "Dni"};
	
	public PanelListarPersonas() {
		setLayout(null);
		
		IPersonaNegocio pneg = new PersonaNegocioImpl();
		List<Persona> listaPersonas = pneg.readAll();
		
		modelPersonas = new DefaultTableModel(null,nombreColumnas);
		//modelPersonas.
		
		tablaPersonas = new JTable(modelPersonas);
		tablaPersonas.setBounds(10, 11, 380, 253);
		
		tablaPersonas.getColumnModel().getColumn(0).setPreferredWidth(100);
		tablaPersonas.getColumnModel().getColumn(0).setResizable(false);
		tablaPersonas.getColumnModel().getColumn(1).setPreferredWidth(100);
		tablaPersonas.getColumnModel().getColumn(1).setResizable(false);
		tablaPersonas.getColumnModel().getColumn(2).setPreferredWidth(100);
		tablaPersonas.getColumnModel().getColumn(2).setResizable(false);
		
		//cargar la lista desde base de datos (comunicarse con negocio)
		//ComunicarseConNegocio();
		
		JScrollPane spPersonas = new JScrollPane();
		
		spPersonas.setBounds(15, 11, 380, 250);
		add(spPersonas);
		
		spPersonas.setViewportView(tablaPersonas);

	}

}

