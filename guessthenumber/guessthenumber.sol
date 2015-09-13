contract guessthenumber{

	// Tips are much appreciated!
	address public owner;
	function guessthenumber(){
		owner = msg.sender;
	}

	// Ideal organizational scheme?
	uint public numGames;
	mapping (uint => address) public players; // not public?
	mapping (uint => uint) numbers;           // not public != secure?
	mapping (uint => uint) public ranges;
	mapping (uint => uint) public wagers;


	// Events?
	function newGame( uint number, uint range){

		// Reject zero wagers and out of bounds.
		if( number < 1 || number > range || msg.value == 0) return;

		players[numGames] = msg.sender;
		numbers[numGames] = number;
		ranges[numGames] = range;
		wagers[numGames] = msg.value;

		numGames++;

	}

	function newGuess(uint idx, uint number){

		uint bet = wagers[idx] / ranges[idx];

		// Reject bad ID, number or value.
		if( idx > numGames || number > ranges[idx] || number < 1 || msg.value < bet ){
			msg.sender.send( msg.value );
			return;
		}

		// Partial refund for overpayment.
		if(msg.value > bet) msg.sender.send( msg.value - bet );
		
		// Payout. Events?
		players[idx].send( bet );
		
		if(number == numbers[idx]){
			msg.sender.send( wagers[idx] );
			wagers[idx] = 0;
		} 

	}

}
