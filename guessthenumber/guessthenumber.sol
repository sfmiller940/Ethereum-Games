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
		if( number > range ) return;
		players[numGames] = msg.sender;
		numbers[numGames] = number;
		ranges[numGames] = range;
		wagers[numGames] = msg.value;
		numGames++;
	}

	function guessNumber(uint idx, uint number){
		uint bet = wagers[idx] /ranges[idx];
		if(idx > numGames) return; 
		if(number > ranges[idx]) return;
		if(msg.value < bet ){
			msg.sender.send( msg.value );
			return;
		}
		if(msg.value > bet) msg.sender.send( msg.value - bet );
		if(number != numbers[idx]){ players[idx].send( bet ); }
		else{ 
			msg.sender.send( wagers[idx] );
			owner.send( bet );
			wagers[idx] = 0;
		} 
	}

}
