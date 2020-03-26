defmodule VisaCheckout do
  @moduledoc """
  Visa Checkout API reference: https://developer.visa.com/capabilities/visa_checkout/reference
  """

  alias VisaCheckout.{Http, Util}

  @doc """
  Get payment data

  Visa Checkout API reference: https://developer.visa.com/capabilities/visa_checkout/reference#visa_checkout__get_payment_data_api____get_payment_data

  ## Example
  ```
    VisaCheckout.get_payment_data("call_id")
  ```
  """
  def get_payment_data(call_id) do
    endpoint = build_endpoint("data", call_id)

    endpoint
    |> Http.get(build_token_header(endpoint))
    |> handle_response
  end

  @doc """
  Update payment info

  Visa Checkout API reference: https://developer.visa.com/capabilities/visa_checkout/reference#visa_checkout__update_payment_information____update_payment_info

  ## Example
  ```
    VisaCheckout.update_payment_info("call_id", %{orderInfo: ...})
  ```
  """
  def update_payment_info(call_id, params) do
    endpoint = build_endpoint("info", call_id)

    endpoint
    |> Http.put(params, build_token_header(endpoint, params))
    |> handle_response
  end

  defp build_endpoint(endpoint, call_id) do
    "/#{endpoint}/#{call_id}?apikey=#{Util.api_key()}"
  end

  defp build_token_header(endpoint, params \\ nil) do
    token = build_token(endpoint, params)
    [{"x-pay-token", token}]
  end

  defp build_token(endpoint, params) do
    timestamp = :os.system_time(:seconds)
    string_params =
      if is_nil(params) do
        ""
      else
        Jason.encode!(params)
      end

    token =
      Util.secret()
      |> Util.hmac("#{timestamp}payment#{String.replace(endpoint, "?", "")}#{string_params}")
      |> Base.encode16
      |> String.downcase

    "xv2:#{timestamp}:#{token}"
  end

  defp handle_response({:ok, response}) do
    case response.status_code do
      200 ->
        if is_map(response.body) && Map.has_key?(response.body, "encKey") && Map.has_key?(response.body, "encPaymentData") do
          decrypted_payload = Util.decrypt_payload(response.body["encKey"], response.body["encPaymentData"])
          {:ok, decrypted_payload}
        else
          {:ok, response.body}
        end
      _ -> {:error, response}
    end
  end
  defp handle_response({:error, error}) do
    {:error, error}
  end
end
