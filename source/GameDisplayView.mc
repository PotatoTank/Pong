using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;

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
	
	var display;
	
	// Timer
	hidden var timer;
	const updateFrequency = 50;

	function initialize(display) {
        View.initialize();
        self.display = display;
        
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
        
        paddleOne.setPaddleY(display.getPaddleOneY());
        drawPaddleOne(dc);

        ball.setBallX(display.getBallX());
        ball.setBallY(display.getBallY());
       	drawBall(dc);
       	
        drawPaddleTwo(dc);
        display.updatePaddleTwoPosition(paddleTwo.getPaddleY());
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
