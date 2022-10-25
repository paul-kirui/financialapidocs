# Transactions

This document describes the API endpoints that are available to the clients of Balance
who have been whitelisted for programmatic access to their Warm Wallets.

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [Supported Assets](#supported-assets)
- [API URL](#api-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
  - [`POST /api/v2/send_batch_now`](#post-apiv2send_batch_now)

<!-- /MarkdownTOC -->

# Supported Assets

See [Wallet API docs](wallets/README.md#supported-currencies).

# API URL

You will receive your warm wallet integration URL from your point of contact
at Balance, and will look like:
```
YOUR_CUSTOM_SUBDOMAIN.balancecustody.ca
```

----

# Authentication

Due to the nature of the information exposed, every endpoint in this API requires authentication.

For more information on authentication go to [Authentication Docs](../authentication/README.md).

----

# API Endpoints

For brevity, the `curl` examples below do not include headers. See the [`Authentication`](../wallets/README.md#authentication) section for required headers.

Response data is for example purposes only and does not represent real accounts.

### `POST /api/v2/send_batch_now`

Executes a batch withdrawal immediately. Returns an error if any part of the batch withdrawal process halts with an error, and returns a successful response with transaction metadata if the withdrawal gets successfully broadcast to the associated blockchain network.

Batch withdrawals are only possible from a single source wallet for a single asset into one or more destinations. You cannot specify multiple source wallets for a batch withdrawal.

#### Accepted parameters:

Accepts the following parameters as JSON-encoded POST request body. Must specify the `Content-Type: application/json` header with the request.

**`source_wallet_id`**

Required. Integer. ID of the wallet from which the funds are to be withdrawn.

**`asset`**

Required. String. Lowercase asset to be transferred.

Currently only the following assets are supported for this API call:
- `btc` - Bitcoin
- `bch` - Bitcoin Cash ABC
- `dash` - Dash
- `ltc` - Litecoin


**`destinations`**

Required. Array of destination objects specifying the destination and amount of funds to send.

A destination object is polymorphic and has the following fields:

- `amount` - string-encoded integer; Specifies the withdrawal amount to be sent to this destination. Must be specified in the smallest denomination of a given asset possible. For example, must be specified in `Satoshis` for `btc`.
- `type` - string; can be one of the following values: `wallet`, `external_account`, `public_address`
- `id` - integer; specifies the ID of a `wallet` or `external_account` within your Balance Custody account. Can NOT be used with `public_address` type.
- `public_address` - string; specifies the public address where the funds are to be sent. Can ONLY be used with `public_address` type.

#### Examples:

The following example will create a batch transaction out of `Wallet 3` to the following destinations:
- 0.1 BTC to a Balance Wallet with ID `10`
- 0.02 BTC to a Balance External Account with ID `33`
- 10.12 BTC to a Bitcoin public address `mztPG6nBar1mZ5J7T619iCuFP9SB5G9j5W`

Example request body:
```json
{
  "source_wallet_id": 3,
  "asset": "btc",
  "destinations": [
    {
      "type": "wallet",
      "id": 10,
      "amount": "10000000"
    },
    {
      "type": "external_account",
      "id": 33,
      "amount": "2000000"
    },
    {
      "type": "public_address",
      "public_address": "mztPG6nBar1mZ5J7T619iCuFP9SB5G9j5W",
      "amount": "1012000000"
    }
  ]
}
```

Example `curl` command:

```bash
curl -XPOST \
     -d '{"source_wallet_id":3,"asset":"btc","destinations":[{"type":"wallet","id":10,"amount":"10000000"},{"type":"external_account","id":33,"amount":"2000000"},{"type":"public_address","public_address":"mztPG6nBar1mZ5J7T619iCuFP9SB5G9j5W","amount":"1012000000"}]}' \
     https://your_custom_subdomain.balancecustody.ca/api/v2/send_batch_now
```
