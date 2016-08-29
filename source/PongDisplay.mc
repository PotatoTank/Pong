using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System as Sys;

class PongDisplay extends Ant.GenericChannel {
   	const DEVICE_TYPE = 1;
    const PERIOD = 2731;
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 25;

    hidden var chanAssign;

    hidden var data;
    hidden var dataPage;
    hidden var message;

    hidden var deviceCfg;
    
    hidden var payloadTx;
    hidden var payloadRx;
    hidden var payloadTemp;
    
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
	
	function getPaddleOneY() {
		return payloadRx[3];
	}
	
	function getPaddleOneScore() {
		return payloadRx[4];
	}
	
	function getPaddleTwoScore() {
		return payloadRx[5];
	}

	function updatePaddleTwoPosition(paddleTwoY) {
		data.paddleTwoY = paddleTwoY;
		
		sendAcknowledged();
	}

	function sendAcknowledged() {
		dataPage.set(data, payloadTx);
        message.setPayload(payloadTx);
        GenericChannel.sendAcknowledge(message);
	}

    function onMessage(msg) {
        // Parse the rx payload
        payloadTemp = msg.getPayload();
        
        if (payloadTemp[0] == 1){
        	payloadRx[0] = payloadTemp[0];
        	payloadRx[1] = payloadTemp[1];
        	payloadRx[2] = payloadTemp[2];
        	payloadRx[3] = payloadTemp[3];
        	payloadRx[4] = payloadTemp[4];
        	payloadRx[5] = payloadTemp[5];
        	payloadRx[6] = payloadTemp[6];
        	payloadRx[7] = payloadTemp[7];
        }

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