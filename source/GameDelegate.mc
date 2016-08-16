using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class GameDelegate extends Ui.BehaviorDelegate {

	hidden var paddleOne;
	hidden var paddleTwo;

    function initialize() {
        BehaviorDelegate.initialize();
        paddleOne = new Paddle();
        paddleTwo = new Paddle();
    }

    function onMenu() {
    }
    
    function onKeyPressed(evt) {
    	if (evt.getKey() == Ui.KEY_DOWN) {
    		Sys.println("Down");
    		paddleOne.setPaddleY(paddleOne.getPaddleY() - 1);
    	}
    	else if (evt.getKey() == Ui.KEY_UP) {
    		Sys.println("Up");
    	}
    }

	function onTap(evt) {
        Sys.println("Hi");
    }
    
    function getPaddleOne() {
    	return paddleOne;
    }
    
    function getPaddleTwo() {
    	return paddleTwo;
    }
    
    function getDelegate()
    {
        var delegate = new GameDelegate();
        return delegate;
    }
}