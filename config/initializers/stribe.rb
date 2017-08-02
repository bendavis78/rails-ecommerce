Rails.configuration.stripe = {
	:publishable_key => "pk_test_JqmWHs4fVcw24LZd46sK2x3b",
	:secret_key => "sk_test_THjUSjiz7d3ytYXJaVib2RWN"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]