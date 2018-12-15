package artifacts;

import cartago.*;

//Proprietà osservabile = campo che può essere monitorato da un agente

public class Counter extends Artifact {
	
	//costruttore dell'artefatto
	void init(int initialValue) {
		//definizione delle proprietà osservabili
		this.defineObsProperty("count", initialValue);
	}

	//annotazione per definire una operazione dell'artefatto
	@OPERATION
	void inc() {
		//ottengo la proprietà con chiave "count" dalle proprietà osservabili
		ObsProperty prop = this.getObsProperty("count");
		
		//Set di primitive per lavorare con gli artefatti (defineset of primitives to work define/update/.. observableproperties
		prop.updateValue(prop.intValue()+1);
		
		//Metodo inviare un segnale che genera l'aggiunta di un belief di tipo "tick" a tutti gli agenti che osservano l'artefatto
		signal("tick");
	}
}

