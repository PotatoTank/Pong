using Toybox.Math;

//! A ball that bounces off all boundaries of the screen to be used for decoration.
class DecoBall {
	const RADIUS = 10;
	
    hidden var ballX;
    hidden var ballY;
    hidden var dx;
    hidden var dy;
    
    hidden var height;
    hidden var width;
    
    var speed;
    var angle;
    
    function initialize(height, width, speed, angle) {
    	self.height = height;
    	self.width = width;
    	
    	setBallX(width/2);
    	setBallY(height/2);
    	
    	self.speed = speed;
    	self.angle = angle;
    	
    	setDx(Random.getRandomNumber(-20, 20));
    	setDy(Random.getRandomNumber(-10, 10));
    }
    
    function setAngle(speed, angle) {
    	self.angle = angle;
    	dx = speed * Math.sin(angle);
    	dy = speed * Math.cos(angle);
    }
    
    function getAngle() {
    	return angle;
    }
    
    function updatePosition(){
    
    	if (ballX + RADIUS > width) {
    		dx = -dx;
    	}
    	
    	if (ballX - RADIUS < 0) {
    		dx = -dx;
    	}
    	
    	if (ballY + RADIUS > height) {
    		dy = -dy;
    	}
    	
    	if (ballY - RADIUS < 0) {
    		dy = -dy;
    	}
    
    	ballX = ballX + dx;
    	ballY = ballY + dy;
    }
    
    function getBallX(){
    	return ballX;
    }
    
    function getBallY(){
    	return ballY;
    }
    
    function getDx() {
    	return dx; 
    }
    
    function getDy() {
    	return dy;
    }
    
    function setBallX(x){
    	ballX = x;
    }
    
    function setBallY(y){
    	ballY = y;
    }
    
    function setDx(dx) {
    	self.dx = dx;
    }
    
    function setDy(dy) {
    	self.dy = dy;
    }
}