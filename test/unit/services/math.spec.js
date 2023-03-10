"use strict";

const { ServiceBroker } = require("moleculer");
const { ValidationError } = require("moleculer").Errors;
const TestService = require("../../../services/math.service");

describe("Test 'math' service", () => {
	let broker = new ServiceBroker({ logger: false });
	broker.createService(TestService);

	beforeAll(() => broker.start());
	afterAll(() => broker.stop());

	describe("Test 'math.add' action", () => {

		it("should return with '{ result: 3 }'", async () => {
			const res = await broker.call("math.add", { a: 1, b: 2 });
			expect(res).toStrictEqual({ 
				"result": 3 
			});
		});

		it("should reject an ValidationError", async () => {
			try {
				await broker.call("math.add");
			} catch(err) {
				expect(err).toBeInstanceOf(ValidationError);
			}
		});

	});

    describe("Test 'math.sub' action", () => {

		it("should return with '{ result: 1 }'", async () => {
			const res = await broker.call("math.sub", { a: 2, b: 1 });
			expect(res).toStrictEqual({ 
				"result": 1 
			});
		});

		it("should reject an ValidationError", async () => {
			try {
				await broker.call("math.sub");
			} catch(err) {
				expect(err).toBeInstanceOf(ValidationError);
			}
		});

	});
});

