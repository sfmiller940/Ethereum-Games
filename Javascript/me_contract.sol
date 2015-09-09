contract Me {
  address myAddress;
  uint dateJoined;
  function Me(){
    myAddress = msg.sender;
    dateJoined = block.timestamp;
  }   
}
