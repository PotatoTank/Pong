using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;

class PongSensor extends Ant.GenericChannel {
    const DEVICE_TYPE = 1;
    const PERIOD = 1966; // 10 Hz
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 25;

    hidden var chanAssign;

	var payloadTx;
	var payloadRx;
	var message;

    var data;
    var searching;
    var pastEventCount;
    var deviceCfg;

    class PongData {
    	var ballX;
    	var ballY;
    	var paddleOneY;
    	var paddleTwoY;
    	var paddleOneScore;
    	var paddleTwoScore;
    	var state;

        function initialize() {
            // TODO: initialize variables
        }
    }

    class PongDataPage {
        static const PAGE_NUMBER = 1;
        static const AMBIENT_LIGHT_HIGH = 0x3FE;
        static const INVALID_HEMO = 0xFFF;
        static const INVALID_HEMO_PERCENT = 0x3FF;

        enum {
            // TODO: define game states. ie pause, p1 win, p2 win, play
            FILL = 1
        }

        function parse(payload, data) {
            data.eventCount = parseEventCount(payload);
            data.utcTimeSet = parseTimeSet(payload);
            data.supportsAntFs = parseSupportAntfs(payload);
            data.measurementInterval = parseMeasureInterval(payload);
            data.totalHemoConcentration = parseTotalHemo(payload);
            data.previousHemoPercent = parsePrevHemo(payload);
            data.currentHemoPercent = parseCurrentHemo(payload);
        }

        hidden function parseEventCount(payload) {
           return payload[1];
        }

        hidden function parseTimeSet(payload) {
            if (payload[2] & 0x1) {
               return true;
            } else {
               return false;
            }
        }

        hidden function parseSupportAntfs(payload) {
            if (payload[3] & 0x1) {
                return true;
            } else {
                return false;
            }
        }

        hidden function parseMeasureInterval(payload) {
           var interval = payload[3] >> 1;
           var result = 0;
           if (INTERVAL_25 == interval) {
               result = .25;
           } else if (INTERVAL_50 == interval) {
                result = .50;
           } else if (INTERVAL_1 == interval) {
                result = 1;
           } else if (INTERVAL_2 == interval) {
                result = 2;
           }
           return result;
        }

        hidden function parseTotalHemo(payload) {
           return ((payload[4] | ((payload[5] & 0x0F) << 8))) / 100f;
        }

        hidden function parsePrevHemo(payload) {
           return ((payload[5] >> 4) | ((payload[6] & 0x3F) << 4)) / 10f;
        }

        hidden function parseCurrentHemo(payload) {
           return ((payload[6] >> 6) | (payload[7] << 2)) / 10f;
        }
    }

    function initialize() {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_TX_NOT_RX, Ant.NETWORK_PUBLIC);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => 1,
            :deviceType => DEVICE_TYPE,
            :transmissionType => TRANSMISSION_TYPE,
            :messagePeriod => PERIOD,
            :radioFrequency => RADIO_FREQUENCY,
            :searchTimeoutLowPriority => 4} ); // 10 second time out.
        GenericChannel.setDeviceConfig(deviceCfg);

        searching = true;
        payloadTx = new [8];
        payloadRx = new [8];
        message = new Ant.Message();
    }

    function open() {
        // Open the channel
        GenericChannel.open();

        searching = true;
        
        payloadTx[0] = 0x01;
        payloadTx[1] = 0x02;
        payloadTx[2] = 0x03;
        payloadTx[3] = 0x04;
        payloadTx[4] = 0x05;
        payloadTx[5] = 0x06;
        payloadTx[6] = 0x07;
        payloadTx[7] = 0x08;
        
        message.setPayload(payloadTx);
        
        GenericChannel.sendBroadcast(message);
    }

    function closeSensor() {
        GenericChannel.close();
    }

	function update(ballX, ballY) {
		payloadTx[1] = ballX;
		payloadTx[2] = ballY;
		
		message.setPayload(payloadTx);
		GenericChannel.sendBroadcast(message);
	}

    function onMessage(msg) {
        // Parse the rx payload.
        payloadRx = msg.getPayload();

    }
}