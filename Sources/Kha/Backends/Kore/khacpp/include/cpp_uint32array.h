#pragma once

struct uint32array {
	unsigned int* data;
	int myLength;

	int length() {
		return myLength;
	}

	unsigned int get(int index) {
		return data[index];
	}

	unsigned int set(int index, unsigned int value) {
		return data[index] = value;
	}
};
