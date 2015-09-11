contract tictactoeth{

	enum marks { O, X }

	// Setup structure and array for games
	struct Game {
		address[2] players;
		marks[9] gameState;
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
		games[idx].gameState[move] = marks.O;
		return idx;
	}

	// Process new moves.
	function newMove(uint idx, uint move){

		// Check for valid game and valid move.
		if( idx >= games.length ||  move > 8 || games[idx].gameState[move] == marks.O || games[idx].gameState[move] == marks.X ){ 
			msg.sender.send( msg.value );
			return;
		}

		// Count Os and Xs.
		uint i;
		uint numO;
		uint numX;
		while( i < 9 ){
			if( games[idx].gameState[i] == marks.O ){ numO++; }
			else if ( games[idx].gameState[i] == marks.X){ numX++; }
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
			games[idx].gameState[move] = marks.X;
		}
		if ( ( numO == numX ) && ( msg.sender == games[idx].players[0] ) ){
			games[idx].gameState[move] = marks.O;
		}

        // Check for win or stalemate.
        if(numO + numX > 4){
            if( (games[idx].gameState[0] == marks.O && games[idx].gameState[3] == marks.O && games[idx].gameState[6] == marks.O ) ||
                (games[idx].gameState[1] == marks.O && games[idx].gameState[4] == marks.O && games[idx].gameState[7] == marks.O ) ||
                (games[idx].gameState[2] == marks.O && games[idx].gameState[5] == marks.O && games[idx].gameState[8] == marks.O ) ||
                (games[idx].gameState[0] == marks.O && games[idx].gameState[1] == marks.O && games[idx].gameState[2] == marks.O ) ||
                (games[idx].gameState[3] == marks.O && games[idx].gameState[4] == marks.O && games[idx].gameState[5] == marks.O ) ||
                (games[idx].gameState[6] == marks.O && games[idx].gameState[7] == marks.O && games[idx].gameState[8] == marks.O ) ||
                (games[idx].gameState[0] == marks.O && games[idx].gameState[4] == marks.O && games[idx].gameState[8] == marks.O ) ||
                (games[idx].gameState[2] == marks.O && games[idx].gameState[4] == marks.O && games[idx].gameState[6] == marks.O )
                ){
                    games[idx].players[0].send( games[idx].wager * 2 );
                    return;
                }
            if( (games[idx].gameState[0] == marks.X && games[idx].gameState[3] == marks.X && games[idx].gameState[6] == marks.X ) ||
                (games[idx].gameState[1] == marks.X && games[idx].gameState[4] == marks.X && games[idx].gameState[7] == marks.X ) ||
                (games[idx].gameState[2] == marks.X && games[idx].gameState[5] == marks.X && games[idx].gameState[8] == marks.X ) ||
                (games[idx].gameState[0] == marks.X && games[idx].gameState[1] == marks.X && games[idx].gameState[2] == marks.X ) ||
                (games[idx].gameState[3] == marks.X && games[idx].gameState[4] == marks.X && games[idx].gameState[5] == marks.X ) ||
                (games[idx].gameState[6] == marks.X && games[idx].gameState[7] == marks.X && games[idx].gameState[8] == marks.X ) ||
                (games[idx].gameState[0] == marks.X && games[idx].gameState[4] == marks.X && games[idx].gameState[8] == marks.X ) ||
                (games[idx].gameState[2] == marks.X && games[idx].gameState[4] == marks.X && games[idx].gameState[6] == marks.X )
                ){
                    games[idx].players[1].send( games[idx].wager * 2 );
                    return;
                }
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
