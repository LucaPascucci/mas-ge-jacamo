// Internal action code for project helloworld

package jia;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

//Deve sempre iniziare con una lettera minuscola
public class get extends DefaultInternalAction {

	/*
     * Metodo invocato per eseguire la Internal A
     * TransitionSystem ts = contiene le informazioni sullo stato corrente dell'agente che utili
     * Unifier = funzione unificatrice determinata dalla esecuzione del piano
     * Term = array di argomenti passati 
     */
	@Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        
        ts.getAg().getLogger().info("executing internal action 'jia.get'");

        //Per tornare un valore numerico alla 
        NumberTerm result = new NumberTermImpl(11);
        return un.unifies(result,args[0]);
    }
    
	/*
	 * Il secondo metodo della classe DefaultInternalAction che deve tornare TRUE quando
	 * la Internal Action è sospensiva (come ad esempio con le internalAction .at .send .askOne)
	 * 
	 */
    @Override
    public boolean suspendIntention() {
		return false;
    }
}
