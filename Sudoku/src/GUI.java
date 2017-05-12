import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import java.awt.GridLayout;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.PlainDocument;

import org.jpl7.Query;
import org.jpl7.Term;

import javax.swing.border.LineBorder;
import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import javax.swing.JButton;

import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.ActionEvent;

public class GUI {

	private JFrame frame;
	private JTextField[][] casillas;
	private JButton btnIniciarPartida,btnCrearTablero,btnComprobar,btnResolver,btnCargarTablero;
	private Mapa tableroInicial;
	private JButton btnReiniciarTablero;
	private JButton btnNuevaPartida;
	private static final Color VERDE_CLARO=new Color(173,251,140);

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					GUI window = new GUI();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public GUI() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setBounds(100, 100, 530, 385);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		Query q=new Query("consult('logica.pl')");
		System.out.println(q.hasSolution());
		
		JPanel panel = new JPanel();
		panel.setBorder(null);
		panel.setBounds(22, 23, 270, 270);
		frame.getContentPane().add(panel);
		panel.setLayout(new GridLayout(3, 3, 0, 0));
		
		btnIniciarPartida = new JButton("Iniciar Partida");
		btnIniciarPartida.setEnabled(false);
		btnIniciarPartida.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if(tableroInicial==null)
					tableroInicial=new Mapa();
				for(int i=0;i<9;i++)
					for(int j=0;j<9;j++){
						if(!casillas[i][j].getText().equals("")){
							int num=Integer.parseInt(casillas[i][j].getText());
							if(num>0&&num<10){
								casillas[i][j].setFont(new Font("Tahoma", Font.BOLD,12));
								casillas[i][j].setEnabled(false);
								tableroInicial.setElemento(i, j, casillas[i][j].getText().charAt(0));
							}
						}
						else{
							casillas[i][j].setEnabled(true);
							tableroInicial.setElemento(i, j, '0');
						}
					}
				
			btnIniciarPartida.setEnabled(false);
			btnCrearTablero.setEnabled(false);
			btnCargarTablero.setEnabled(false);
			btnResolver.setEnabled(true);
			btnReiniciarTablero.setEnabled(true);
			btnNuevaPartida.setEnabled(true);
			}
		});
		
		JPanel[] cuadros=new JPanel[9];
		for(int i=0;i<9;i++){
			cuadros[i]= new JPanel();
			cuadros[i].setBorder(new LineBorder(new Color(0, 0, 0), 2));
			cuadros[i].setLayout(new GridLayout(3, 3, 0, 0));
			panel.add(cuadros[i]);
		}
		
		casillas=new JTextField[9][9];
		for(int i=0;i<9;i++)
			for(int j=0;j<9;j++){
				casillas[i][j]=new JTextField();
				casillas[i][j].setDocument(new JTextFieldLimit(1));
				casillas[i][j].setFocusable(true);
				casillas[i][j].addKeyListener(new KeyAdapter() {
					   public void keyTyped(KeyEvent e) {
					      char c = e.getKeyChar();
					      if ( ((c < '1') || (c > '9')) && (c != KeyEvent.VK_BACK_SPACE)) {
					         e.consume();  // ignore event
					      }
					      int x=0;
					      int y=0;
					      boolean encontre=false;
					      for(int i=0;i<9&&!encontre;i++)
								for(int j=0;j<9&&!encontre;j++){
									encontre=casillas[i][j].equals(e.getSource());
									x=i;
									y=j;
								}
						  String tablero = armarTablero();
						  
						  x++; y++;
						  String jugada;
						  if(c==KeyEvent.VK_BACK_SPACE){
					    	  c='0';
					    	  jugada="borrarJugada("+c+","+x+","+y+","+tablero+",X)";
						  }
						  else
							  jugada="agregar("+c+","+x+","+y+","+tablero+",X)";
						  Query q2=new Query(jugada);
						  boolean exito=q2.hasSolution();
						  if (!exito){
							  
							  JOptionPane.showMessageDialog(null, "Numero incorrecto.");
							  e.consume();
						  }
					   }
				});
				
				casillas[i][j].setEnabled(false);
				casillas[i][j].setBorder(new LineBorder(new Color(0, 0, 0), 1));
				casillas[i][j].setHorizontalAlignment(SwingConstants.CENTER);
				casillas[i][j].addFocusListener(new FocusListener() {

		            @Override
		            public void focusGained(FocusEvent e) {
		            	boolean encontre=false;
		            	int x=0;
		            	int y=0;
		            	for(int i=0;i<9&&!encontre;i++)
							for(int j=0;j<9&&!encontre;j++){
								encontre=casillas[i][j].equals(e.getSource());
								x=i;
								y=j;
							}
		            	for(int i=0;i<9;i++){
		            		casillas[x][i].setBackground(VERDE_CLARO);
		            		casillas[i][y].setBackground(VERDE_CLARO);
		            	}
		            	for(Component t:cuadros[(x / 3)*3 + (y / 3)].getComponents())
		            		t.setBackground(VERDE_CLARO);
		                casillas[x][y].setBackground(Color.GREEN);
		                
		            }

		            @Override
		            public void focusLost(FocusEvent e) {
		            	boolean encontre=false;
		            	int x=0;
		            	int y=0;
		            	for(int i=0;i<9&&!encontre;i++)
							for(int j=0;j<9&&!encontre;j++){
								encontre=casillas[i][j].equals(e.getSource());
								x=i;
								y=j;
							}
		            	for(int i=0;i<9;i++){
		            		casillas[x][i].setBackground(Color.WHITE);
		            		casillas[i][y].setBackground(Color.WHITE);
		            	}
		            	for(Component t:cuadros[(x / 3)*3 + (y / 3)].getComponents())
		            		t.setBackground(Color.WHITE);
		                casillas[x][y].setBackground(Color.WHITE);
		            }
		        });
				cuadros[(i / 3)*3 + (j / 3)].add(casillas[i][j]);
			}
		
		btnIniciarPartida.setBounds(355, 19, 113, 23);
		frame.getContentPane().add(btnIniciarPartida);
		
		btnCrearTablero = new JButton("Crear Tablero");
		btnCrearTablero.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				for(int i=0;i<9;i++)
					for(int j=0;j<9;j++)
						casillas[i][j].setEnabled(true);
				btnIniciarPartida.setEnabled(true);
				btnCrearTablero.setEnabled(false);
				btnCargarTablero.setEnabled(false);
				btnComprobar.setEnabled(true);
			}
		});
		btnCrearTablero.setBounds(355, 81, 113, 23);
		frame.getContentPane().add(btnCrearTablero);
		
		btnComprobar = new JButton("Comprobar");
		btnComprobar.setEnabled(false);
		btnComprobar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String tablero=armarTablero();
				Query q=new Query("comprobar("+tablero+")");
				  boolean exito=q.hasSolution();
				  if (exito)
					  JOptionPane.showMessageDialog(null, "Vas bien!");
				  else
					  JOptionPane.showMessageDialog(null, "Vas mal!");
			}
		});
		btnComprobar.setBounds(22, 305, 117, 23);
		frame.getContentPane().add(btnComprobar);
		
		btnResolver = new JButton("Resolver");
		btnResolver.setEnabled(false);
		btnResolver.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String tablero=armarTablero();
				Query q=new Query("resolver("+tablero+",X)");
				boolean exito=q.hasSolution();
				if (exito){
					Term nuevoTablero=q.oneSolution().get("X");
					Term[] t=nuevoTablero.toTermArray();
					for(int i=0;i<t.length;i++){
						Term[] fila=t[i].toTermArray();
						for(int j=0;j<fila.length;j++){
							String num = fila[j].toString();
							casillas[i][j].setText(num);
							casillas[i][j].setEnabled(false);
						}
					}
				}
				else
					  JOptionPane.showMessageDialog(null, "Vas mal!");
			}
		});
		btnResolver.setBounds(175, 305, 117, 23);
		frame.getContentPane().add(btnResolver);
		
		btnCargarTablero = new JButton("Cargar Tablero");
		btnCargarTablero.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String dificultad = (String) JOptionPane.showInputDialog(null,"Seleccione Una Dificultad",
						   "Carga de Tablero", JOptionPane.QUESTION_MESSAGE, null,
						  new String[] { "Seleccione","Facil", "Intermedio", "Dificil" },"Seleccione");
				tableroInicial = new Mapa(dificultad);
				if(dificultad!="Seleccione"){
					for(int i=0;i<9;i++)
						for(int j=0;j<9;j++){
							String num = ""+tableroInicial.getElemento(i, j);
							if(!num.equals("0")){
								casillas[i][j].setText(num);
								casillas[i][j].setEnabled(false);
							}
						}
				}
				btnIniciarPartida.setEnabled(true);
				btnCrearTablero.setEnabled(false);
				btnCargarTablero.setEnabled(false);
				btnComprobar.setEnabled(true);
			}
		});
		btnCargarTablero.setBounds(353, 143, 117, 23);
		frame.getContentPane().add(btnCargarTablero);
		
		btnReiniciarTablero = new JButton("Reiniciar Tablero");
		btnReiniciarTablero.setEnabled(false);
		btnReiniciarTablero.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				for(int i=0;i<9;i++)
					for(int j=0;j<9;j++){
						String num = ""+tableroInicial.getElemento(i, j);
						if(!num.equals("0")){
							casillas[i][j].setText(num);
							casillas[i][j].setEnabled(false);
						}
						else
							casillas[i][j].setText("");
					}
			}
		});
		btnReiniciarTablero.setBounds(350, 205, 130, 29);
		frame.getContentPane().add(btnReiniciarTablero);
		
		btnNuevaPartida = new JButton("Nueva Partida");
		btnNuevaPartida.setEnabled(false);
		btnNuevaPartida.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				for(int i=0;i<9;i++)
					for(int j=0;j<9;j++){
						casillas[i][j].setText("");
						casillas[i][j].setEnabled(false);
					}
				btnIniciarPartida.setEnabled(false);
				btnCrearTablero.setEnabled(true);
				btnCargarTablero.setEnabled(true);
				btnNuevaPartida.setEnabled(false);
				btnComprobar.setEnabled(false);
				btnResolver.setEnabled(false);
				btnReiniciarTablero.setEnabled(false);
			}
		});
		btnNuevaPartida.setBounds(351, 273, 117, 29);
		frame.getContentPane().add(btnNuevaPartida);
		
	}
	
	private String armarTablero(){
		String tablero="[";
		  
		  for(int i=0;i<9;i++){
			  tablero+="[";
			  for(int j=0;j<9;j++){
					if (!casillas[i][j].getText().equals("")){
						tablero+=casillas[i][j].getText();
						
					}else 
						tablero+=0;
					
					if (j!=8)
						tablero+=",";
				}
				tablero+="]";
				if (i!=8)
					tablero+=",";
		  }
		  tablero+="]";
		  return tablero;
	}
}


class JTextFieldLimit extends PlainDocument {
	  private int limit;
	  JTextFieldLimit(int limit) {
	    super();
	    this.limit = limit;
	  }

	  JTextFieldLimit(int limit, boolean upper) {
	    super();
	    this.limit = limit;
	  }

	  public void insertString(int offset, String str, AttributeSet attr) throws BadLocationException {
	    if (str == null)
	      return;

	    if ((getLength() + str.length()) <= limit) {
	      super.insertString(offset, str, attr);
	    }
	  }
	}
