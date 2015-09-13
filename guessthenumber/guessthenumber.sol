contract guessthenumber{

	address public owner;
	uint public numGames;
	mapping (uint => address) players;
	mapping (uint => uint) numbers;
	mapping (uint => uint) public ranges;
	mapping (uint => uint) public wagers;

	function guessthenumber(){
		owner = msg.sender;
	}

	function newGame( uint number, uint range){
		players[numGames] = msg.sender;
		numbers[numGames] = number;
		ranges[numGames] = range;
		wagers[numGames] = msg.value;
		numGames++;
	}

	function guessNumber(uint idx, uint number){
		if(idx > numGames) return; 
		if(number > ranges[idx]) return;
		if(msg.value < wagers[idx] / ranges[idx]){
			msg.sender.send( msg.value );
			return;
		}
		if(msg.value > wagers[idx] / ranges[idx]) msg.sender.send( msg.value - ( wagers[idx] / ranges[idx] ) );
		if(number != numbers[idx]){ players[idx].send( wagers[idx] / ranges[idx] ); }
		else{ 
			msg.sender.send( wagers[idx] );
			wagers[idx] = 0;
		} 
	}

}
