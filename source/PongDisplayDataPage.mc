//! A Pong display data page.
class PongDisplayDataPage {
    static const PAGE_NUMBER = 2;

    function parse(payload, data) {
    	data.paddleTwoY = parsePaddleTwoY(payload);
    	data.state = parseState(payload);
    	data.flip = parseFlip(payload);
    	data.pairing = parsePairing(payload);   	
    }
    
    function set(data, payload) {
    	setPageNumber(payload, data);
    	payload[1] = 0xFF;
    	payload[2] = 0xFF;
    	setPaddleTwoY(payload, data);
    	payload[4] = 0xFF;
    	setFlip(payload, data);
    	setState(payload, data);
		setPairing(payload, data);
	}
    
	hidden function parsePaddleTwoY(payload) {
		return payload[3];
	}
	
	hidden function parseFlip(payload) {
		return payload[5];
	}
	
	hidden function parseState(payload) {
		return payload[6];
	}
	
	hidden function parsePairing(payload) {
		return payload[7];
	}
	
	hidden function setPageNumber(payload, data) {
		payload[0] = PAGE_NUMBER;
	}
	
	hidden function setPaddleTwoY(payload, data) {
		payload[3] = data.paddleTwoY;
	}

	hidden function setFlip(payload, data) {
		payload[5] = data.flip;
	}

	hidden function setState(payload, data) {
		payload[6] = data.state;
	}
	
	hidden function setPairing(payload, data) {
		payload[7] = data.pairing;
	}

}