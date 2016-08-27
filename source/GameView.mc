using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

const PADDLE_SPEED = 10;
const BALL_SPEED = 5;

var height;
var width;

var ball;
var paddleOne;
var paddleTwo;
var paddleOneScore;
var paddleTwoScore;

function paddleOneUp() {
	if (paddleOne.getPaddleY() - PADDLE_SPEED > 0) {
		paddleOne.setPaddleY(paddleOne.getPaddleY() - PADDLE_SPEED);
	}
}

function paddleOneDown() {
	if (paddleOne.getPaddleY() + paddleOne.PADDLE_HEIGHT + PADDLE_SPEED < height) {
		paddleOne.setPaddleY(paddleOne.getPaddleY() + PADDLE_SPEED);
	}
}

function getBallX() {
	return ball.getBallX();
}

function getBallY() {
	return ball.getBallY();
}

function setBallAngle(angle) {
	ball.setAngle(speed, angle);
}

function getBallAngle() {
	return ball.getAngle();
}

//! Game view for the host.
class GameView extends Ui.View {
	
	var sensor;
	
	// Timer
	hidden var timer;
	const updateFrequency = 100;

	function initialize(sensor) {
        View.initialize();
        self.sensor = sensor;
        
        paddleOne = new Paddle(Paddle.PADDLE_ONE_X, 40);
        paddleTwo = new Paddle(Paddle.PADDLE_TWO_X, 40);
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.GameLayout(dc));
        
        height = dc.getHeight();
        width = dc.getWidth();
        ball = new Ball(height, width);
        
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
        View.onUpdate(dc);

        paddleTwo.setPaddleY(sensor.getPaddleTwoY());
        drawPaddleTwo(dc);
        
        ball.updatePosition(paddleOne);
        drawBall(dc);
        
        drawPaddleOne(dc);
        
        sensor.updateBallPosition(getBallX(), getBallY());
        sensor.updatePaddleOnePosition(paddleOne.getPaddleY());
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
    	sensor.close();
    }
    
    //! This method is hooked in to the start function of the timer
    //! to allow the onUpdate function to get called at the specified
    //! updateFrequency.
    function refreshUi() {
    	Ui.requestUpdate();
    }
}
