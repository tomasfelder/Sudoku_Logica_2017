import java.io.*;

public class Mapa {
	
	protected static final int TAMANO=9;
	
	//Atributos de instancia
	protected char[][] matriz;
	protected String linea;
	protected BufferedReader br;
	
	//Constructor
	public Mapa(String dificultad){
		matriz=new char[TAMANO][TAMANO];
		try {
			br= new BufferedReader(new FileReader("tableros_java.txt"));
			boolean encontre=false;
			while ((linea = br.readLine()) != null && !encontre) {
				 	encontre = linea.indexOf(dificultad)!= -1;
			 }
			if(encontre){
				for(int i=0;i<TAMANO;i++){
					int nroEnFila=0;
					for(int j=0;j<linea.length();j++){
						if(linea.charAt(j)!=','){
							matriz[i][nroEnFila]=linea.charAt(j);
							nroEnFila++;
						}
					}
					linea=br.readLine();
				}
			}
		}catch (IOException e){
			e.printStackTrace();
		}
		finally{
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	public Mapa() {
		matriz=new char[TAMANO][TAMANO];
	}

	public void setElemento(int x,int y,char c){
		matriz[x][y]=c;
	}
	
	public char	getElemento(int x, int y){
		return matriz[x][y];
	}
	
}
