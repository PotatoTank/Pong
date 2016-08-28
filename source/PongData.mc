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
    	ballX = 0x50;
    	ballY = 0x50;
    	paddleOneY = 0x50;
        paddleOneScore = 0;
        paddleTwoScore = 0;
        state = STATE_PAUSE;
        pairing = 1;
    }
}