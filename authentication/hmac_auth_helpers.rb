require 'openssl'
require 'time'

module HMACAuthHelpers
  # Sign with HMAC-SHA256 and return the hex-encoded string
  def self.get_hmac_signature(secret_key, canonical_string)
    return OpenSSL::HMAC.digest('SHA256', secret_key, canonical_string).unpack("H*").first
  end

  # Create a canonical string from request params
  def self.make_canonical_string(
      http_method: 'GET',
      content_type: 'application/json',
      request_uri:,
      data: '',
      timestamp: Time.now.to_i
    )

    data_hash = (data.nil? || data.empty?) ? '' : Digest::SHA256.hexdigest(data)

    return "#{http_method},#{content_type},#{request_uri},#{data_hash},#{timestamp}"
  end

  # Create a curl command that can be pasted into the shell for testing
  def self.print_curl_request(
      url_base: 'localhost:3000',
      http_method: 'GET',
      request_uri:,
      data: '',
      access_id:,
      secret_key:
    )

    now = Time.now

    canonical_string = make_canonical_string(
      http_method: http_method,
      request_uri: request_uri,
      data: data,
      timestamp: now.to_i,
    )

    signature = get_hmac_signature(secret_key, canonical_string)

    curl_str =  "curl -X#{http_method.upcase} \\ \n"
    curl_str += "     -H \"Content-Type: application/json\" \\ \n"
    curl_str += "     -H \"Date: #{now.httpdate}\" \\ \n"
    curl_str += "     -H \"Authorization: BalanceAPIAuth #{access_id}:#{signature}\" \\ \n"

    unless data.nil? || data.empty?
      curl_str += "     -d '#{data}' \\ \n"
    end

    curl_str += "     #{url_base}#{request_uri}"

    puts curl_str
  end
end
