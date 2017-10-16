# Visa Checkout for Elixir

A [Visa Checkout](https://developer.visa.com/capabilities/visa_checkout) library for Elixir.

[Documentation](http://hexdocs.pm/visa_checkout_elixir)

## Installation

Add `visa_checkout_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:visa_checkout_elixir, "~> 1.0"}
  ]
end
```

## Configuration

To make API calls, it's necessary to configure your Visa Checkout keys.

Add to your config:
```elixir
config :visa_checkout_elixir,
  api_key: "YOUR_API_KEY",
  secret: "YOUR_SECRET"
```
or add to your environment:
```bash
export VISA_CHECKOUT_API_KEY=YOUR_API_KEY
export VISA_CHECKOUT_SECRET=YOUR_SECRET
```

If you want to use it in sandbox mode:
```elixir
config :visa_checkout_elixir, sandbox: true
```

## Api

### Get payment data

```elixir
VisaCheckout.get_payment_data("call_id")
```

### Update payment info

```elixir
VisaCheckout.update_payment_info("call_id", %{orderInfo: ...})
```
