class Ball
{
	const BALL_WIDTH = 2;
	const BALL_HEIGHT = 2;
	
    hidden var ballX = 0;
    hidden var ballY = 0;
    
    function getBallX(){
    	return ballX;
    }
    
    function getBallY(){
    	return ballY;
    }
    
    function setBallX(x){
    	ballX = x;
    }
    
    function setBallY(y){
    	ballY = y;
    }
}