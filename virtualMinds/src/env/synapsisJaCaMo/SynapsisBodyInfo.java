package synapsisJaCaMo;

public class SynapsisBodyInfo {
   
   public String entityName;
   
   public ConnectionStatus synapsisStatus = ConnectionStatus.DISCONNECTED;
   
   public ConnectionStatus bodyStatus = ConnectionStatus.DISCONNECTED;
   
   public int currentReconnectionAttempt = 0;
   
   
   public SynapsisBodyInfo(String name) {
      this.entityName = name;
   }

}
