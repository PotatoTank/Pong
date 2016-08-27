//! A paddle used in Pong.
class Paddle {
	static const PADDLE_ONE_X = 45;
	static const PADDLE_TWO_X = 162;
	
	const PADDLE_WIDTH = 5;
	const PADDLE_HEIGHT = 35;
	
	hidden var width;
	hidden var height;
	hidden var paddleX;
	hidden var paddleY;
    
    function initialize(paddleX, paddleY) {
    	self.paddleX = paddleX;
    	self.paddleY = paddleY;
    	width = PADDLE_WIDTH;
    	height = PADDLE_HEIGHT;
    }
    
    function getPaddleY() {
    	return paddleY;
    }
    
    function setPaddleY(y) {
    	paddleY = y;
    }
    
    function getPaddleX() {
    	return paddleX;
    }
}