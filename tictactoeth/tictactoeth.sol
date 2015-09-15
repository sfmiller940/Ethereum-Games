contract tictactoeth{

	// Setup ownership 
	address public owner;
	uint public collectedFees;

	function tictactoeth_addr() {
		owner = msg.sender;
	}

	function collectFees(address recipient){
		if (msg.sender == owner){
			if (collectedFees == 0) return;
			recipient.send(collectedFees);
			collectedFees = 0;
		}
	}

	// Setup games.
	uint public numGames;
	mapping( uint => uint ) public deadline;
	mapping( uint => uint ) public wager;
	mapping( uint => address ) public playerO;
	mapping( uint => address ) public playerX;
	mapping( uint => uint[9] ) public gameState;

	// Initialize new game.
	function createGame(uint move, uint blockLife){
		if( move > 8 || blockLife > 10000000000000 ){ 
			return; 
		}
		deadline[numGames] = block.number + blockLife;
		wager[numGames] = msg.value;
		playerO[numGames] = msg.sender;
		gameState[numGames][move] = 1;
		numGames++;
	}

	// Process new moves.
	function createMove(uint idx, uint move){

		// Check for valid game and valid move.
		if( idx >= numGames ||  move > 8 || gameState[idx][move] == 1 || gameState[idx][move] == 2 ){ 
			msg.sender.send( msg.value );
			return;
		}

		// Count Os and Xs.
		uint numO;
		uint numX;
		uint i;
		while( i < 9 ){
			if( gameState[idx][i] == 1 ){ numO++; }
			else if ( gameState[idx][i] == 2){ numX++; }
			i++;
		}

		// Process new player if second move.
		if( 1 == numO + numX ){
			if( msg.value < wager[idx] ){
				msg.sender.send( msg.value );
				return;
			}
			if( msg.value > wager[idx] ){
				msg.sender.send( msg.value - wager[idx] );
			}
			playerX[idx] = msg.sender;
		}
		// If not second move, return any ether to sender.
		if ( 1 != numO + numX && msg.value > 0){
				msg.sender.send( msg.value );
		}

		// Make move if correct player.
		if( ( numO > numX ) && ( msg.sender == playerX[idx] ) ){
			gameState[idx][move] = 2;
		}
		else if ( ( numO == numX ) && ( msg.sender == playerO[idx] ) ){
			gameState[idx][move] = 1;
		}

        // Check for win or stalemate.
        if(numO + numX > 4){
            if( (gameState[idx][0] == 1 && gameState[idx][3] == 1 && gameState[idx][6] == 1 ) ||
                (gameState[idx][1] == 1 && gameState[idx][4] == 1 && gameState[idx][7] == 1 ) ||
                (gameState[idx][2] == 1 && gameState[idx][5] == 1 && gameState[idx][8] == 1 ) ||
                (gameState[idx][0] == 1 && gameState[idx][1] == 1 && gameState[idx][2] == 1 ) ||
                (gameState[idx][3] == 1 && gameState[idx][4] == 1 && gameState[idx][5] == 1 ) ||
                (gameState[idx][6] == 1 && gameState[idx][7] == 1 && gameState[idx][8] == 1 ) ||
                (gameState[idx][0] == 1 && gameState[idx][4] == 1 && gameState[idx][8] == 1 ) ||
                (gameState[idx][2] == 1 && gameState[idx][4] == 1 && gameState[idx][6] == 1 )
                ){
                    playerO[idx].send( wager[idx] * 2 );
                    return;
                }
            if( (gameState[idx][0] == 2 && gameState[idx][3] == 2 && gameState[idx][6] == 2 ) ||
                (gameState[idx][1] == 2 && gameState[idx][4] == 2 && gameState[idx][7] == 2 ) ||
                (gameState[idx][2] == 2 && gameState[idx][5] == 2 && gameState[idx][8] == 2 ) ||
                (gameState[idx][0] == 2 && gameState[idx][1] == 2 && gameState[idx][2] == 2 ) ||
                (gameState[idx][3] == 2 && gameState[idx][4] == 2 && gameState[idx][5] == 2 ) ||
                (gameState[idx][6] == 2 && gameState[idx][7] == 2 && gameState[idx][8] == 2 ) ||
                (gameState[idx][0] == 2 && gameState[idx][4] == 2 && gameState[idx][8] == 2 ) ||
                (gameState[idx][2] == 2 && gameState[idx][4] == 2 && gameState[idx][6] == 2 )
                ){
                    playerX[idx].send( wager[idx] * 2 );
                    return;
                }
        }

        // Check for stalemate or expired.
        if ( numO + numX == 9 || deadline[idx] < block.number ){
            uint fee = wager[idx] / 100;
            collectedFees += 2 * fee;
            playerO[idx].send( wager[idx] - fee );
            playerX[idx].send( wager[idx] - fee );
        }

	}

}
