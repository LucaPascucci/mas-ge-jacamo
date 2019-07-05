package synapsisJaCaMo;

public class SynapsisBodyInfo {
   
   private String entityName;
   
   private ConnectionStatus synapsisStatus = ConnectionStatus.DISCONNECTED;
   
   private ConnectionStatus bodyStatus = ConnectionStatus.DISCONNECTED;
   
   private int currentReconnectionAttempt = 0;
   
   private int numberOfReceivedMessages = 0;
   private long totalSendTime = 0;
   private long totalComputationTime = 0;
   private long totalReceiveTime = 0;
   private long totalTime = 0;
   
   public SynapsisBodyInfo(String name) {
      this.entityName = name;
   }

   public String getEntityName() {
      return entityName;
   }

   public ConnectionStatus getSynapsisStatus() {
      return synapsisStatus;
   }

   protected void setSynapsisStatus(ConnectionStatus synapsisStatus) {
      this.synapsisStatus = synapsisStatus;
   }

   public ConnectionStatus getBodyStatus() {
      return bodyStatus;
   }

   protected void setBodyStatus(ConnectionStatus bodyStatus) {
      this.bodyStatus = bodyStatus;
   }

   public int getCurrentReconnectionAttempt() {
      return currentReconnectionAttempt;
   }

   protected void setCurrentReconnectionAttempt(int currentReconnectionAttempt) {
      this.currentReconnectionAttempt = currentReconnectionAttempt;
   }
   
   protected void addNewMessage(Message message) {
      this.numberOfReceivedMessages++;
      this.totalSendTime += message.getTimeFromSenderToSynapsis();
      this.totalComputationTime += message.getSynapsisComputation();
      this.totalReceiveTime += message.getTimeFromSynapsisToReceiver();
      this.totalTime += message.getTotalTime();
   }

}
