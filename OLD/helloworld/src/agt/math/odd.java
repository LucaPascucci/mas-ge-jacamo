/*
 * ESEMPIO DI Internal actions and backtracking
 * 
 */

package math;

import java.util.Iterator;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class odd extends DefaultInternalAction {

	@Override
	public Object execute(final TransitionSystem ts, final Unifier un, final Term[] args) throws Exception {
		// execute the internal action
		ts.getAg().getLogger().info("executing internal action 'math.odd'");
		if (! args[0].isVar()) {
			// the argument is not a variable, single answer
			if (args[0].isNumeric()) {
				NumberTerm n = (NumberTerm)args[0];
				return n.solve() % 2 == 1;
			} else { 
				return false;
			}
		} else {
			// ritorna un iteratore di unifiers, dove ogni unifier contiene l'argomento args[0] assegnato as un numero dispari
			return new Iterator<Unifier>() {
				
				int last = 1;
				
				// we always have a next odd number
				public boolean hasNext() { return true; }
				
				public Unifier next() {
					Unifier c = (Unifier)un.clone();
					c.unifies(new NumberTermImpl(last), args[0]);
					last += 2;
					return c;
				}
				
				public void remove() {}
			};
		}

	}
}
