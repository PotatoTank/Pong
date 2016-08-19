using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;

class PongSensor extends Ant.GenericChannel {
    const DEVICE_TYPE = 1;
    const PERIOD = 1966;
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 25;

    hidden var chanAssign;

	var payload;
	var message;

    var data;
    var searching;
    var pastEventCount;
    var deviceCfg;

    class PongData {
        var eventCount;
        var utcTimeSet;
        var supportsAntFs;
        var measurementInterval;
        var totalHemoConcentration;
        var previousHemoPercent;
        var currentHemoPercent;

        function initialize() {
            eventCount = 0;
            utcTimeSet = false;
            supportsAntFs = false;
            measurementInterval = 0;
            totalHemoConcentration = 0;
            previousHemoPercent = 0;
            currentHemoPercent = 0;
        }
    }

    class PongDataPage {
        static const PAGE_NUMBER = 1;
        static const AMBIENT_LIGHT_HIGH = 0x3FE;
        static const INVALID_HEMO = 0xFFF;
        static const INVALID_HEMO_PERCENT = 0x3FF;

        enum {
            INTERVAL_25 = 1,
            INTERVAL_50 = 2,
            INTERVAL_1 = 3,
            INTERVAL_2 = 4
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

    class CommandDataPage {
        static const PAGE_NUMBER = 0x10;
        static const CMD_SET_TIME = 0x00;

        static function setTime(payload) {
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
            :searchTimeoutLowPriority => 10,    // Timeout in 25s
            :searchThreshold => 0} );           // Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(deviceCfg);

        searching = true;
        message = new Ant.Message();
    }

    function open() {
        // Open the channel
        GenericChannel.open();

        searching = true;
        
        payload = new [8];
        payload[0] = 0x01;
        payload[1] = 0x02;
        payload[2] = 0x03;
        payload[3] = 0x04;
        payload[4] = 0x05;
        payload[5] = 0x06;
        payload[6] = 0x07;

        payload[7] = 0x08;
        
        message.setPayload(payload);
        
        GenericChannel.sendBroadcast(message);
    }

    function closeSensor() {
        GenericChannel.close();
    }

	function update(ballX, ballY) {
		payload[1] = ballX;
		payload[2] = ballY;
		
		message.setPayload(payload);
		GenericChannel.sendBroadcast(message);
	}

    function onMessage(msg) {
        // Parse the payload
        var payload = msg.getPayload();

        if (Ant.MSG_ID_BROADCAST_DATA == msg.messageId) {
            if (MuscleOxygenDataPage.PAGE_NUMBER == (payload[0].toNumber() & 0xFF)) {
                // Were we searching?
                if (searching) {
                    searching = false;
                    // Update our device configuration primarily to see the device number of the sensor we paired to
                    deviceCfg = GenericChannel.getDeviceConfig();
                }
                var dp = new MuscleOxygenDataPage();
                dp.parse(msg.getPayload(), data);
                // Check if the data has changed and we need to update the ui
                if (pastEventCount != data.eventCount) {
                    Ui.requestUpdate();
                    pastEventCount = data.eventCount;
                }
            }
        } else if (Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId) {
            if (Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF)) {
                if (Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == (payload[1] & 0xFF)) {
                    // Channel closed, re-open
                    open();
                } else if (Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH  == (payload[1] & 0xFF)) {
                    searching = true;
                    Ui.requestUpdate();
                }
            } else {
                //It is a channel response.
            }
        }
    }
}