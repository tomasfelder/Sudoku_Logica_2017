import java.util.Timer;
import java.util.TimerTask;

import javax.swing.JLabel;
/**
 * @web http://www.jc-mouse.net
 * @author Mouse
 */
public class Tiempo  {

    private Timer timer = new Timer(); 
    private JLabel label;
    private int segundos=0;

    //Clase interna que funciona como contador
    class Contador extends TimerTask {
        public void run() {
            segundos++;
            label.setText("Tiempo: "+(segundos/60)/10+(segundos/60)%10+":"+(segundos%60)/10+(segundos % 60)%10);
        }
    }
    public Tiempo(JLabel lblTiempo) {
		label=lblTiempo;
	}
	//Crea un timer, inicia segundos a 0 y comienza a contar
    public void Contar()
    {
        this.segundos=0;
        timer = new Timer();
        timer.schedule(new Contador(), 0, 1000);
    }
    //Detiene el contador
    public void Detener() {
        timer.cancel();
    }
    //Metodo que retorna los segundos transcurridos
    public int getSegundos()
    {
        return this.segundos;
    }
}