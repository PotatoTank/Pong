class PongDataPage {
    static const PAGE_NUMBER = 1;

    function parse(payload, data) {
    	data.ballX = parseBallX(payload);
    	data.ballY = parseBallY(payload);
    	data.paddleOneY = parsePaddleOneY(payload);
    	data.paddleOneScore = parsePaddleOneScore(payload);
    	data.paddleTwoScore = parsePaddleTwoScore(payload);
    	data.state = parseState(payload);
    	data.pairing = parsePairing(payload);
    }
    
    function set(data, payload) {
    	setPageNumber(payload, data);
		setBallX(payload, data);
		setBallY(payload, data);
		setPaddleOneY(payload, data);
		setPaddleOneScore(payload, data);
		setPaddleTwoScore(payload, data);
		setState(payload, data);
		setPairing(payload, data);
	}
    
    hidden function parseBallX(payload) {
    	return payload[1];
    }

	hidden function parseBallY(payload) {
		return payload[2];
	}
	
	hidden function parsePaddleOneY(payload) {
		return payload[3];
	}
	
	hidden function parsePaddleOneScore(payload) {
		return payload[4];
	}
	
	hidden function parsePaddleTwoScore(payload) {
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
	
	hidden function setBallX(payload, data) {
		payload[1] = data.ballX;
	}
	
	hidden function setBallY(payload, data) {
		payload[2] = data.ballY;
	}
	
	hidden function setPaddleOneY(payload, data) {
		payload[3] = data.paddleOneY;
	}

	hidden function setPaddleOneScore(payload, data) {
		payload[4] = data.paddleOneScore;
	}
	
	hidden function setPaddleTwoScore(payload, data) {
		payload[5] = data.paddleTwoScore;
	}
	
	hidden function setState(payload, data) {
		payload[6] = data.state;
	}
	
	hidden function setPairing(payload, data) {
		payload[7] = data.pairing;
	}

}