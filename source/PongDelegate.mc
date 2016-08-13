using Toybox.WatchUi as Ui;

class PongDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new PongMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}