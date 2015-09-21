contract twitter {     
	mapping(address => Account) accounts;
	struct Account {         
		string alias;
		uint currentMessage;
		mapping(uint => Message) messages;
	}
	struct Message {
	    string message;
	}
	
	event NewMessage(address sender, string alias, string message);
    
    function status(string alias) { 
        Account account = accounts[msg.sender];
        account.alias=alias;
        account.currentMessage=0;
    }

    function send(string message) returns(bool sent) {         
    	Account account = accounts[msg.sender];
    	account.message[account.currentMessage]=message;
    	account.currentMessage++;
    	NewMessage(msg.sender, account.alias, message);
    	return true;
    }
    
}
