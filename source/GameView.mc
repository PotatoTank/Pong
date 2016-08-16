using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class GameView extends Ui.View {

	var paddleOne;
	var paddleTwo;
	var delegate;

    function initialize(delegate) {
        View.initialize();
        delegate = delegate;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.GameLayout(dc));
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
        dc.clear();
        paddleOne = delegate.getPaddleOne();
        paddleTwo = delegate.getPaddleTwo();
        dc.fillRectangle(paddleOne.PADDLE_X, paddleOne.getPaddleY(), paddleOne.PADDLE_WIDTH, paddleOne.PADDLE_HEIGHT);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

}
