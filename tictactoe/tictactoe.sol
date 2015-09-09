Contract tictactoe{

	struct Game {
	    address player1;
	    address player2;
	    address activePlayer;
	    uint wager;
	    uint deadline;
	    bytes32 gameState;
	}

	uint numGames;
	mapping (uint => Game) games;

	function is_first_move(bytes32 gameState) private{
		uint i = 0;
		uint numX = 0;
		while(i<9){
			if( gameState[i] == "X" ){ numX++;}
			elseif(gamesState[i] != 0){ return false }
			i++;
		}
		if( numX = 1 ){ return true; }
		else( return false; )
	}

	function newGame(uint deadline, bytes32 gameState){
	        if( is_first_move(gameState) ){
		        uint gameID = numGames++; // gameID is return variable
		        Game g = games[gameID]; // assigns reference
		        g.player1 = msg.sender;
		        g.wager = msg.amount;
		        g.deadline = block.number + deadline;
	        	g.gameState = gameState;
	        	return gameID;
	        }
	        else{ return false; }
	}


	function is_second_move(byte32 gameState) private{

	}

	function is_valid_move(bytes32 oldGameState, bytes32 newGameState) private{

	}

	function is_win(bytes32 gameState) private{

	}

	function newMove(uint gameID, bytes32 gameState){

	}

}
