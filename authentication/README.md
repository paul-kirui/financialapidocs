# Authentication

This document describes the authentication scheme used in API endpoints that require it.

The authentication scheme used is based on HMAC, and follows a scheme similar to that of AWS.

You will get your `ACCESS_ID` and `SECRET_KEY` from your point of contact at Balance.

### How it works

#### 1. Create a canonical string for your request:

```ruby
canonical_string = "#{http_method},#{content_type},#{request_uri},#{data_hash},#{timestamp}"
```

Details:

- `http_method` is an upper case version of the full HTTP method. Supported methods for this API are: `GET, POST, PUT, PATCH, DELETE`
- `content_type` is a copy of the `Content-Type` header. For this API, set this to `application/json`.
- `request_uri` is the URI of the request. Do not include query params. For example: `/api/v1/wallets`
- `data_hash` is a SHA-256 hash of the request body, encoded as a HEX string. If the body field is empty, leave this field as an empty string. For example, if the body is the following string: `{"name": "foobar"}`, the `data_hash` field should be set to: `e684679449a32cb2477110ce15b02eace29dbfc89b9f8597a90d5702d5f60695`
- `timestamp` is a UNIX timestamp equivalent of the `Date` header. E.g. `1561661184` (equivalent to `Thu, 27 Jun 2019 18:46:24 GMT`). Note that if this date is more than 15 minutes behind or ahead of the server's current date, the request will be rejected.

#### 2. Create a signature

The signature is a SHA-256 based HMAC signature, keyed on the `SECRET_KEY` provided to you by Balance. The signature must be HEX-encoded.

An example of this code in Ruby would be:
```ruby
signature = OpenSSL::HMAC.digest("SHA256", SECRET_KEY, canonical_string).unpack("H*").first
```

#### 3. Add headers to your request

Your request now requires the following headers:

- `Content-Type` - this header should always be set to `application/json` for this API
- `Date` - current date (see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date)
- `Authorization` - should be constructed in the following way: `BalanceAPIAuth #{ACCESS_ID}:#{signature}`

### Examples

For each example, assume that your authentication credentials are:
```bash
ACCESS_ID="eSKzYGehz5s8R9QJ3"
SECRET_KEY="3mUgEnXkm8UR57RaLycP9Cu7pga4PELdzu2mfbHv6r3E"
```

And the timestamp is the following:
```
Thu, 27 Jun 2019 18:46:24 GMT
```

which is equivalent to a UNIX epoch timestamp of:
```
1561661184
```

#### POST request with data:

The following is a valid curl POST request:

```bash
curl -XPOST \
     -H "Content-Type: application/json" \
     -H "Date: Thu, 27 Jun 2019 18:46:24 GMT" \
     -H "Authorization: BalanceAPIAuth eSKzYGehz5s8R9QJ3:c3b2f03bb3334ea9a81c0fb1ae3d610a253cebe9b9b4bac62e404a245cf3363d" \
     -d '{"name": "foo", "description": "bar"}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets
```

Note that this should produce the following `canonical_string`:

```
POST,application/json,/api/v1/wallets,bfb3244e37e4f79fd7aa50213fae150cae746f65b8194248b8c4b21c69f070f0,1561661184
```

#### GET request without data:

The following is a valid curl GET request:

```bash
curl -H "Content-Type: application/json" \
     -H "Date: Thu, 27 Jun 2019 18:46:24 GMT" \
     -H "Authorization: BalanceAPIAuth eSKzYGehz5s8R9QJ3:05c8fc86fa0568ec05412caab4327e3a7baf78f288832a53bc54cf168a15d3f8" \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets
```

Note that this should produce the following `canonical_string`:

```
GET,application/json,/api/v1/wallets,,1561661184
```
