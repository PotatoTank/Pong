using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function paddleTwoUp() {
	if (paddleTwo.getPaddleY() - PADDLE_SPEED > 0) {
		paddleTwo.setPaddleY(paddleTwo.getPaddleY() - PADDLE_SPEED);
	}
}

function paddleTwoDown() {
	if (paddleTwo.getPaddleY() + paddleTwo.PADDLE_HEIGHT + PADDLE_SPEED < height) {
		paddleTwo.setPaddleY(paddleTwo.getPaddleY() + PADDLE_SPEED);
	}
}

//! Game view for the display.
class GameDisplayView extends Ui.View {
	
	//var display;
	
	var prevX;
	var prevY;
	
	var currX;
	var currY;
	
	// Timer
	hidden var timer;
	const updateFrequency = 50;

	function initialize() {
        View.initialize();

        gameState = STATE_PLAY;
        paddleOne = new Paddle(Paddle.PADDLE_ONE_X, 80);
        paddleTwo = new Paddle(Paddle.PADDLE_TWO_X, 80);
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.GameLayout(dc));
        height = dc.getHeight();
        width = dc.getWidth();
        ball = new Ball(height, width, BALL_SPEED);
        
        timer = new Timer.Timer();
        timer.start(method(:refreshUi), updateFrequency, true);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        if (gameState == STATE_PLAY) {
        	View.onUpdate(dc);
	        paddleOne.setPaddleY(display.getPaddleOneY());
	        drawPaddleOne(dc);
	        currX = display.getBallX();
	        currY = display.getBallY();
	        // Controls jumpy ball due to bad RF.
	        if (prevX == null) {
	        	prevX = currX;
	        }
	        else {
	        	if (((currX - prevX) > 5 || (currX - prevX) < -5) && currX < 10) {
	        		currX = prevX;
	        	} 
	        	else {
	        		prevX = currX;
	        	}
	        }
	        if (prevY == null) {
	        	prevY = currY;
	        }
	        else {
	        	if (((currY - prevY) > 10 || (currX - prevX) < -10)) {
	        		currX = prevX;
	        	}
	        	else {
	        		prevX = currX;
	        	}
	        }
	        ball.setBallX(currX);
	        ball.setBallY(currY);
	       	drawBall(dc);
	       	
	       	if ((currX + ball.RADIUS >= paddleTwo.getPaddleX())
    			&& (currX + ball.RADIUS <= paddleTwo.getPaddleX() + paddleTwo.PADDLE_WIDTH)
    			&& (currY - ball.RADIUS < paddleTwo.getPaddleY() + paddleTwo.PADDLE_HEIGHT)
    			&& (currY + ball.RADIUS > paddleTwo.getPaddleY())) {
    			display.updateFlip();
    		}
	       	
	       	display.updatePaddleTwoPosition(paddleTwo.getPaddleY());
	        drawPaddleTwo(dc);
	        paddleOneScore = display.getPaddleOneScore();
	        paddleTwoScore = display.getPaddleTwoScore();
	        drawPaddleOneScore(dc);
	        drawPaddleTwoScore(dc);
	        if (paddleTwoScore == WIN_SCORE) {
	        	youWin(dc);
	        }
	        else if (paddleOneScore == WIN_SCORE) {
	        	youLose(dc);
	        }
		}
    }
    
    hidden function youWin(dc) {
    	dc.drawText(TEXT_X, TEXT_Y, Gfx.FONT_LARGE, MESSAGE_WIN, Gfx.TEXT_JUSTIFY_CENTER);
    	gameState = STATE_PAUSE;
    }
    
    hidden function youLose(dc) {
    	dc.drawText(TEXT_X, TEXT_Y, Gfx.FONT_LARGE, MESSAGE_LOSE, Gfx.TEXT_JUSTIFY_CENTER);
    	gameState = STATE_PAUSE;
    }
    
    hidden function drawPaddleOneScore(dc) {
    	dc.drawText(85, 20, Gfx.FONT_NUMBER_MILD, paddleOneScore, Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    hidden function drawPaddleTwoScore(dc) {
    	dc.drawText(130, 20, Gfx.FONT_NUMBER_MILD, paddleTwoScore, Gfx.TEXT_JUSTIFY_CENTER);
    }

	hidden function drawBall(dc) {
		dc.drawCircle(getBallX(), getBallY(), ball.RADIUS);
	}
	
	hidden function drawPaddleOne(dc) {
		dc.fillRectangle(paddleOne.getPaddleX(), paddleOne.getPaddleY(), paddleOne.PADDLE_WIDTH, paddleOne.PADDLE_HEIGHT);
	}
	
	hidden function drawPaddleTwo(dc) {
		dc.fillRectangle(paddleTwo.getPaddleX(), paddleTwo.getPaddleY(), paddleTwo.PADDLE_WIDTH, paddleTwo.PADDLE_HEIGHT);
	}

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	display.close();
    }
    
    //! This method is hooked in to the start function of the timer
    //! to allow the onUpdate function to get called at the specified
    //! updateFrequency
    function refreshUi() {
    	Ui.requestUpdate();
    }
}
