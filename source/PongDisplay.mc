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
    hidden var dataPage;
    hidden var searching;
    hidden var message;

    hidden var deviceCfg;
    
    hidden var payloadTx;
    hidden var payloadRx;
    
    hidden var pongDisplayCallback;
    
    hidden var paired;
    
    function initialize(callback) {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_RX_NOT_TX, Ant.NETWORK_PUBLIC);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => 0,                 // Wildcard our search
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
        
        message = new Ant.Message();
        data = new PongDisplayData();
        dataPage = new PongDisplayDataPage();
  		
  		pongDisplayCallback = callback;
  		
  		paired = false;
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

	function sendAcknowledged() {
		dataPage.set(data, payloadTx);
        message.setPayload(payloadTx);
        GenericChannel.sendAcknowledge(message);
	}

    function onMessage(msg) {
        // Parse the payload
        payloadRx = msg.getPayload();
		//Sys.println(payloadRx);
		
		if (msg.messageId == Ant.MSG_ID_BROADCAST_DATA) {
			if (payloadRx[0] == 1 && payloadRx[7] == 1 && !paired) { // TODO: use objects
				sendAcknowledged();
				data.pairing = 0;
				pongDisplayCallback.invoke();
				paired = true;
			}
		}
    }
}