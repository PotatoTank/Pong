//! Data sent in a Pong display data page.
class PongDisplayData {
	var paddleTwoY;
	var state;
	var pairing;

    function initialize() {
    	paddleTwoY = 0x50;
    	state = STATE_PAUSE;
    	pairing = 1;
    }
}