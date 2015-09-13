contract lottopollo {
  address leader;
  uint    timestamp;
  
  function lottopollo() {
    log(1);
  }
  
  function () {
    if (timestamp > 0 && now - timestamp > 24 hours) { // "24 hours" is the time period, and varies per lottery
      msg.sender.send(msg.value);
      
      if (this.balance > 0) {
        leader.send(this.balance);
        log(4);
      }
      else {
        log(5);
      }
    }
    else if (msg.value >= 1 ether) {
      leader = msg.sender;
      timestamp = now;
      log(2);
    }
    else {
      log(3);
    }
  }
  
  event log(uint status);
}
