Contract tictactoeth{

	// Setup structure and array for games
	struct Game {
		mapping (uint => address) players;
		bytes32 gameState;
		uint wager;
		uint deadline;
		bytes32 gameState;
	};

	Game[] public games;

	// Setup ownership to collect 1% donation on stalemates 
    address public owner;
    uint public collectedFees;

    function tictactoeth() {
        owner = msg.sender;
    }

    function collectFees(address recipient){
		if (msg.sender == owner)
	        if (collectedFees == 0) return;
	        recipient.send(collectedFees);
	        collectedFees = 0;
	    }
	   	else{ return false; }
    }

    // Initialize new game.
	function newGame(uint move, uint blocktime){
		if( move > 8 ){ return false; }
		else{
			uint idx = games.length;
        	games.length += 1;
        	games[idx].players.length += 1;
        	games[idx].players[0] = msg.sender;
        	games[idx].wager = msg.amount;
			games[idx].deadline = block.number + blocktime;
			games[idx].gameState[move] = "O";
			return idx
		}
	}

	// Process new moves.
	function newMove(uint idx, uint move){

		// Check for valid game and valid move.
		if( idx >= games.length){ return false; }
		if( move > 8 || games[idx].gameState[move] == 'O' || games[idx].gameState[move] == 'X' ){ return false; }


		uint i;
		uint numO;
		uint numX;
		while( i < 9 ){
			if( games[idx].gamestate[i] == 'O' ){ numO++; }
			else if ( games[idx].gamestate[i] == 'X'){ numX++; }
		}

		// Process new player if second move.
		if( numO == 1 && numX ==0 ){
			if( msg.amount < games[idx].wager ){
				msg.sender.send( msg.amount );
				return false;
			}
			else if( msg.amount > games[idx].wager ){
				msg.sender.send( msg.amount - games[idx].wager );
			}
			games[idx].players.length += 1;
        	games[idx].players[1] = msg.sender;
		}
		// If not second move, return any ether to sender.
		else if (msg.amount > 0){
				msg.sender.send( msg.amount );
		}

		// Check for correct player.
		if( numO > numX && msg.sender = games[idx].players[1] ){
			games[idx].gameState[move] = 'X';
		}
		else if ( numO = numX && msg.sender = games[idx].players[0] ) ){
			games[idx].gameState[move] = 'O';
		}
		else{ return false; }

		// Check for win.
		if( (games[idx].gameState[0] == 'O' && games[idx].gameState[3] == 'O' && games[idx].gameState[6] == 'O' ) ||
			(games[idx].gameState[1] == 'O' && games[idx].gameState[4] == 'O' && games[idx].gameState[7] == 'O' ) ||
			(games[idx].gameState[2] == 'O' && games[idx].gameState[5] == 'O' && games[idx].gameState[8] == 'O' ) ||
			(games[idx].gameState[0] == 'O' && games[idx].gameState[1] == 'O' && games[idx].gameState[2] == 'O' ) ||
			(games[idx].gameState[3] == 'O' && games[idx].gameState[4] == 'O' && games[idx].gameState[5] == 'O' ) ||
			(games[idx].gameState[6] == 'O' && games[idx].gameState[7] == 'O' && games[idx].gameState[8] == 'O' ) ||
			(games[idx].gameState[0] == 'O' && games[idx].gameState[4] == 'O' && games[idx].gameState[8] == 'O' ) ||
			(games[idx].gameState[2] == 'O' && games[idx].gameState[4] == 'O' && games[idx].gameState[6] == 'O' )
			){
				games[idx].players[0].send( games[idx].wager * 2 );
			}
		else if( (games[idx].gameState[0] == 'X' && games[idx].gameState[3] == 'X' && games[idx].gameState[6] == 'X' ) ||
			(games[idx].gameState[1] == 'X' && games[idx].gameState[4] == 'X' && games[idx].gameState[7] == 'X' ) ||
			(games[idx].gameState[2] == 'X' && games[idx].gameState[5] == 'X' && games[idx].gameState[8] == 'X' ) ||
			(games[idx].gameState[0] == 'X' && games[idx].gameState[1] == 'X' && games[idx].gameState[2] == 'X' ) ||
			(games[idx].gameState[3] == 'X' && games[idx].gameState[4] == 'X' && games[idx].gameState[5] == 'X' ) ||
			(games[idx].gameState[6] == 'X' && games[idx].gameState[7] == 'X' && games[idx].gameState[8] == 'X' ) ||
			(games[idx].gameState[0] == 'X' && games[idx].gameState[4] == 'X' && games[idx].gameState[8] == 'X' ) ||
			(games[idx].gameState[2] == 'X' && games[idx].gameState[4] == 'X' && games[idx].gameState[6] == 'X' )
			){
				games[idx].players[1].send( games[idx].wager * 2 );
			}
		// Check for stalemate or expired.
		else if ( numO + numX ==9 || games[idx].deadline < block.number ){
			uint fee = games[idx].wager / 100;
			owner.send( 2 * fee );
			games[idx].players[0].send( games[idx].wager - fee );
			games[idx].players[1].send( games[idx].wager - fee );
		}

	}

}
