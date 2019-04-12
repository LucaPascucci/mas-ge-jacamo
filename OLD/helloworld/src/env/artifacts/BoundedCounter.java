package artifacts;

import cartago.*;

public class BoundedCounter extends Artifact {

	private int maxValue;

	void init(int maxValue) {
		defineObsProperty("count", 0);
		this.maxValue = maxValue; 
	}

	@OPERATION
	void incBounded() {
		ObsProperty prop = getObsProperty("count");
		if (prop.intValue() < this.maxValue){
			prop.updateValue(prop.intValue()+1);
			signal("tick");
		} else {
			
			/* failed(String failureMsg)
			 * oppure
			 * failed(String failureMsg, String descr, Object... args)
			 */
			failed("incBounded failed","incBounded_failed","max_value_reached",this.maxValue);
		}
	}
}

