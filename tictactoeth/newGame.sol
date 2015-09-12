contract tictactoeth{

	// Setup ownership 
	address public owner;

	function tictactoeth() {
		owner = msg.sender;
	}
	
	// Setup games.
	uint public numGames;
	mapping( uint => uint ) public deadline;
	mapping( uint => uint ) public wager;
	mapping( uint => address ) public playerO;
	mapping( uint => address ) public playerX;
	mapping( uint => string[9] ) public gameState = '---------';

	// Initialize new game.
	function newGame(uint move, uint blockLife){
		if( move > 8 || blockLife > 1000000000 ){ 
			return; 
		}
		deadline[numGames] = block.number + blockLife;
		wager[numGames] = msg.value;
		playerO[numGames] = msg.sender;
		gameState[numGames][move] = 'O';
		numGames++;
	}
}
