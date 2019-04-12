// Internal action code for project helloworld

package math;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class distance extends DefaultInternalAction {

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
		// execute the internal action
		ts.getAg().getLogger().info("executing internal action 'math.distance'");
		try {
			// 1. gets the arguments as typed terms
			NumberTerm p1x = (NumberTerm)args[0];
			NumberTerm p1y = (NumberTerm)args[1];
			NumberTerm p2x = (NumberTerm)args[2];
			NumberTerm p2y = (NumberTerm)args[3];
			// 2. calculates the distance
			double r = Math.abs(p1x.solve()-p2x.solve()) + Math.abs(p1y.solve()-p2y.solve());
			// 3. creates the term with the result andunifies the result with the 5th argument
			NumberTerm result = new NumberTermImpl(r);
			return un.unifies(result,args[4]);
		} catch (ArrayIndexOutOfBoundsException e) {
			throw new JasonException("The internal action ’distance’ has not received five arguments!");
		} catch (ClassCastException e) {
			throw new JasonException("The internal action ’distance’ has received arguments that are not numbers!");
		} catch (Exception e) {
			throw new JasonException("Error in ’distance’");
		}
	}
}
