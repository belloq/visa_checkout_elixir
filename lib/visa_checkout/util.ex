defmodule VisaCheckout.Util do
  def api_key do
    Application.get_env(:visa_checkout_elixir, :api_key, System.get_env("VISA_CHECKOUT_API_KEY"))
  end

  def secret do
    Application.get_env(:visa_checkout_elixir, :secret, System.get_env("VISA_CHECKOUT_SECRET"))
  end

  def decrypt_payload(wrapped_key, payload) do
    {:ok, unwrapped_key} = decrypt(secret(), wrapped_key)
    {:ok, decrypted_payload} = decrypt(unwrapped_key, payload)
    Jason.decode!(decrypted_payload, keys: :atoms)
  end

  def decrypt(key, encoded_data) do
    {:ok, decoded_data} = Base.decode64(encoded_data)
    hmac = binary_part(decoded_data, 0, 32)
    iv = binary_part(decoded_data, 32, 16)
    data = binary_part(decoded_data, 48, byte_size(decoded_data) - 48)
    # hmac validation
    if hmac == hmac(key, iv <> data) do
      {:ok, unpad(:crypto.block_decrypt(:aes_cbc256, hash(key), iv, data))}
    else
      {:error, :hmac_validation_failed}
    end
  end

  def hash(data) do
    :crypto.hash(:sha256, data)
  end

  def hmac(key, data) do
    :crypto.hmac(:sha256, key, data)
  end

  def unpad(data) do
    to_remove = :binary.last(data)
    :binary.part(data, 0, byte_size(data) - to_remove)
  end
end
