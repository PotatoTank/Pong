//! Data sent in a Pong display data page.
class PongDisplayData {
	var paddleTwoY;
	var state;
	var pairing;

    function initialize() {
    	paddleTwoY = 0xFF;
    	state = STATE_PAUSE;
    	pairing = 1;
    }
}