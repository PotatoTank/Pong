using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;

//! Game view for the host.
class GameView extends Ui.View {

	// Display Settings
	hidden var height;
	hidden var width;
	
	var paddleOne; // paddleOne should not be in this class, should be handled by GameDelegate
	var paddleTwo;
	var delegate;
	
	var sensor;

	// Ball Settings
	hidden var ball;
	
	// Timer
	hidden var timer;
	const updateFrequency = 100;

	function initialize(sensor) {
        View.initialize();
        self.sensor = sensor;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.GameLayout(dc));
        
        height = dc.getHeight();
        width = dc.getWidth();
        
        ball = new Ball(height, width);
        
        timer = new Timer.Timer();
        timer.start(method(:update), updateFrequency, true);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        //clear everything on screen
        dc.clear();        
        //paddleOne = delegate.getPaddleOne();
        //paddleTwo = delegate.getPaddleTwo();
        //dc.fillRectangle(paddleOne.PADDLE_X, paddleOne.getPaddleY(), paddleOne.PADDLE_WIDTH, paddleOne.PADDLE_HEIGHT);
        // draw game graphics
        ball.updatePosition();
        dc.drawCircle(ball.getBallX(), ball.getBallY(), ball.RADIUS);
        
        sensor.update(ball.getBallX(), ball.getBallY());
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    }
    
    //! This method is hooked in to the start function of the timer
    //! to allow the onUpdate function to get called at the specified
    //! updateFrequency
    function update() {
    	Ui.requestUpdate();
}
