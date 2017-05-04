

import org.jpl7.Query;
import org.jpl7.Term;

public class Main {
	
	public static void main(String[] args) {
		Query q=new Query("consult('logica.pl')");
		System.out.println(q.hasSolution());
		Query q1=new Query("resolver([[5,1,0,0,0,0,0,0,4], "
				+ "[0,0,0,0,5,8,3,1,6],"
				+ "[6,0,0,0,0,0,7,0,0],"
				+ "[0,0,0,0,0,3,0,0,0],"
				+ "[0,0,0,0,0,0,2,0,0],"
				+ "[0,0,1,0,0,0,0,0,0],"
				+ "[0,0,0,0,0,4,0,0,0],"
				+ "[0,0,9,0,0,0,0,0,8],"
				+ "[2,0,0,0,0,0,0,0,7]]"
				+ ",X)");
		
		Term tablero=q1.oneSolution().get("X");
		Term[] t=tablero.toTermArray();
		Term[] fila=t[0].toTermArray();
		System.out.print("[");
		for(Term x: t){
			System.out.print("[");
			for(Term y:x.toTermArray()){
				System.out.print(y+",");
			}
			
			System.out.println("],");
		}
		System.out.print("]");
	}
	
}