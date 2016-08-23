using Toybox.Math;
using Toybox.System;

//! The ball in Pong.
class Ball {
	const RADIUS = 10;
	
    hidden var ballX;
    hidden var ballY;
    hidden var dx;
    hidden var dy;
    
    hidden var height;
    hidden var width;
    
    function initialize(height, width) {
    	self.height = height;
    	self.width = width;
    	
    	setBallX(width/2);
    	setBallY(height/2);
    	
    	setDx(Random.getRandomNumber(-20, 20));
    	setDy(Random.getRandomNumber(-10, 10));
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