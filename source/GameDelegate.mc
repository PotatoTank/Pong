using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

//! Controller for Paddle One.
class GameDelegate extends Ui.BehaviorDelegate {

	hidden var paddleOne;
	hidden var paddleTwo;
	
	var view;
	
	var ball;

    function initialize(view) {
        BehaviorDelegate.initialize();
        paddleOne = new Paddle(Paddle.PADDLE_ONE_X, 40); // ideally, the y-value should be height/2... but we need dc?
        paddleTwo = new Paddle(Paddle.PADDLE_TWO_X, 0);
        self.view = view;
        ball = view.getBall();
        view.loadPaddle(paddleOne);
    }

    function onMenu() {
    	// Pause the game
    }
    
    function onKeyPressed(evt) {
    	if (evt.getKey() == Ui.KEY_DOWN) {
    		Sys.println("Down");
    		paddleOne.setPaddleY(paddleOne.getPaddleY() + 1);
    	}
    	else if (evt.getKey() == Ui.KEY_UP) {
    		Sys.println("Up");
    		paddleOne.setPaddleY(paddleOne.getPaddleY() - 1);
    	}
    }
    
    function getPaddleOne() {
    	Sys.println("Im here bruh");
    }
    
    function getPaddleTwo() {
    	Sys.println("Im here bruh 2");
    }

	function onTap(evt) {
        Sys.println("Hi");
    }
    
    function getDelegate()
    {
        var delegate = new GameDelegate();
        return delegate;
    }
}