using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

//! Controller for Paddle Two.
class GameDisplayDelegate extends Ui.BehaviorDelegate {

	hidden var paddleOne;
	hidden var paddleTwo;

    function initialize() {
        BehaviorDelegate.initialize();
        paddleOne = new Paddle(Paddle.PADDLE_ONE_X, 0); // ideally, the y-value should be height/2... but we need dc?
        paddleTwo = new Paddle(Paddle.PADDLE_TWO_X, 0);
    }

    function onMenu() {
    	// Pause the game
    }
    
    function onKeyPressed(evt) {
    	if (evt.getKey() == Ui.KEY_DOWN) {
    		Sys.println("Down");
    		paddleTwo.setPaddleY(paddleTwo.getPaddleY() - 1);
    	}
    	else if (evt.getKey() == Ui.KEY_UP) {
    		Sys.println("Up");
    		paddleTwo.setPaddleY(paddleTwo.getPaddleY() + 1);
    	}
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