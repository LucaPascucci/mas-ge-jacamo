package ia;

import java.text.SimpleDateFormat;
import java.util.Date;

import jason.JasonException;
import jason.NoValueException;
import jason.asSemantics.*;
import jason.asSyntax.*;
import jason.asSyntax.parser.ParseException;

public class prova extends DefaultInternalAction {

	/**
	 * Metodo invocato per eseguire la Internal A
	 * @TransitionSystem ts = contiene le informazioni sullo stato corrente dell'agente che utili
	 * @Unifier = funzione unificatrice determinata dalla esecuzione del piano
	 * @Term = array di argomenti passati 
	 */
	@Override
	public Object execute(TransitionSystem ts, Unifier un,Term[] args) throws Exception {

		ts.getAg().getLogger().info("INTERNAL ACTION 'ia.prova' -> da " + ts.getAg().toString());

		if (args[0].isString()) {
			StringTerm message = (StringTerm)args[0];
			ts.getAg().getLogger().info("message: " + message.getString());
		} else {
			ts.getAg().getLogger().info("Il termine passato non è una stringa");
		}

		final String time = (new SimpleDateFormat("HH:mm:ss")).format(new Date());
		ts.getLogger().info("Check Time=" + time);
		return un.unifies(args[1], new StringTermImpl(time));
	}

	/**
	 * Il secondo metodo della classe DefaultInternalAction che deve tornare TRUE quando
	 * la Internal Action è sospensiva (come ad esempio con le internalAction .at .send .askOne)
	 * 
	 */
	@Override
	public boolean suspendIntention() {
		return false;
	}

	private double getNumberFromArgs(TransitionSystem ts, Term[] args) {
		if (!args[0].isNumeric()) {
			NumberTerm nt = (NumberTerm)args[0];
			try {
				return nt.solve();
			} catch (NoValueException e) {
				ts.getLogger().info("Error in ia.prova.getNumberFromArgs");
			}
		} else {
			ts.getLogger().info("l'argomento passato non è un ");
		}
		return 0;
	}

	private void addGoal(final TransitionSystem ts, final String g) {
		try {
			addGoal(ts, ASSyntax.parseLiteral(g));
		} catch (Exception e) {
			ts.getLogger().info("Parsing '"+g+"' as literal for a goal failed!");
		}
	}
	private void addGoal(final TransitionSystem ts, final Literal g) {
		ts.getC().addAchvGoal(g, Intention.EmptyInt);
	}


	private void addPlan(final TransitionSystem ts, final String p) {
		try {
			ts.getAg().getPL().add(ASSyntax.parsePlan(p));
			//TODO se getPL non è per riferimento è necessario utilizzare .setPL(PlanLibrary).
		} catch (JasonException | ParseException e) {
			ts.getLogger().info("Parsing '" + p + "' as Plan for a plan failed!");
			//e.printStackTrace();
		}
	}
}