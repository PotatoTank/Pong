using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System as Sys;

class PongDisplay extends Ant.GenericChannel {
   	const DEVICE_TYPE = 1;
    const PERIOD = 1966;
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 25;

    hidden var chanAssign;

    hidden var data;
    hidden var searching;
    hidden var pastEventCount;
    hidden var deviceCfg;
    
    hidden var payloadTx;
    hidden var payloadRx;
    
    hidden var pongDisplayCallback;
    
    var banana;

    function initialize(callback) {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_RX_NOT_TX, Ant.NETWORK_PUBLIC);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => 123,                 // Wildcard our search
            :deviceType => DEVICE_TYPE,
            :transmissionType => TRANSMISSION_TYPE,
            :messagePeriod => PERIOD,
            :radioFrequency => RADIO_FREQUENCY,
            :searchTimeoutLowPriority => 4,     // Timeout in 10s
            :searchThreshold => 0} );           // Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(deviceCfg);

        searching = true;
        payloadTx = new [8];
        payloadRx = new [8];
  		
  		pongDisplayCallback = callback;
  		
  		banana = true;
    }

    function open() {
        // Open the channel
        GenericChannel.open();
        searching = true;
    }
    
    function close() {
    	GenericChannel.close();
    }

	function getBallX() {
		return payloadRx[1];
	}
	
	function getBallY() {
		return payloadRx[2];
	}

    function closeSensor() {
        GenericChannel.close();
    }

    function onMessage(msg) {
        // Parse the payload
        payloadRx = msg.getPayload();
		Sys.println(payloadRx);
		if (banana) {
			pongDisplayCallback.invoke();
			banana = false;
		}
		
    }
}