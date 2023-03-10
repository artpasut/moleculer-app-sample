"use strict";

const { ServiceBroker } = require("moleculer");
const { ValidationError } = require("moleculer").Errors;
const TestService = require("../../../services/calculator.service");
const MathService = require("../../../services/math.service");

describe("Test 'calculator' service", () => {
	let broker = new ServiceBroker({ logger: false });
	broker.createService(TestService);

	beforeAll(() => broker.start());
	afterAll(() => broker.stop());

	describe("Test 'calculator.info' action", () => {

		it("should return with 'Welcome to API calculator'", async () => {
			const res = await broker.call("calculator.info");
			expect(res).toBe("Welcome to API calculator");
		});

	});
});

