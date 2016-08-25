//! Data sent in a Pong data page.
class PongData {
	var ballX;
	var ballY;
	var paddleOneY;
	var paddleOneScore;
	var paddleTwoScore;
	var state;
	var pairing;

    function initialize() {
    	ballX = 0xFF;
    	ballY = 0xFF;
    	paddleOneY = 0xFF;
        paddleOneScore = 0;
        paddleTwoScore = 0;
        state = STATE_PAUSE;
        pairing = 1;
    }
}