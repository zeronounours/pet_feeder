// Used PINs
const int BUTTON_P = 7;
const int LED_P = 8;

// LED blinking conf
const unsigned long BLINK_INTERVAL = 5000; // in millisecond
const unsigned long BLINK_DURATION = 1000; // in millisecond

// to keep track of the button
int btn_state = 0;

// to keep track of the time and LED state
bool led_blink_on = false;
bool led_btn_on = false;
bool led_state = false;
unsigned long last_led_blink = 0;


void setup() {
	// setup the pin mode
	pinMode(BUTTON_P, INPUT);
	pinMode(LED_P, OUTPUT);
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
	if (led_blink_on) {
		// stop the LED after DURATION
		if (diff > BLINK_DURATION) {
			// keep track that we need to light off the LED
			led_blink_on = false;
		}
	} else if (diff > BLINK_INTERVAL) {
		// save the current time
		last_led_blink = now;
		// keep track that we need to light the LED
		led_blink_on = true;
	}

	// Read the button state
	btn_state = digitalRead(BUTTON_P);

	// Do the action depending of the state
	if (btn_state == HIGH) {
		led_btn_on = true;
	} else {
		led_btn_on = false;
	}

	// Output the signal of the LED
	if (led_blink_on || led_btn_on) {
		if (!led_state) digitalWrite(LED_P, HIGH);
		led_state = true;
	} else {
		if (led_state) digitalWrite(LED_P, LOW);
		led_state = false;
	}
}
