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

	function newGame(uint deadline, bytes32 gameState){
	        gameID = numGames++; // campaignID is return variable
	        Game g = games[gameID]; // assigns reference
	        g.player1 = msg.sender;
	        g.wager = msg.amount;
	        g.deadline = block.number + deadline;
	        if( is_first(gameState) ){
	        	g.gameState = gameState;
	        }
	}

	function is_first(bytes32 gameState) private{

	}

	function is_valid_move(bytes32 oldGameState, bytes32 newGameState) private{

	}

	function is_win(bytes32 gameState) private{

	}

	function newMove(uint gameID, bytes32 gameState){

	}

}
