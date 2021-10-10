// include required for I2C communication of rotoshield
#include <Wire.h>
#include <stdarg.h>

#include "snootor.h"

/*
 * Configuration
 */
// Used PINs
#define BUTTON_P 7
#define LED_P 8
#define FREQ_POT_P A1

// LED blinking conf
#define BLINK_INTERVAL 10000 // in milliseconds
#define BLINK_DURATION 1000  // in milliseconds

// Motor conf
#define MOTOR_DIRECTION FORWARD
#define MOTOR_SPEED 255  // 0 -> no movement     255 -> max speed
#define MOTOR_PIN 3  // because of some issues, some combinaison of motors
                     // do not work. Motors 1 and 2 do not work alone.
#define DISPENSE_DURATION 5000 // in milliseconds

// Feed per day potentiometer count
#define FEEDPD_NUM_POS 4  // 4 positions: 0, 1, 2, 3 per day
#define POTENTIOMETER_MAX 1024  // this should not be changed: value when 5V
#define DAY 24UL*60UL*60UL*1000UL  // milliseconds in a day



/*
 * Some structure to manage states
 */
// to read all inputs
struct {
	bool dispense_btn;
	int feedpd_pot;
	unsigned long now;
} inputs;

// to keep track of previous outputs
struct {
	bool power_led_on;
	bool motor_on;
} outputs;

// to keep track of the LED state
struct LED {
	bool blinking;
	unsigned long last_blink;
} power_led_state;

// to keep track of the motor state
struct MOTOR {
	bool running;
	bool need_init;  // whether the last_dispense should be reset
	unsigned long last_dispense;
} motor_state;


// motor definition
SnootorDC motor;

/*
 * Compute the time difference since a precedent time
 * Computation take care of millis() overflow: computing difference with ulong
 * will underflow if millis() has overflow ==> the result will remain correct
 */
#define get_time_diff(since) (inputs.now - since)

/*
 * Compute Feed per day position
 */
const int FEEDP_HALF = POTENTIOMETER_MAX / (2 * (FEEDPD_NUM_POS - 1));
int get_feedpd() {
	// Consider min as first position & max as last ==> potentiometer
	// range should be divided by (num_position - 1) in-between-position
	// ranges which should all be divided in 2 to find the closest position
	// example
	//      170 =~ 1024 / (2*(4-1))
	//       v
	//  0 |--+--|--+--|--+--| 1023
	//   P0    P1    P2    P3
	int i;
	for (i=0; i<FEEDPD_NUM_POS; i++) {
		if (inputs.feedpd_pot < 2 * FEEDP_HALF * (i + 1) - FEEDP_HALF)
			return i;
	}
	// Should already have return
	return FEEDPD_NUM_POS - 1;
}

#ifdef DEBUG
#define print_debug(...) Serial_printfln(__VA_ARGS__)
#define DEBUG_INTERVAL 1000
unsigned long last_debug;

#define SERIAL_PRINTF_MAX_BUF 512
void Serial_printfln(const char *fmt, ...) {
	char buff[SERIAL_PRINTF_MAX_BUF];
	va_list pargs;
	// format the string in the buffer
	va_start(pargs, fmt);
	vsnprintf(buff, SERIAL_PRINTF_MAX_BUF, fmt, pargs);
	va_end(pargs);
	// print to the serial
	Serial.println(buff);
}

// setup debug Serial
void setup_debug() {
	Serial.begin(115200);
	// Debug message
	print_debug("Initialization of the board OK");
}

// print debug messages
void debug_state() {
	print_debug("----------------------------");
	print_debug("Current state:");
	print_debug("  Inputs:");
	print_debug("    Dispense button      %u", inputs.dispense_btn);
	print_debug("    Feeder potentiometer %u", inputs.feedpd_pot);
	print_debug("    Current time         %lu", inputs.now);
	print_debug("");
	print_debug("  States:");
	print_debug("    Power LED state:");
	print_debug("      Blinking           %u", power_led_state.blinking);
	print_debug("      Last blink time    %lu", power_led_state.last_blink);
	print_debug("    Motor state:");
	print_debug("      Running            %u", motor_state.running);
	print_debug("      Need init          %u", motor_state.need_init);
	print_debug("      Last disponse time %lu", motor_state.last_dispense);
	print_debug("");
	print_debug("  Outputs:");
	print_debug("    Power LED            %u", outputs.power_led_on);
	print_debug("    Motor                %u", outputs.motor_on);
	print_debug("");
	print_debug("  Computed:");
	int feedpd = get_feedpd();
	print_debug("    Feed per day         %u", feedpd);
	print_debug("    Sec in a day         %lu", DAY / 1000);
	if (feedpd > 0) {
		print_debug("    Sec between feed     %lu", DAY / feedpd / 1000);
		print_debug("    Next dispense in     %lu", ((DAY / feedpd) - get_time_diff(motor_state.last_dispense)) / 1000);
	} else {
		print_debug("    Sec between feed     NA");
		print_debug("    Next dispense in     NA");
	}
	print_debug("    Next blink in        %lu", (BLINK_INTERVAL - get_time_diff(power_led_state.last_blink)) / 1000);
	print_debug("----------------------------");

}
#else
#define print_debug(...) do {} while(0)
#endif

void setup() {
	// Setup libraries
	Wire.begin();

	// setup the pin mode
	pinMode(BUTTON_P, INPUT);
	pinMode(LED_P, OUTPUT);

	// setup the motor
	motor.init(MOTOR_PIN);
	motor.setSpeed(MOTOR_SPEED);

	// initialize states
	power_led_state.last_blink = -BLINK_INTERVAL;
	motor_state.need_init = true;

#ifdef DEBUG
	// setup debug interface and send init message
	setup_debug();
#endif
}

/*
 * Refresh all inputs
 */
void read_inputs() {
	// Read the button state
	inputs.dispense_btn = digitalRead(BUTTON_P) == HIGH;
	// Read the feed per day potentiometer
	inputs.feedpd_pot = analogRead(FREQ_POT_P);
	// Update the current timer
	inputs.now = millis();
}

/*
 * Update the state of the power led
 */
void update_power_led() {
	// Manage LED blinking
	unsigned long diff = get_time_diff(power_led_state.last_blink);
	if (power_led_state.blinking) {
		// stop the LED after DURATION
		if (diff > BLINK_DURATION) {
			// keep track that we need to light off the LED
			power_led_state.blinking = false;
		}
	} else if (diff > BLINK_INTERVAL) {
		// start the LED after INTERVAL
		power_led_state.blinking = true;
		// save the current time
		power_led_state.last_blink = inputs.now;
	}
}

/*
 * Update the state of the motor
 */
void update_motor() {
	// Manage regular feeder
	unsigned long diff = get_time_diff(motor_state.last_dispense);

	if (!motor_state.running) {
		int feedpd = get_feedpd();
		// manage the special case of no feed
		if (feedpd == 0) {
			// ensure initialization will be required
			motor_state.need_init = true;
		} else {
			// if feedpd is not null, run the dispenser if need_init
			// or enough time has passed
			if (motor_state.need_init || diff > (DAY / feedpd)) {
				// Need to dispense
				motor_state.running = true;
				motor_state.last_dispense = inputs.now;
				motor_state.need_init = false;
			}
		}
	} else if (diff > DISPENSE_DURATION) {
		// stop the motor after DURATION
		motor_state.running = false;
	}

	// Force the motor running if dispense btn is pushed
	if (inputs.dispense_btn) {
		motor_state.running = true;
	}
}

/*
 * Refresh all outputs based on states
 */
void write_outputs() {
	// Write power LED output
	// light on if blinking or motor running
	if (power_led_state.blinking or motor_state.running) {
		if (!outputs.power_led_on) digitalWrite(LED_P, HIGH);
		outputs.power_led_on = true;
	} else {
		if (outputs.power_led_on) digitalWrite(LED_P, LOW);
		outputs.power_led_on = false;
	}

	// Control the motor
	if (motor_state.running) {
		if (!outputs.motor_on) {
			// Debug message
			print_debug("Starting motor");
			motor.run(MOTOR_DIRECTION);
		}
		outputs.motor_on = true;
	} else {
		if (outputs.motor_on) {
			// Debug message
			print_debug("Stopping motor");
			motor.run(RELEASE);
		}
		outputs.motor_on = false;
	}
}


void loop() {
	// Read all inputs once per loop
	read_inputs();

	// update states
	update_power_led();
	update_motor();

	// write outputs
	write_outputs();

#ifdef DEBUG
	// Print debug message
	if (get_time_diff(last_debug) > DEBUG_INTERVAL) {
		debug_state();
		last_debug = inputs.now;
	}
#endif
}
