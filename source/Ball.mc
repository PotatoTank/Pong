using Toybox.Math;
using Toybox.System;

//! The ball in Pong.
class Ball {
	const RADIUS = 5;
	
    hidden var ballX;
    hidden var ballY;
    hidden var dx;
    hidden var dy;
    
    hidden var height;
    hidden var width;
    
    hidden var leftRight;
    
    var speed;
    var angle;
    
    function initialize(height, width, speed) {
    	self.height = height;
    	self.width = width;
    	
    	setBallX(width/2);
    	setBallY(height/2);
    	
    	angle = 180;
    	while (angle == 180) {
    		angle = Random.getRandomNumber(60, 120);
    	}
    	angle *= (Math.PI / 180.0);
    	leftRight = Random.getRandomNumber(0, 2);
    	
    	self.speed = speed;
    	dx = speed * Math.sin(angle);
    	dy = speed * Math.cos(angle);
    	
    	if (leftRight == 1) {
    		dx = -dx;
    	}
    }
    
    function reset() {
    	initialize(height, width, speed);
    }
    
    function getAngle() {
    	return angle;
    }
    
    function updatePosition(paddleOne){
    	
    	if ((ballX - RADIUS <= paddleOne.getPaddleX() + paddleOne.PADDLE_WIDTH)
    		&& (ballX - RADIUS >= paddleOne.getPaddleX())
    		&& (ballY - RADIUS < paddleOne.getPaddleY() + paddleOne.PADDLE_HEIGHT)
    		&& (ballY + RADIUS > paddleOne.getPaddleY())) {
    		dx = -dx;
    	}
    	
    	else if ((ballX + RADIUS >= paddleTwo.getPaddleX())
    		&& (ballX + RADIUS <= paddleTwo.getPaddleX() + paddleTwo.PADDLE_WIDTH)
    		&& (ballY - RADIUS < paddleTwo.getPaddleY() + paddleTwo.PADDLE_HEIGHT)
    		&& (ballY + RADIUS > paddleTwo.getPaddleY())) {
    		dx = -dx;
    	}
    	
    	if (ballX + RADIUS > width) {
    		paddleOneScoreUp();
    		reset();
    	}
    	
    	if (ballX - RADIUS < 0) {
    		paddleTwoScoreUp();
    		reset();
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