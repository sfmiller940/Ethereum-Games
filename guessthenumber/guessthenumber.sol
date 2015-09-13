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

		if( number >= range ) return;

		players[numGames] = msg.sender;
		numbers[numGames] = number;
		ranges[numGames] = range;
		wagers[numGames] = msg.value;
		numGames++;
	}

	function guessNumber(uint idx, uint number){

		uint bet = wagers[idx] /ranges[idx];

		if( idx > numGames || number >= ranges[idx] || msg.value < bet ){
			msg.sender.send( msg.value );
			return;
		}

		if(msg.value > bet) msg.sender.send( msg.value - bet );
		
		players[idx].send( bet );
		
		if(number == numbers[idx]){
			msg.sender.send( wagers[idx] );
			wagers[idx] = 0;
		} 

	}

}
