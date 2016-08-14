class Paddle
{
	const PADDLE_WIDTH = 2;
	const PADDLE_HEIGHT = 10;
	const PADDLE_X = 5;
	
    hidden var paddleY = 0;
    
    function getPaddleX(){
    	return PADDLE_X;
    }
    
    function getPaddleY(){
    	return paddleY;
    }
    
    function setPaddleY(y){
    	paddleY = y;
    }
}