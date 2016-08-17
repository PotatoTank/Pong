class Paddle
{
	const PADDLE_WIDTH = 5;
	const PADDLE_HEIGHT = 35;
	const PADDLE_X = 45;
	
    hidden var paddleY = 0;
    
    function getPaddleY(){
    	return paddleY;
    }
    
    function setPaddleY(y){
    	paddleY = y;
    }
}