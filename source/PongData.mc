class PongData {
	var ballX;
	var ballY;
	var paddleOneY;
	var paddleOneScore;
	var paddleTwoScore;
	var state;
	var pairing;

    function initialize() {
        paddleOneScore = 0;
        paddleTwoScore = 0;
        state = STATE_PAUSE;
        pairing = 1;
    }
}