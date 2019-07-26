package synapsis.model;

import synapsis.ConnectionStatus;

public class SynapsisMindInfo {
   
   private String entityName;
   
   private ConnectionStatus synapsisStatus = ConnectionStatus.DISCONNECTED;
   
   private ConnectionStatus bodyStatus = ConnectionStatus.DISCONNECTED;
   
   private int currentReconnectionAttempt = 0;
   
   private int numberOfReceivedMessages = 0;
   private long totalSendTime = 0;
   private long totalComputationTime = 0;
   private long totalReceiveTime = 0;
   private long totalTime = 0;
   
   public SynapsisMindInfo(String name) {
      this.entityName = name;
   }

   public String getEntityName() {
      return entityName;
   }

   public ConnectionStatus getSynapsisStatus() {
      return synapsisStatus;
   }

   public void setSynapsisStatus(ConnectionStatus synapsisStatus) {
      this.synapsisStatus = synapsisStatus;
   }

   public ConnectionStatus getBodyStatus() {
      return bodyStatus;
   }

   public void setBodyStatus(ConnectionStatus bodyStatus) {
      this.bodyStatus = bodyStatus;
   }

   public int getCurrentReconnectionAttempt() {
      return currentReconnectionAttempt;
   }

   public void setCurrentReconnectionAttempt(int currentReconnectionAttempt) {
      this.currentReconnectionAttempt = currentReconnectionAttempt;
   }
   
   public void addNewMessage(Message message) {
      this.numberOfReceivedMessages++;
      this.totalSendTime += message.getTimeFromSenderToSynapsis();
      this.totalComputationTime += message.getSynapsisComputation();
      this.totalReceiveTime += message.getTimeFromSynapsisToReceiver();
      this.totalTime += message.getTotalTime();
   }

}
