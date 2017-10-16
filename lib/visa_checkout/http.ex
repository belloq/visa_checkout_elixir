defmodule VisaCheckout.Http do
  use HTTPoison.Base

  @live_url "https://secure.checkout.visa.com/"
  @sandbox_url "https://sandbox.secure.checkout.visa.com/"
  @service_endpoint "wallet-services-web/payment"

  def process_url(endpoint) do
    api_url() <> @service_endpoint <> endpoint
  end

  def process_request_headers(headers \\ []) do
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
    ] ++ headers
  end

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_response_body(body) do
    if String.length(body) > 0 do
      Poison.decode!(body, [keys: :atoms])
    else
      %{}
    end
  end

  defp api_url do
    if Application.get_env(:visa_checkout_elixir, :sandbox, false) do
      @sandbox_url
    else
      @live_url
    end
  end
end
