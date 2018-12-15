// Internal action code for project helloworld

package clock;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class now extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action 'clock.now'");
        NumberTerm result = new NumberTermImpl(System.currentTimeMillis());
        return un.unifies(result,args[0]);
    }
}
