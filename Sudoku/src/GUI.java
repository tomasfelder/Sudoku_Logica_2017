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

import javax.swing.border.LineBorder;
import java.awt.Color;
import java.awt.Font;
import javax.swing.JButton;

import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.ActionEvent;

public class GUI {

	private JFrame frame;
	private JTextField[][] casillas;
	private String tablero;

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
		
		JButton btnIniciarPartida = new JButton("Iniciar Partida");
		btnIniciarPartida.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				for(int i=0;i<9;i++)
					for(int j=0;j<9;j++)
						if(!casillas[i][j].getText().equals("")){
							int num=Integer.parseInt(casillas[i][j].getText());
							if(num>0&&num<10){
								casillas[i][j].setFont(new Font("Tahoma", Font.BOLD,12));
								casillas[i][j].setEditable(false);
							}
						}
			btnIniciarPartida.setEnabled(false);
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
				casillas[i][j].addKeyListener(new KeyAdapter() {
					   public void keyTyped(KeyEvent e) {
					      char c = e.getKeyChar();
					      if ( ((c < '0') || (c > '9')) && (c != KeyEvent.VK_BACK_SPACE)) {
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
						  tablero="[";
						  
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
						  
						  
						  x++; y++;
						  String agregar="agregar("+c+","+x+","+y+","+tablero+",X)";
						  Query q2=new Query(agregar);
						  boolean agrego=q2.hasSolution();
						  if (!agrego){
							  
							  JOptionPane.showMessageDialog(null, "Numero incorrecto.");
							  casillas[x-1][y-1].setText(null);
						  }
						
					   }
					 
					   
					   
				});
				
				casillas[i][j].setEnabled(false);
				casillas[i][j].setBorder(new LineBorder(new Color(0, 0, 0), 1));
				casillas[i][j].setHorizontalAlignment(SwingConstants.CENTER);
				cuadros[(i / 3)*3 + (j / 3)].add(casillas[i][j]);
			}
		
		btnIniciarPartida.setBounds(355, 23, 113, 23);
		frame.getContentPane().add(btnIniciarPartida);
		
		JButton button = new JButton("Crear Tablero");
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				for(int i=0;i<9;i++)
					for(int j=0;j<9;j++)
						casillas[i][j].setEnabled(true);
			}
		});
		button.setBounds(357, 78, 113, 23);
		frame.getContentPane().add(button);
		
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
