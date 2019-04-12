// Internal action code for project helloworld

package math;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class randomInt extends DefaultInternalAction {

	private java.util.Random random = new java.util.Random();

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
		// execute the internal action
		ts.getAg().getLogger().info("executing internal action 'math.randomInt'");
		if (!args[0].isNumeric() || !args[1].isVar()) {
			throw new JasonException("check arguments");
		}
		try {
			
			int value = random.nextInt( (int)((NumberTerm)args[0]).solve() );
			
			return un.unifies(args[1], new NumberTermImpl(value));
		} catch (Exception e) {
			throw new JasonException("Error in internal action 'randomInt'", e);
		}
	}
}
