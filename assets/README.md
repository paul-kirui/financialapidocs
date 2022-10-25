# Assets

This document describes API endpoints used for controlling asset sub-addresses. It is available to the clients of Balance
who have been whitelisted for programmatic access to their Warm Wallets.

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [Supported Currencies](#supported-currencies)
- [API URL](#api-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
    - [`GET /api/v1/wallets/:wallet_id/assets/:currency`](#get-apiv1walletswallet_idassetscurrency)
    - [`POST /api/v1/wallets/:wallet_id/assets/:currency`](#post-apiv1walletswallet_idassetscurrency)
    - [`PUT /api/v1/wallets/:wallet_id/assets/:currency/:address`](#put-apiv1walletswallet_idassetscurrencyaddress)
    - [`GET /api/v2/assets/:currency`](#get-apiv2assetscurrency)
- [Errors](#errors)

<!-- /MarkdownTOC -->


# Supported Currencies

Currently only the following currencies support sub-addresses:
- **Bitcoin** (`btc`)
- **Bitcoin Cash** (`bch`)
- **Litecoin** (`ltc`)
- **Dash** (`dash`)

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

For brevity, the `curl` examples below do not include headers. See the [`Authentication`](wallets/README.md#authentication) section for required headers.

Response data is for example purposes only and does not represent real crypto addresses.

### `GET /api/v1/wallets/:wallet_id/assets/:currency`

List all active funding addresses for given currency and wallet.

#### Request
Example:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/assets/btc
```

#### Response
Returns an array of transaction JSON structs.

Status: `200`

Example of api response:
```json
[
    {
        "name": "Bitcoin 1",
        "notes": null,
        "address": "14v9vRC3R1HJqRrgG9mDnuzzHSFvMHvRSA",
        "balance": 12.34567890,
        "is_watched": false
    },
    {
        "name": "API Created",
        "notes": "some notes",
        "address": "1Aipi2Sxt5XrDzaFmvReWos8Jzi6uZtLXU",
        "balance": 12.34567890,
        "is_watched": true
    }
]
```

### `POST /api/v1/wallets/:wallet_id/assets/:currency`

Will create a new funding address for the given currency and return a list of all active funding addresses for the specified wallet and currency pair.

#### Accepted parameters:
- `name` - string, sets the `name` field of the newly created address
- `notes` - string, sets the `notes` field of the newly created address
- `is_watched` - boolean, sets the `is_watched` field of the newly created address. The current user that made the api call will be added as a watcher.

Parameters must be serialized into a JSON object with the above fields set as top-level
keys in the object. This JSON string must be passed in as part of request body.

##### Request
```bash
curl -XPOST \
    -d '{"name": "Test BTC address 2", "notes": "Address created via the api", "is_watched": true}' \
    -H "content-type: application/json" \
    https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/assets/btc
```

##### Successful Response
Returns a transaction JSON struct.

Status: `200`

Data:
```json
[
    {
        "name": "Bitcoin 1",
        "notes": null,
        "address": "14v9vRC3R1HJqRrgG9mDnuzzHSFvMHvRSA",
        "balance": 12.34567890,
        "is_watched": false
    },
    {
        "name": "Test BTC address 2",
        "notes": "Address created via the api",
        "address": "1Aipi2Sxt5XrDzaFmvReWos8Jzi6uZtLXU",
        "balance": 0,
        "is_watched": true
    }
]
```

##### Failed Response - Not supported currency
Returns a transaction JSON struct.

Status: `400`

Data:
```json
{
  "error": "Currency eth does not support sub-addresses."
}
```

### `PUT /api/v1/wallets/:wallet_id/assets/:currency/:address`

Will update an existing funding address for the given currency and return the updated address.

#### Accepted parameters:
- `name` - string, sets the `name` field of the newly created address
- `notes` - string, sets the `notes` field of the newly created address
- `is_watched` - boolean, sets the `is_watched` field of the newly created address. The current user that made the api call will be added as a watcher.

Parameters must be serialized into a JSON object with the above fields set as top-level
keys in the object. This JSON string must be passed in as part of request body.

No extra parameters are accepted.

##### Request
```bash
curl -d '{"name": "Updated Name", "notes": "Updated notes", "is_watched": true}' \
    -H "content-type: application/json" \
    https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/assets/btc/14v9vRC3R1HJqRrgG9mDnuzzHSFvMHvRSA
```

##### Successful Response
Returns a transaction JSON struct.

Status: `200`

Data:
```json
{
    "name": "Updated Name",
    "notes": "Updated notes",
    "address": "14v9vRC3R1HJqRrgG9mDnuzzHSFvMHvRSA",
    "balance": 12.34567890,
    "is_watched": true
}
```

##### Failed Response - Not supported currency
Returns a transaction JSON struct.

Status: `400`

Data:
```json
{
  "error": "Currency eth does not support sub-addresses."
}
```

### `GET /api/v2/assets/:currency`

List wallets having positive balances of the specified currency.

#### Accepted parameters:

Accepts the following GET parameters as part of the query string:

**`order_by`**

Optional. Specifies how to sort the wallets.
If not specified will sort by wallet ID descending.

Possible values are:

- `id` - Wallet ID descending.
- `balance` - Balance descending..

**`page`**

Optional. If specified returns results from the specified page. Page numbers begin at 1.
If not specified returns the first page.


#### Request
Example with defaults:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v2/assets
```

Example with options:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v2/assets?order_by=balance&page=2
```

#### Response
Returns an array of wallet JSON structs.

Status: `200`

Data:
```json
{
    "wallets":
    [
        {
            "id": 1,
            "type": "wallet",
            "kind": "warm",
            "custom_id": "editable custom id 1",
            "name": "editable name 1",
            "description": "editable description 1",
            "balance": {
                "btc":  12.34567890,
                "bch":  12.34567890,
                "ltc":  12.34567890,
                "dash": 12.34567890,
                "eth":  12.34567890
            },
            "funding_addresses": {
                "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
                "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
                "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
                "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
                "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4"
            }
        },
        {
            "id": 2,
            "type": "wallet",
            "kind": "warm",
            "custom_id": "editable custom id 2",
            "name": "editable name 2",
            "description": "editable description 2",
            "balance": {
                "btc":  12.34567890,
                "bch":  12.34567890,
                "ltc":  12.34567890,
                "dash": 12.34567890,
                "eth":  12.34567890
            },
            "funding_addresses": {
                "btc":  "1EWwLtiDvrLKKf6ySDoKqnFYLvcDMr2TvY",
                "bch":  "16CyXcfgoRzBmxC3PzwwQgf8vdovtcGcRi",
                "ltc":  "LbeFePhgCMjnVgNtVCYUpJsPxA7VScd8jE",
                "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
                "eth":  "0x3Dbd0Ec235A15C16F419f990d67B48eb5c04ae09"
            }
        }
    ]
}
```

# Errors

Errors in this API are the same as the ones specified in the [wallet API docs](wallets/README.md#errors).
