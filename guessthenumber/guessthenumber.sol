contract guessthenumber{

	// Tips are much appreciated!
	address public owner;
	function guessthenumber(){
		owner = msg.sender;
	}

	uint public numGames;
	mapping (uint => address) public players;
	mapping (uint => uint) numbers;           // not public != secure?
	mapping (uint => uint) public ranges;
	mapping (uint => uint) public wagers;

	event newGame( uint indexed idx, address indexed player, uint range, uint wager );
	event newGuess( uint indexed idx, address indexed bettor );
	event newWin( uint indexed idx, address indexed bettor, uint number );

	function makeGame( uint number, uint range){

		// Reject zero wagers and out of bounds.
		if( number < 1 || number > range || msg.value == 0) return;

		players[numGames] = msg.sender;
		numbers[numGames] = number;
		ranges[numGames] = range;
		wagers[numGames] = msg.value;

		newGame(numGames, msg.sender, range, msg.value);

		numGames++;

	}

	function makeGuess(uint idx, uint number){

		uint bet = 2 * wagers[idx] / ranges[idx];

		// Reject bad ID, number or value.
		if( idx > numGames || number > ranges[idx] || number < 1 || msg.value < bet ){
			msg.sender.send( msg.value );
			return;
		}

		// Refund any overpayment.
		if(msg.value > bet) msg.sender.send( msg.value - bet );
		
		// Payout.
		newGuess( idx, msg.sender);
		players[idx].send( bet );
		
		if(number == numbers[idx]){
			msg.sender.send( wagers[idx] );
			wagers[idx] = 0;
			newWin(idx, msg.sender, number);
		} 

	}

}
