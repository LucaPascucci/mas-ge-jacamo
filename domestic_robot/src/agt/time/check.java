// Internal action code for project domestic_robot

package time;

import java.text.SimpleDateFormat;
import java.util.Date;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class check extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action 'time.check'");
        final String time = (new SimpleDateFormat("HH:mm:ss")).format(new Date());
        ts.getLogger().info("Check Time=" + time);
        return un.unifies(args[0], new StringTermImpl(time));
    }
}
