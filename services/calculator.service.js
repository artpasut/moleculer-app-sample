"use strict";

/**
 * @typedef {import('moleculer').ServiceSchema} ServiceSchema Moleculer's Service Schema
 * @typedef {import('moleculer').Context} Context Moleculer's Context
 */

/** @type {ServiceSchema} */
module.exports = {
	name: "calculator",
	actions: {
		info: {
			rest: {
				method: "GET",
				path: "/info"
			},
			async handler() {
				return "Welcome to API calculator";
			}
		},
		add: {
			rest: {
				method: "GET",
				path: "/add"
			},
			params: {
				first: { type: "string" },
				second: { type: "string" }
			},
			async handler(ctx) {
				let first = ctx.params.first;
				let second = ctx.params.second;
				return ctx.call("math.add", { a: first, b: second});
			}
		},
		sub: {
			rest: {
				method: "GET",
				path: "/sub"
			},
			params: {
				first: { type: "string" },
				second: { type: "string" }
			},
			async handler(ctx) {
				let first = ctx.params.first;
				let second = ctx.params.second;
				return ctx.call("math.sub", { a: first, b: second});
			}
		}
	}
};
