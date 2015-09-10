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

	function newGame(uint deadline, uint move){
		if( move < 9 ){
			uint gameID = numGames++; // gameID is return variable
			Game g = games[gameID]; // assigns reference
			g.player1 = msg.sender;
			g.wager = msg.amount;
			g.deadline = block.number + deadline;
			g.gameState[move] = "O";
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

	function newMove(uint gameID, uint move){

	}

}
