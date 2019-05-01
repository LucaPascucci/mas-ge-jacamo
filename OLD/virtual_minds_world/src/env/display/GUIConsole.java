package display;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.SwingUtilities;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;

public class GUIConsole extends Artifact {

    private Display display;

    void init(String name) {
        // creates an observable property called numMsg
        this.defineObsProperty("numMsg",0);
        this.display = new Display(name);
        this.display.setVisible(true);
    }

    // implements an operation available to the agents
	@OPERATION 
    void printMsg(String msg){
        String agentName = this.getCurrentOpAgentId().getAgentName();
        ObsProperty prop = this.getObsProperty("numMsg");
        prop.updateValue(prop.intValue()+1);
        this.display.addText("Message at " + System.currentTimeMillis() + " from " + agentName + ": " + msg);
        this.display.updateNumMsgField(prop.intValue());
    }

    static class Display extends JFrame {

		private static final long serialVersionUID = 6302314565020560293L;
		
		private JTextArea text;
        private JLabel numMsg;
        private static int n = 0;

        public Display(String name) {
            setTitle(".:: " + name + " console ::.");

            JPanel panel = new JPanel();
            setContentPane(panel);
            panel.setLayout(new BoxLayout(panel,BoxLayout.Y_AXIS));

            this.numMsg = new JLabel("0");
            this.text = new JTextArea(15,40);

            panel.add(this.text);
            panel.add(Box.createVerticalStrut(5));
            panel.add(this.numMsg);
            pack();
            setLocation(n*40, n*80);
            setVisible(true);

            n++;
        }

        public void addText(final String s){
            SwingUtilities.invokeLater(new Runnable(){
                public void run() {
                    text.append(s+"\n");
                }
            });
        }

        public void updateNumMsgField(final int value){
            SwingUtilities.invokeLater(new Runnable(){
                public void run() {
                    numMsg.setText(""+value);
                }
            });
        }
    }
}