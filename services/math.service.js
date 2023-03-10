/**
 * @typedef {import('moleculer').ServiceSchema} ServiceSchema Moleculer's Service Schema
 * @typedef {import('moleculer').Context} Context Moleculer's Context
 */

/** @type {ServiceSchema} */
module.exports = {
	name: "math",
	setting: {
		fields: [
			"result"
		]
	},
	actions: {
		add(ctx) {
			const result = Number(ctx.params.a) + Number(ctx.params.b);
			return { 
				result: result
			};
		},

		sub(ctx) {
			const result = Number(ctx.params.a) - Number(ctx.params.b);
			return {
				result: result
			};
		}
	}
};