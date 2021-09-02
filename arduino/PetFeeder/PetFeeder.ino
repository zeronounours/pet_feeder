// include required for I2C communication of rotoshield
#include <Wire.h>

#include "snootor.h"


// Used PINs
#define BUTTON_P 7
#define LED_P 8

// LED blinking conf
#define BLINK_INTERVAL 10000 // in millisecond
#define BLINK_DURATION 1000  // in millisecond

// Motor conf
#define MOTOR_DIRECTION FORWARD
#define MOTOR_SPEED 255  // 0 -> no movement     255 -> max speed
#define MOTOR_PIN 3  // because of some issues, some combinaison of motors
                     // do not work. Motors 1 and 2 do not work alone.

// to keep track of the button
int btn_state = 0;

// to keep track of the time and LED state
bool led_need_blink_on = false;
bool led_need_btn_on = false;
bool led_state = false;
unsigned long last_led_blink = -BLINK_INTERVAL;

// to keep track of the motor state
bool motor_need_on = false;
bool motor_state = false;

// motor definition
SnootorDC motor;

void setup() {
	// Setup libraries
	Serial.begin(115200);
	Wire.begin();

	// setup the pin mode
	pinMode(BUTTON_P, INPUT);
	pinMode(LED_P, OUTPUT);

	// setup the motor
	motor.init(MOTOR_PIN);
	motor.setSpeed(MOTOR_SPEED);

	// Debug message
	Serial.println("Initialization of the board OK");
}


void loop() {
	// Manage LED blinking
	unsigned long now = millis();
	unsigned long diff;
	// Compute the time diff considering the possible overflow of millis()
	if (now < last_led_blink) {
		// Overflow happened
		diff = ((unsigned long) -1) - last_led_blink + now + 1;
	} else {
		// no overflow
		diff = now - last_led_blink;
	}
	if (led_need_blink_on) {
		// stop the LED after DURATION
		if (diff > BLINK_DURATION) {
			// keep track that we need to light off the LED
			led_need_blink_on = false;
		}
	} else if (diff > BLINK_INTERVAL) {
		// save the current time
		last_led_blink = now;
		// keep track that we need to light the LED
		led_need_blink_on = true;
	}

	// Read the button state
	btn_state = digitalRead(BUTTON_P);

	// Do the action depending of the state
	if (btn_state == HIGH) {
		led_need_btn_on = true;
		motor_need_on = true;
	} else {
		led_need_btn_on = false;
		motor_need_on = false;
	}

	// Output the signal of the LED
	if (led_need_blink_on || led_need_btn_on) {
		if (!led_state) digitalWrite(LED_P, HIGH);
		led_state = true;
	} else {
		if (led_state) digitalWrite(LED_P, LOW);
		led_state = false;
	}

	// Control the motor
	if (motor_need_on) {
		if (!motor_state) {
			// Debug message
			Serial.println("Starting motor");
			motor.run(MOTOR_DIRECTION);
		}
		motor_state = true;
	} else {
		if (motor_state) {
			// Debug message
			Serial.println("Stopping motor");
			motor.run(RELEASE);
		}
		motor_state = false;
	}
}
