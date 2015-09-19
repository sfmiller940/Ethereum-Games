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

	event newGame( uint idx );
	event newMove( uint idx );
	event winGame( uint idx, address winner );
	event expireGame( uint idx );
	event staleGame( uint idx );

	// Initialize new game.
	function createGame(uint move, uint blockLife){
		if( move > 8 || blockLife > 10000000000000 ){ 
			msg.sender.send( msg.value );
			return; 
		}
		deadline[numGames] = block.number + blockLife;
		wager[numGames] = msg.value;
		playerO[numGames] = msg.sender;
		gameState[numGames][move] = 1;

		newGame( numGames );
		numGames++;
	}

	// Process new moves.
	function createMove(uint idx, uint move){

		uint bet = wager[idx] / 3;

		// Check for expired.
		if( deadline[idx] > block.number ){
			msg.sender.send( msg.value );
            		playerO[idx].send( wager[idx] );
            		playerX[idx].send( bet );
            		expireGame(idx);
		}

		// Check for valid game and valid move.
		if( idx >= numGames ||  move > 8 || gameState[idx][move] == 1 || gameState[idx][move] == 2 || wager[idx] == 0 ){ 
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
			if( msg.value < bet ){
				msg.sender.send( msg.value );
				return;
			}
			if( msg.value > bet ){
				msg.sender.send( msg.value - bet );
			}
			playerX[idx] = msg.sender;
		}
		// If not second move, return any ether to sender.
		else if (  msg.value > 0 ){
				msg.sender.send( msg.value );
		}

		// Make move if correct player.
		if( ( numO > numX ) && ( msg.sender == playerX[idx] ) ){
			gameState[idx][move] = 2;
		}
		else if ( ( numO == numX ) && ( msg.sender == playerO[idx] ) ){
			gameState[idx][move] = 1;
		}

		// Check for win
        	if(numO + numX > 3){
            		uint fee = ( wager[idx] + bet ) / 100;
	            	if( ((gameState[idx][0] == 1) && (gameState[idx][3] == 1) && (gameState[idx][6] == 1) ) ||
	                ((gameState[idx][1] == 1) && (gameState[idx][4] == 1) && (gameState[idx][7] == 1) ) ||
	                ((gameState[idx][2] == 1) && (gameState[idx][5] == 1) && (gameState[idx][8] == 1) ) ||
	                ((gameState[idx][0] == 1) && (gameState[idx][1] == 1) && (gameState[idx][2] == 1) ) ||
	                ((gameState[idx][3] == 1) && (gameState[idx][4] == 1) && (gameState[idx][5] == 1) ) ||
	                ((gameState[idx][6] == 1) && (gameState[idx][7] == 1) && (gameState[idx][8] == 1) ) ||
	                ((gameState[idx][0] == 1) && (gameState[idx][4] == 1) && (gameState[idx][8] == 1) ) ||
	                ((gameState[idx][2] == 1) && (gameState[idx][4] == 1) && (gameState[idx][6] == 1) )
	                ){
	                    playerO[idx].send( wager[idx] + bet - fee);
	                    wager[idx] = 0;
	                    winGame(idx, playerO[idx]);
	                    collectedFees += fee;
	                    return;
	                }
	            	else if( ((gameState[idx][0] == 2) && (gameState[idx][3] == 2) && (gameState[idx][6] == 2) ) ||
	                ((gameState[idx][1] == 2) && (gameState[idx][4] == 2) && (gameState[idx][7] == 2) ) ||
	                ((gameState[idx][2] == 2) && (gameState[idx][5] == 2) && (gameState[idx][8] == 2) ) ||
	                ((gameState[idx][0] == 2) && (gameState[idx][1] == 2) && (gameState[idx][2] == 2) ) ||
	                ((gameState[idx][3] == 2) && (gameState[idx][4] == 2) && (gameState[idx][5] == 2) ) ||
	                ((gameState[idx][6] == 2) && (gameState[idx][7] == 2) && (gameState[idx][8] == 2) ) ||
	                ((gameState[idx][0] == 2) && (gameState[idx][4] == 2) && (gameState[idx][8] == 2) ) ||
	                ((gameState[idx][2] == 2) && (gameState[idx][4] == 2) && (gameState[idx][6] == 2) )
	                ){
	                    playerX[idx].send( wager[idx] + bet - fee);
	                    wager[idx] = 0;
	                    winGame(idx, playerX[idx]);
	                    collectedFees += fee;
	                    return;
	                }
		        // Check for stalemate.
		        else if ( numO + numX == 9 ){
		            playerO[idx].send( wager[idx] );
		            playerX[idx].send( bet );
		            wager[idx] = 0;
		            staleGame(idx);
		            return;
	
		        }

        	}

        newMove(idx);

	}

}
