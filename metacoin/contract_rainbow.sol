contract rainbowCoin {
	mapping (address => mapping (uint => uint)) public balances;
	function rainbowCoin() {
		balances[msg.sender][0] = 10000; ///red coin
		balances[msg.sender][1] = 10000; ///orange coin
		balances[msg.sender][2] = 10000; ///yellow coin
		balances[msg.sender][3] = 10000; ///green coin
		balances[msg.sender][4] = 10000; ///blue coin
		balances[msg.sender][5] = 10000; ///indigo coin
		balances[msg.sender][6] = 10000; ///violet coin
	}
	function sendCoin(address receiver, uint amount, uint coin) returns(bool successful) {
		if (balances[msg.sender][coin] < amount) return false;
		balances[msg.sender][coin] -= amount;
		balances[receiver][coin] += amount;
		return true;
	}
}
