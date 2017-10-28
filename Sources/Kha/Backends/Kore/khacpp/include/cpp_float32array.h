#pragma once

struct float32array {
	float* data;
	int myLength;

	int length() {
		return myLength;
	}

	float get(int index) {
		return data[index];
	}

	float set(int index, float value) {
		return data[index] = value;
	}
};
