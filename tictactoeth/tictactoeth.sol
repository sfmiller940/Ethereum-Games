contract tictactoeth{

	// Setup structure and array for games
	struct Game {
		address[2] players;
		uint[9] gameState;
		uint wager;
		uint deadline;
	}

	Game[] public games;

	// Setup ownership to collect 1% donation on stalemates 
	address public owner;
	uint public collectedFees;

	function tictactoeth() {
		owner = msg.sender;
	}

	function collectFees(address recipient){
		if (msg.sender == owner){
			if (collectedFees == 0) return;
			recipient.send(collectedFees);
			collectedFees = 0;
		}
	}

	// Initialize new game.
	function newGame(uint move, uint blocktime) returns (uint idx){
		if( move > 8 ){ 
			msg.sender.send( msg.value );
			return; 
		}
		idx = games.length;
		games[idx].players[0] = msg.sender;
		games[idx].wager = msg.value;
		games[idx].deadline = block.number + blocktime;
		games[idx].gameState[move] = 0;
		return idx;
	}

	// Process new moves.
	function newMove(uint idx, uint move){

		// Check for valid game and valid move.
		if( idx >= games.length ||  move > 8 || games[idx].gameState[move] == 0 || games[idx].gameState[move] == 1 ){ 
			msg.sender.send( msg.value );
			return;
		}

		// Count Os and Xs.
		uint i;
		uint numO;
		uint numX;
		while( i < 9 ){
			if( games[idx].gameState[i] == 0 ){ numO++; }
			else if ( games[idx].gameState[i] == 1){ numX++; }
		}

		// Process new player if second move.
		if( 1 == numO + numX ){
			if( msg.value < games[idx].wager ){
				msg.sender.send( msg.value );
				return;
			}
			if( msg.value > games[idx].wager ){
				msg.sender.send( msg.value - games[idx].wager );
			}
			games[idx].players[1] = msg.sender;
		}
		// If not second move, return any ether to sender.
		if ( 1 != numO + numX && msg.value > 0){
				msg.sender.send( msg.value );
		}

		// Make move if correct player.
		if( ( numO > numX ) && ( msg.sender == games[idx].players[1] ) ){
			games[idx].gameState[move] = 1;
		}
		if ( ( numO == numX ) && ( msg.sender == games[idx].players[0] ) ){
			games[idx].gameState[move] = 0;
		}

		// Check for win.
		if( (games[idx].gameState[0] == 0 && games[idx].gameState[3] == 0 && games[idx].gameState[6] == 0 ) ||
			(games[idx].gameState[1] == 0 && games[idx].gameState[4] == 0 && games[idx].gameState[7] == 0 ) ||
			(games[idx].gameState[2] == 0 && games[idx].gameState[5] == 0 && games[idx].gameState[8] == 0 ) ||
			(games[idx].gameState[0] == 0 && games[idx].gameState[1] == 0 && games[idx].gameState[2] == 0 ) ||
			(games[idx].gameState[3] == 0 && games[idx].gameState[4] == 0 && games[idx].gameState[5] == 0 ) ||
			(games[idx].gameState[6] == 0 && games[idx].gameState[7] == 0 && games[idx].gameState[8] == 0 ) ||
			(games[idx].gameState[0] == 0 && games[idx].gameState[4] == 0 && games[idx].gameState[8] == 0 ) ||
			(games[idx].gameState[2] == 0 && games[idx].gameState[4] == 0 && games[idx].gameState[6] == 0 )
			){
				games[idx].players[0].send( games[idx].wager * 2 );
				return;
			}
		if( (games[idx].gameState[0] == 1 && games[idx].gameState[3] == 1 && games[idx].gameState[6] == 1 ) ||
			(games[idx].gameState[1] == 1 && games[idx].gameState[4] == 1 && games[idx].gameState[7] == 1 ) ||
			(games[idx].gameState[2] == 1 && games[idx].gameState[5] == 1 && games[idx].gameState[8] == 1 ) ||
			(games[idx].gameState[0] == 1 && games[idx].gameState[1] == 1 && games[idx].gameState[2] == 1 ) ||
			(games[idx].gameState[3] == 1 && games[idx].gameState[4] == 1 && games[idx].gameState[5] == 1 ) ||
			(games[idx].gameState[6] == 1 && games[idx].gameState[7] == 1 && games[idx].gameState[8] == 1 ) ||
			(games[idx].gameState[0] == 1 && games[idx].gameState[4] == 1 && games[idx].gameState[8] == 1 ) ||
			(games[idx].gameState[2] == 1 && games[idx].gameState[4] == 1 && games[idx].gameState[6] == 1 )
			){
				games[idx].players[1].send( games[idx].wager * 2 );
				return;
			}
		// Check for stalemate or expired.
		if ( numO + numX == 9 || games[idx].deadline < block.number ){
			uint fee = games[idx].wager / 100;
			collectedFees += 2 * fee;
			games[idx].players[0].send( games[idx].wager - fee );
			games[idx].players[1].send( games[idx].wager - fee );
		}

	}

}
