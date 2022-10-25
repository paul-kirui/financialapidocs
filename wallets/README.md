# Wallets

This document describes the API endpoints that are available to the clients of Balance
who have been whitelisted for programmatic access to their Wallets (both Cold and Warm).

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [Supported Currencies](#supported-currencies)
- [API URL](#api-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
    - [`GET /api/v1/wallets`](#get-apiv1wallets)
    - [`GET /api/v1/wallets/:id`](#get-apiv1walletsid)
    - [`POST /api/v1/wallets`](#post-apiv1wallets)
    - [`PUT /api/v1/wallets/:id`](#put-apiv1walletsid)
    - [`GET /api/v1/wallets/:wallet_id/transactions`](#get-apiv1walletswallet_idtransactions)
    - [`GET /api/v1/wallets/:wallet_id/transactions/:transaction_id`](#get-apiv1walletswallet_idtransactionstransaction_id)
    - [`POST /api/v1/wallets/:wallet_id/transactions`](#post-apiv1walletswallet_idtransactions)
- [Errors](#errors)
        - [Status: 400](#status-400)
        - [Status: 401](#status-401)
        - [Status: 403](#status-403)
        - [Status 404](#status-404)
        - [Status 500](#status-500)
- [Helper Library](#helper-library)

<!-- /MarkdownTOC -->

# Supported Currencies

Below is a list of currencies generally supported by most APIs, unless specified otherwise.
When interacting with the api, the lowercase ticker symbol must be used.

- **Bitcoin** (`btc`)
- **Bitcoin Cash** (`bch`)
- **Litecoin** (`ltc`)
- **Dash** (`dash`)
- **Ethereum** (`eth`)
- **Ethereum Classic** (`etc`)
- **Ripple** (`xrp`)
- **Stellar Lumens** (`xlm`)
- **Paxos** (`pax`)
- **USD Coin** (`usdc`)
- **Paxos Gold** (`paxg`)
- **Stasis EURS** (`eurs`)
- **QCAD** (`qcad`)
- **BR.Mint** (`brlm`)
- **Canadian Natural Dollar** (`cdag`)
- **Monero** (`xmr`)
- **AION** (`aion`)
- **QCAD** (`qcad`)

# API URL

You will receive your wallet integration URL from your point of contact
at Balance, and will look like:
```
YOUR_CUSTOM_SUBDOMAIN.balancecustody.ca
```

# Authentication

Due to the nature of the information exposed, every endpoint in this API requires authentication.

For more information on authentication go to [Authentication Docs](../authentication/README.md).


# API Endpoints

For brevity, the `curl` examples below do not include headers. See the `Authentication` section above for required headers.

Response data is for example purposes only and does not represent real crypto accounts.

## `GET /api/v1/wallets`

List all wallets.

#### Accepted parameters:

Accepts the following GET parameters as part of the query string:

**`type`**

Optional. Specifies whether to return warm or cold wallets.
If not specified, returns all wallets.

Possible values are:

- `warm` - Warm wallets.
- `cold` - Cold wallets.

**`created_since`**

Optional. If specified, returns wallets that were created after the given timestamp.
If not specified, returns all wallets.

Values are UNIX timestamps (in seconds).

**`custom_id`**

Optional. Allows to search for wallets with a given Custom ID field.
If not specified, returns all wallets.

#### Request
Example without filters:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets
```

Example with the `type` filter:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets?type=warm
```

Example with all filters:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets?type=warm\&created_since=1585598824\&custom_id=foobar
```

#### Response
Returns an array of wallet JSON structs.

Status: `200`

Data:
```json
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
            "eth":  12.34567890,
            "etc":  12.34567890,
            "xrp":  12.34567890,
            "xlm":  12.34567890,
            "pax":  12.34567890,
            "usdc": 12.34567890,
            "aion": 12.34567890
        },
        "funding_addresses": {
            "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
            "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
            "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
            "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
            "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
            "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
            "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
            "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
            "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
            "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a",
            "aion": "0xa0e01a07baa6ec547d536981d8f7df86eb90d23970da4348574aa87f89eb1e1f"
        },
        "extras": {
            "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                "tag": "xrp tag"
            },
            "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                "memo": "xlm memo"
            }
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
            "eth":  12.34567890,
            "etc":  12.34567890,
            "xrp":  12.34567890,
            "xlm":  12.34567890,
            "pax":  12.34567890,
            "usdc": 12.34567890,
            "aion": 12.34567890,
        },
        "funding_addresses": {
            "btc":  "1EWwLtiDvrLKKf6ySDoKqnFYLvcDMr2TvY",
            "bch":  "16CyXcfgoRzBmxC3PzwwQgf8vdovtcGcRi",
            "ltc":  "LbeFePhgCMjnVgNtVCYUpJsPxA7VScd8jE",
            "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
            "eth":  "0x3Dbd0Ec235A15C16F419f990d67B48eb5c04ae09",
            "etc":  "0x4d35262056fb60e00BBc117a6c535f43fe4ED663",
            "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
            "xlm":  "GBBCHCAAFACXZXELWKOLM4QU52FOM6PEBBMJ54O57K6QWFSM6TGEI2QO",
            "pax":  "0x32D7335171B0b57522D810c264a1264c9509b620",
            "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a",
            "aion": "0xa0e01a07baa6ec547d536981d8f7df86eb90d23970da4348574aa87f89eb1e1f"
        },
        "extras": {
            "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                "tag": "xrp tag"
            },
            "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                "memo": "xlm memo"
            }
        }
    }
]
```

## `GET /api/v1/wallets/:id`

Show details for a single wallet. No parameters accepted.

NOTE: this endpoint will also return a "spendable_balance" field that can be used to query
funds that are currently spendable (i.e. not locked in other pending or unconfirmed transactions).

#### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1
```

#### Response
Returns a single wallet JSON struct.

Status: `200`

Data:
```json
{
    "id": 1,
    "kind": "warm",
    "type": "wallet",
    "custom_id": "editable custom id 1",
    "name": "editable name 1",
    "description": "editable description 1",
    "balance": {
        "btc":  12.34567890,
        "bch":  12.34567890,
        "ltc":  12.34567890,
        "dash": 12.34567890,
        "eth":  12.34567890,
        "etc":  12.34567890,
        "xrp":  12.34567890,
        "xlm":  12.34567890,
        "pax":  12.34567890,
        "usdc": 12.34567890
    },
    "spendable_balance": {
        "btc":  12.34567890,
        "bch":  12.34567890,
        "ltc":  12.34567890,
        "dash": 12.34567890,
        "eth":  12.34567890,
        "etc":  12.34567890,
        "xrp":  12.34567890,
        "xlm":  12.34567890,
        "pax":  12.34567890,
        "usdc": 12.34567890
    },
    "funding_addresses": {
        "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
        "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
        "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
        "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
        "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
        "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
        "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
        "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
        "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
        "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
    },
    "extras": {
        "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
            "tag": "xrp tag"
        },
        "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
            "memo": "xlm memo"
        },
        "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4": [
            {
                "validator_name": "eth2-deposit-contract-validator",
                "validator_pubkey": "0xd27c0a7cdc376aac12dc1c346c8eaf26cf3d8c0857552a176ab96c5c6dfaa3178db8fef807b5e2c5966ee7432100f367",
                "validator_status": "active",
                "deposit_amount": 32,
                "rewards": 1.23,
                "total_balance": 33.23
            }
        ]
    }
}
```

## `POST /api/v1/wallets`

Creates a new warm wallet. `Content-Type` header must be set to `application/json`.
Note that it's not possible to create a cold wallet using this API.
Cold wallets must be created via the web UI.

#### Accepted parameters:
- `name` - string, sets the `name` field of the warm wallet struct
- `description` - string, sets the `description` field of the warm wallet struct
- `custom_id` - string, sets the `custom_id` field of the warm wallet struct. This field is purely for
your own internal tracking systems, and will not be queryable.
- `kind` - string, specifies whether to create a cold or a warm wallet; accepted values are "cold" or "warm"; note that cold wallets are pre-generated in batches, and this API call may throw an error if no more cold wallets are available for use. In this scenario you will need to contact your custodian.
- `default_originator_entity` - Travel Rule Entity struct; optional; see [Regulatory Compliance Integration Docs](regulatory/README.md#travel-rule-entity-struct) for the definition of this field and examples for its use.

Parameters must be serialized into a JSON object with the above fields set as top-level
keys in the object. This JSON string must be passed in as part of request body.

No extra parameters are accepted.

#### Request
```bash
curl -XPOST \
     -d '{"name": "foo", "description": "bar", "custom_id": "ABCDefgh123"}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets
```

#### Response
Returns a single wallet JSON struct for the newly created warm wallet.

Status: `200`

Data:
```json
{
    "id": 1,
    "type": "wallet",
    "kind": "warm",
    "custom_id": "ABCDefgh123",
    "name": "foo",
    "description": "bar",
    "balance": {
        "btc":  12.34567890,
        "bch":  12.34567890,
        "ltc":  12.34567890,
        "dash": 12.34567890,
        "eth":  12.34567890,
        "etc":  12.34567890,
        "xrp":  12.34567890,
        "xlm":  12.34567890,
        "pax":  12.34567890,
        "usdc": 12.34567890
    },
    "spendable_balance": {
        "btc":  12.34567890,
        "bch":  12.34567890,
        "ltc":  12.34567890,
        "dash": 12.34567890,
        "eth":  12.34567890,
        "etc":  12.34567890,
        "xrp":  12.34567890,
        "xlm":  12.34567890,
        "pax":  12.34567890,
        "usdc": 12.34567890
    },
    "funding_addresses": {
        "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
        "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
        "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
        "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
        "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
        "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
        "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
        "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
        "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
        "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
    },
    "extras": {
        "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
            "tag": "xrp tag"
        },
        "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
            "memo": "xlm memo"
        }
    }
}
```

## `PUT /api/v1/wallets/:id`

Edits the basic metadata on an existing wallet. `Content-Type` header must be set to `application/json`.

#### Accepted parameters:

(Same parameters as in `POST /api/v1/wallets`)

- `name` - string, sets the `name` field of the warm wallet struct
- `description` - string, sets the `description` field of the warm wallet struct
- `custom_id` - string, sets the `custom_id` field of the warm wallet struct
- `default_originator_entity` - Travel Rule Entity struct; optional; see [Regulatory Compliance Integration Docs](regulatory/README.md#travel-rule-entity-struct) for the definition of this field and examples for its use.

Parameters must be serialized into a JSON object with the above fields set as top-level
keys in the object. This JSON string must be passed in as part of request body.

No extra parameters are accepted.

#### Request
```bash
curl -XPUT \
     -d '{"name": "updated foo", "description": "updated bar", "custom_id": "updated ABCDefgh123"}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1
```

#### Response
Returns a single wallet JSON struct for the edited wallet.

Status: `200`

Data:
```json
{
    "id": 1,
    "type": "wallet",
    "kind": "warm",
    "custom_id": "updated ABCDefgh123",
    "name": "updated foo",
    "description": "updated bar",
    "balance": {
        "btc":  12.34567890,
        "bch":  12.34567890,
        "ltc":  12.34567890,
        "dash": 12.34567890,
        "eth":  12.34567890,
        "etc":  12.34567890,
        "xrp":  12.34567890,
        "xlm":  12.34567890,
        "pax":  12.34567890,
        "usdc": 12.34567890
    },
    "spendable_balance": {
        "btc":  12.34567890,
        "bch":  12.34567890,
        "ltc":  12.34567890,
        "dash": 12.34567890,
        "eth":  12.34567890,
        "etc":  12.34567890,
        "xrp":  12.34567890,
        "xlm":  12.34567890,
        "pax":  12.34567890,
        "usdc": 12.34567890
    },
    "funding_addresses": {
        "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
        "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
        "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
        "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
        "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
        "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
        "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
        "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
        "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
        "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
    },
    "extras": {
        "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
            "tag": "xrp tag"
        },
        "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
            "memo": "xlm memo"
        }
    }
}
```

## `GET /api/v1/wallets/:wallet_id/transactions`

List all transactions for a given wallet. Includes internal and external transactions.

**Internal** transactions are defined as transactions between your Cold or Warm wallets managed by Balance Custody.

**External** transactions are defined as transactions that are originated externally, destined for your Cold or Warm wallets
managed by Balance Custody.

#### Accepted parameters:

Accepts the following GET parameters as part of the query string:

**`status`**

Optional. Indicates the status of the transaction to query for. If not specified,
returns all transactions.

Possible values are:

- `pending_approval` - Transaction is in this state if your wallets are set up to require extra approvals before being signed and broadcast by the wallets.
- `approved` - Transaction is in this state if it has been approved (or auto-approved if your wallets do not require extra approvals), but not yet signed and broadcast.
- `pending_generation` - Transaction is in this state after a submitted transaction has received all required approvals, while our asynchronous workers are validating and generating transaction data for signing with the wallets.
- `completed` - Transaction is in this state after it has been successfully signed and broadcast.
- `canceled` - Transaction is in this state if its execution has been canceled through the UI.
- `failed` - Transaction is in this state if it its execution failed at any of the steps. In this case the system administrators at Balance are notified and will contact you with next steps.

**`type`**

Optional. Indicates the type of the transaction to query for.
If not specified, returns all transactions.

Possible values are:

- `internal` - Transactions originating from your warm or cold wallets.
- `external` - Incoming transactions originating from wallets outside your custody account.

**`completed_since`**

Optional. If specified, returns *completed transactions only* that were completed after the given timestamp.
Completed transactions are defined as external transactions that are confirmed in a block, or internal transactions that have been successfully broadcast.
If not specified, returns all transactions.

Values are UNIX timestamps (in seconds).

#### Request
Example without filters:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions
```

Example with the `status` filter:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions?status=completed
```

Example with all filters:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions?status=completed\&type=external\&completed_since=1585598824
```

#### Response
Returns an array of transaction JSON structs.

Status: `200`

Example of an **Internal** transaction:
```json
[
    {
        "id": 1,
        "type": "transaction",
        "status": "completed",
        "direction": "outgoing",
        "created_at": "2019-06-18T19:33:15.000Z",
        "requested_by": "api",
        "source": {
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
                "eth":  12.34567890,
                "etc":  12.34567890,
                "xrp":  12.34567890,
                "xlm":  12.34567890,
                "pax":  12.34567890,
                "usdc": 12.34567890
            },
            "funding_addresses": {
                "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
                "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
                "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
                "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
                "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
                "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
                "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
                "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
                "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
                "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
            },
            "extras": {
                "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                    "tag": "xrp tag"
                },
                "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                    "memo": "xlm memo"
                }
            }
        },
        "amounts": {
            "btc":  1.23456789,
            "bch":  1.23456789,
            "ltc":  1.23456789,
            "dash": 1.23456789,
            "eth":  1.23456789,
            "etc":  1.23456789,
            "xrp":  1.23456789,
            "xlm":  1.23456789,
            "pax":  1.23456789,
            "usdc": 1.23456789
        },
        "fees": {
            "btc":  1.23456789,
            "bch":  1.23456789,
            "ltc":  1.23456789,
            "dash": 1.23456789,
            "eth":  1.23456789,
            "etc":  1.23456789,
            "xrp":  1.23456789,
            "xlm":  1.23456789,
            "pax":  1.23456789,
            "usdc": 1.23456789
        },
        "block": {
            "btc":  1234567,
            "bch":  1234567,
            "ltc":  1234567,
            "dash": 1234567,
            "eth":  1234567,
            "etc":  1234567,
            "xrp":  1234567,
            "xlm":  1234567,
            "pax":  1234567,
            "usdc": 1234567
        },
        "cad_rates": {
            "btc":  123.45,
            "bch":  123.45,
            "ltc":  123.45,
            "dash": 123.45,
            "eth":  123.45,
            "etc":  123.45,
            "xrp":  123.45,
            "xlm":  123.45,
            "pax":  123.45,
            "usdc": 123.45
        },
        "notes": "Custom note for this transfer",
        "completed_at": "2019-06-18T19:33:16.000Z",
        "transaction_ids": [
            {
                "currency": "btc",
                "transaction_id": "<BTC_TX_ID>"
            },
            {
                "currency": "bch",
                "transaction_id": "<BCH_TX_ID>"
            },
            {
                "currency": "ltc",
                "transaction_id": "<LTC_TX_ID>"
            },
            {
                "currency": "dash",
                "transaction_id": "<DASH_TX_ID>"
            },
            {
                "currency": "eth",
                "transaction_id": "<ETH_TX_ID>"
            },
            {
                "currency": "etc",
                "transaction_id": "<ETC_TX_ID>"
            },
            {
                "currency": "xrp",
                "transaction_id": "<XRP_TX_ID>"
            },
            {
                "currency": "xlm",
                "transaction_id": "<XLM_TX_ID>"
            },
            {
                "currency": "pax",
                "transaction_id": "<PAX_TX_ID>"
            },
            {
                "currency": "usdc",
                "transaction_id": "<USDC_TX_ID>"
            }
        ],
        "destination": {
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
                "eth":  12.34567890,
                "etc":  12.34567890,
                "xrp":  12.34567890,
                "xlm":  12.34567890,
                "pax":  12.34567890,
                "usdc": 12.34567890
            },
            "funding_addresses": {
                "btc":  "1EWwLtiDvrLKKf6ySDoKqnFYLvcDMr2TvY",
                "bch":  "16CyXcfgoRzBmxC3PzwwQgf8vdovtcGcRi",
                "ltc":  "LbeFePhgCMjnVgNtVCYUpJsPxA7VScd8jE",
                "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
                "eth":  "0x3Dbd0Ec235A15C16F419f990d67B48eb5c04ae09",
                "etc":  "0x4d35262056fb60e00BBc117a6c535f43fe4ED663",
                "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
                "xlm":  "GBBCHCAAFACXZXELWKOLM4QU52FOM6PEBBMJ54O57K6QWFSM6TGEI2QO",
                "pax":  "0x32D7335171B0b57522D810c264a1264c9509b620",
                "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
            },
            "extras": {
                "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                    "tag": "xrp tag"
                },
                "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                    "memo": "xlm memo"
                }
            }
        },
        "is_batched": false
    }
]
```

Example of an **External** transaction:
```json
[
    {
        "hash": "<BCH_TX_ID>",
        "type": "external",
        "direction": "incoming",
        "timestamp": "2019-01-22T01:23:45.000-04:00",
        "block": 123456,
        "source_addresses": [
            "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ"
        ],
        "destination_addresses": [
            "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH",
            "1JFrbvkfPXsJrW6SVBTep125HeJUVmnZkJ"
        ],
        "amount": 123.4567890,
        "fee": 0.12345678,
        "currency": "bch"
    }
]
```

## `GET /api/v1/wallets/:wallet_id/transactions/:transaction_id`

List details for an individual transaction. No parameters accepted.

NOTE: the `transaction_id` argument can be defined as one of two things:

1. the ID of an internal transaction (i.e. an integer)
2. the Hash of an externally originated transaction (i.e. a string)

#### Internal Transaction

##### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions/123
```

##### Response
Returns a transaction JSON struct.

Status: `200`

Data:
```json
{
    "id": 1,
    "type": "transaction",
    "status": "completed",
    "created_at": "2019-06-18T19:33:15.000Z",
    "requested_by": "api",
    "source": {
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
            "eth":  12.34567890,
            "etc":  12.34567890,
            "xrp":  12.34567890,
            "xlm":  12.34567890,
            "pax":  12.34567890,
            "usdc": 12.34567890
        },
        "funding_addresses": {
            "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
            "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
            "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
            "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
            "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
            "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
            "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
            "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
            "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
            "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
        },
        "extras": {
            "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                "tag": "xrp tag"
            },
            "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                "memo": "xlm memo"
            }
        }
    },
    "amounts": {
        "btc":  1.23456789,
        "bch":  1.23456789,
        "ltc":  1.23456789,
        "dash": 1.23456789,
        "eth":  1.23456789,
        "etc":  1.23456789,
        "xrp":  1.23456789,
        "xlm":  1.23456789,
        "pax":  1.23456789,
        "usdc": 1.23456789
    },
    "fees": {
        "btc":  1.23456789,
        "bch":  1.23456789,
        "ltc":  1.23456789,
        "dash": 1.23456789,
        "eth":  1.23456789,
        "etc":  1.23456789,
        "xrp":  1.23456789,
        "xlm":  1.23456789,
        "pax":  1.23456789,
        "usdc": 1.23456789
    },
    "block": {
        "btc":  1234567,
        "bch":  1234567,
        "ltc":  1234567,
        "dash": 1234567,
        "eth":  1234567,
        "etc":  1234567,
        "xrp":  1234567,
        "xlm":  1234567,
        "pax":  1234567,
        "usdc": 1234567
    },
    "cad_rates": {
        "btc":  123.45,
        "bch":  123.45,
        "ltc":  123.45,
        "dash": 123.45,
        "eth":  123.45,
        "etc":  123.45,
        "xrp":  123.45,
        "xlm":  123.45,
        "pax":  123.45,
        "usdc": 123.45
    },
    "notes": "Custom note for this transfer",
    "completed_at": "2019-06-18T19:33:16.000Z",
    "transaction_ids": [
        {
            "currency": "btc",
            "transaction_id": "<BTC_TX_ID>"
        },
        {
            "currency": "bch",
            "transaction_id": "<BCH_TX_ID>"
        },
        {
            "currency": "ltc",
            "transaction_id": "<LTC_TX_ID>"
        },
        {
            "currency": "dash",
            "transaction_id": "<DASH_TX_ID>"
        },
        {
            "currency": "eth",
            "transaction_id": "<ETH_TX_ID>"
        },
        {
            "currency": "etc",
            "transaction_id": "<ETC_TX_ID>"
        },
        {
            "currency": "xrp",
            "transaction_id": "<XRP_TX_ID>"
        },
        {
            "currency": "xlm",
            "transaction_id": "<XLM_TX_ID>"
        },
        {
            "currency": "pax",
            "transaction_id": "<PAX_TX_ID>"
        },
        {
            "currency": "usdc",
            "transaction_id": "<USDC_TX_ID>"
        }
    ],
    "destination": {
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
            "eth":  12.34567890,
            "etc":  12.34567890,
            "xrp":  12.34567890,
            "xlm":  12.34567890,
            "pax":  12.34567890,
            "usdc": 12.34567890
        },
        "funding_addresses": {
            "btc":  "1EWwLtiDvrLKKf6ySDoKqnFYLvcDMr2TvY",
            "bch":  "16CyXcfgoRzBmxC3PzwwQgf8vdovtcGcRi",
            "ltc":  "LbeFePhgCMjnVgNtVCYUpJsPxA7VScd8jE",
            "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
            "eth":  "0x3Dbd0Ec235A15C16F419f990d67B48eb5c04ae09",
            "etc":  "0x4d35262056fb60e00BBc117a6c535f43fe4ED663",
            "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
            "xlm":  "GBBCHCAAFACXZXELWKOLM4QU52FOM6PEBBMJ54O57K6QWFSM6TGEI2QO",
            "pax":  "0x32D7335171B0b57522D810c264a1264c9509b620",
            "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
        },
        "extras": {
            "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                "tag": "xrp tag"
            },
            "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                "memo": "xlm memo"
            }
        }
    },
    "is_batched": false
}
```

#### External Transaction

##### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions/021d6eb3a0a63d857619879a6f8b04124d75725d09d726fddec286829d4c7785
```

##### Response
Returns a transaction JSON struct.

Status: `200`

Data:
```json
{
    "hash": "021d6eb3a0a63d857619879a6f8b04124d75725d09d726fddec286829d4c7785",
    "type": "external",
    "direction": "incoming",
    "timestamp": "2019-01-22T01:23:45.000-04:00",
    "height": 123456,
    "source_addresses": [
        "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ"
    ],
    "destination_addresses": [
        "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH",
        "1JFrbvkfPXsJrW6SVBTep125HeJUVmnZkJ"
    ],
    "amount": 123.4567890,
    "fee": 0.12345678,
    "currency": "bch"
}
```

## `POST /api/v1/wallets/:wallet_id/transactions`

Creates a new transaction with `wallet_id` being the source. `Content-Type` header must be set to `application/json`.

#### Accepted parameters:

Parameters must be serialized into a JSON object with the below fields set as top-level
keys in the object. This JSON string must be passed in as part of request body.

Note that it is only possible to specify one transfer per currency inside a transaction request.

**`destination`** - a struct that defines the destination of the transaction. It is a polymorphic type,
and the following types are accepted: `wallet`, `external`.

Example of `wallet` destination:
```json
{
  "destination": {
    "type": "wallet",
    "id": 2
  }
}
```

Example of `external` destination using an existing external id:
```json
{
  "destination": {
    "type": "external",
    "id": 2
  }
}
```

Example of `external` destination using addresses:
```json
{
    "destination": {
      "type": "external",
      "addresses": {
        "btc": "BTC ADDRESS HERE",
        "bch": "BCH ADDRESS HERE"
      }
    }
}
```

For `xrp`/`xlm` you are also able to specify a `tag`/`memo` field.

Example of `external` destination with XRP tag and XLM memo:
```json
{
    "destination": { // --OR-- new external account destination
      "type": "external",
      "addresses": {
        "xrp": {"address": "XRP ADDRESS HERE", "tag": 123},
        "xlm": {"address": "XLM ADDRESS HERE", "memo": "foo"}
      }
    }
}
```

Note that it is also valid to specify an `xrp`/`xlm` address as a string if you do not want to
specify a tag or memo.

Example of `external` destination without XRP tag or XLM memo:
```json
{
    "destination": { // --OR-- new external account destination
      "type": "external",
      "addresses": {
        "xrp": "XRP ADDRESS HERE",
        "xlm": "XLM ADDRESS HERE"
      }
    }
}
```


**`amounts`** - a struct that specifies the amount (in native currency) that should be transferred.

Example of amounts for `btc` and `eth`:
```json
{
  "amounts": {
    "btc": 0.123,
    "eth": 4.567
  }
}
```

**`fees`** - a dictionary that specifies the fee rate to be used when generating this transaction, where keys correspond to the lowercase currency ticker symbol, and values correspond to fee rates.

See [Fee API docs](../fees/README.md#fee-units) for units of measurement in which fees are specified.

Fee rates can be specified as numbers (integer or float), as well as the following preset values: `"slow"`, `"medium"`, `"fast"`. When preset values are specified they are automatically replaced with corresponding values from the [Fee API](../fees/README.md#get-apiv1transaction_fees).

Example of setting fees for `btc` to a custom value of `15.5 Sat/B` and `eth` to a preset value of `fast`:
```json
{
  "fees": {
    "btc": 15.5,
    "eth": "fast"
  }
}
```

Certain limitations apply to custom fee rate values:
- Fee rates cannot be less than the `"slow"` preset value. This is to ensure transactions don't unnecessarily fail while broadcasting,
- Fee rates cannot be more than 10x the `"fast"` preset value to guard against accidental conversion issues or other misuse.
- Custom fees are not yet supported for Monero (xmr), but you can still use presets.

**`notes`** - a string that signifies your internal notes for this transaction. Optional.

NOTE: this note will **NOT** be included in the blockchain transactions for any currency. This is purely for your own internal tracking.

**`is_batched`** - (`boolean`) a flag that signifies whether a given transaction should be processed as part of a batch. Setting this flag to `true` will put the requested transaction into a batch generation queue after it has been approved (or immediately, if no approvals are required). If the queue reaches 50 transactions, or after 30 minutes (whichever is sooner), all transactions in this batch will be processed as a single on-chain transaction with each requested transaction as a separate output.

Note the following limitations to this option:
- Only applies to transactions attempting a transfer of **BTC, BCH, LTC, DASH**. A 400-error will be returned if any other currency is specified in the request with this flag set to `true`.
- Can only be set for **single-currency transactions**. A 400-error will be returned if the request specifies more than one currency for transfer with this flag set to `true`.
- Only applies to transfers out of **warm wallets**. A 400-error will be returned if the request is attempting transfer out of a cold wallet with this flag set to `true`.
- Only applies to non-sweep transfers. A 400-error will be returned if attempting a sweep with this flag set to `true`.

Note that batched transactions will return a **transaction fee** equal to the total transaction fee for the given on-chain transaction, divided by the number of transactions in the batch.

**`beneficiary_entity`** - specifies a beneficiary entity for regulatory compliance purposes.

This field is only required if Travel Rule enforcement is enabled on your account. Please talk to your Balance Custody account representative about whether it is enabled or disabled.

See [Regulatory Compliance Integration Docs](regulatory/README.md#travel-rule-entity-struct) for a detailed description of the fields that are expected here, as well as examples of transactions submitted with beneficiary entity information.

#### Request

**Example 1**

Example of transaction that transfers 1.23 BTC and 4.56 ETH from warm wallet `1` to warm wallet `2`:
```bash
curl -XPOST \
     -d '{"destination": {"type": "wallet","id": 2}, "amounts": {"btc": 1.23, "eth": 4.56}, "notes": "foo bar"}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions
```

#### Response
Returns a transaction JSON struct. The transaction will be in the `inactive` state.
Please use the `GET /api/v1/wallets/:wallet_id/transactions/:transaction_id` to poll for
status updates. Be conservative with the polling rates.

Status: `200`

Data:
```json
{
    "id": 1,
    "type": "transaction",
    "status": "pending_generation",
    "created_at": "2019-06-18T19:33:15.000Z",
    "requested_by": "api",
    "source": {
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
            "eth":  12.34567890,
            "etc":  12.34567890,
            "xrp":  12.34567890,
            "xlm":  12.34567890,
            "pax":  12.34567890,
            "usdc": 12.34567890
        },
        "funding_addresses": {
            "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
            "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
            "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
            "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
            "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
            "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
            "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
            "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
            "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
            "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
        },
        "extras": {
            "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                "tag": "xrp tag"
            },
            "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                "memo": "xlm memo"
            }
        }
    },
    "amounts": {
        "btc":  1.23,
        "eth":  4.56
    },
    "fees": {
        "btc":  0.123,
        "eth":  0.123
    },
    "cad_rates": {
        "btc":  123.45,
        "eth":  123.45
    },
    "notes": "foo bar",
    "destination": {
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
            "eth":  12.34567890,
            "etc":  12.34567890,
            "xrp":  12.34567890,
            "xlm":  12.34567890,
            "pax":  12.34567890,
            "usdc": 12.34567890
        },
        "funding_addresses": {
            "btc":  "1EWwLtiDvrLKKf6ySDoKqnFYLvcDMr2TvY",
            "bch":  "16CyXcfgoRzBmxC3PzwwQgf8vdovtcGcRi",
            "ltc":  "LbeFePhgCMjnVgNtVCYUpJsPxA7VScd8jE",
            "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
            "eth":  "0x3Dbd0Ec235A15C16F419f990d67B48eb5c04ae09",
            "etc":  "0x4d35262056fb60e00BBc117a6c535f43fe4ED663",
            "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
            "xlm":  "GBBCHCAAFACXZXELWKOLM4QU52FOM6PEBBMJ54O57K6QWFSM6TGEI2QO",
            "pax":  "0x32D7335171B0b57522D810c264a1264c9509b620",
            "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
        },
        "extras": {
            "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                "tag": "xrp tag"
            },
            "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                "memo": "xlm memo"
            }
        }
    }
}
```

**Example 2**

Example of transaction that transfers 1.23 BTC and 4.56 XRP from warm wallet `1` to and external account, with xrp tag:
```bash
curl -XPOST \
     -d '{"destination": {"type": "external","addresses": {"btc": "1EWwLtiDvrLKKf6ySDoKqnFYLvcDMr2TvY", "xrp": {"address": "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5", "tag": 1234}}}, "amounts": {"btc": 1.23, "xrp": 4.56}, "notes": "foo bar"}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions
```

#### Response
Status: `200`

Data:
```json
{
    "id": 1,
    "type": "transaction",
    "status": "pending_generation",
    "created_at": "2019-06-18T19:33:15.000Z",
    "requested_by": "api",
    "source": {
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
            "eth":  12.34567890,
            "etc":  12.34567890,
            "xrp":  12.34567890,
            "xlm":  12.34567890,
            "pax":  12.34567890,
            "usdc": 12.34567890
        },
        "funding_addresses": {
            "btc":  "1JfQeTopCr1SNk9qoF7qsfCcGtmNUvZdbg",
            "bch":  "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ",
            "ltc":  "LY5kxT567jCCH6Au1iJHj36ZZKoT5mkeN3",
            "dash": "Xhwc7iQTKGq28YWjQNPrNCbGV5v6PWj363",
            "eth":  "0x4D4aA364A4afDf8aa9a4f840640a700F44E793f4",
            "etc":  "0x5C2bAB6846b521b2842942Bb2001DBf99ce8133D",
            "xrp":  "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
            "xlm":  "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2",
            "pax":  "0xb3Dc579A90652190C5e3b52479688D510111Be44",
            "usdc": "0x01938ba1c4699fd09b116dd3326906661d34170a"
        },
        "extras": {
            "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5": {
                "tag": "xrp tag"
            },
            "GBIJ2T7YZDOTVFLWIGGK3FAQ2VDZIAOPEMMWKG7YVVNXKY47ZGC5Z6K2": {
                "memo": "xlm memo"
            }
        }
    },
    "amounts": {
        "btc":  1.23,
        "xrp":  4.56
    },
    "cad_rates": {
        "btc":  123.45,
        "xrp":  123.45,
    },
    "notes": "foo bar",
    "destination": {
        "type": "external_account",
        "addresses": {
            "btc": "1EWwLtiDvrLKKf6ySDoKqnFYLvcDMr2TvY",
            "xrp": {
                "address": "rLaMTxt8QkFGNuD67LJsdP5KpMxYqwMen5",
                "tag": "1234"
            }
        }
    }
}
```


# Errors

Errors in this API will have a status code >= 400, and will come with an error message as part
of a json-encoded body. E.g.

```json
{
  "error": "Invalid signature"
}
```

### Status: 400

You will usually see this status code when you've missed a parameter, supplied an invalid value
to one of the parameters, or if your request is somehow semanitcally invalid.

Examples of semantically invalid requests would be a transaction that is attempting to withdrawl an amount greater than the source wallet's balance.

Please refer to the error message for more details, as well as this doc to help debug issues.

### Status: 401

You will usually see this status code when the server has failed to properly authenticate your request.

**`Content-Type header not set`** - you will see this error if your `Content-Type` header is not set. It is a required header.

**`Content-Type header must be application/json`** - you must set the value of the `Content-Type` header to `application/json`. No other value is supported at this time.

**`Date header not set`** - you will see this error if your `Date` header is not set. It is a required header.

**`"Failed to parse Date header"`** - the value of your `Date` header is improperly structured. Refer to this doc: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date

**`Date too far in the future`** - your date is set to more than 15 minutes in the future as compared to server date. Please check your clock.

**`Date is too old`** - your date is set to more than 15 minutes in the past. Check your clock, and re-generate this request.

**`Authorization header not set`** - you have failed to set the `Authorization` header. It is a required header.

**`Failed to parse Authorization header`** - you will see this error if the structure of your `Authorization` header is invalid. Refer to this document for an explanation.

**`Invalid signature`** - you will see this error if your signature is incorrect. Double check that your `Access ID` and `Secret Key` are set correctly. If you see this error, you can assume that the structure of your `Authorization` header is valid, and you have supplied other headers correctly.

### Status: 403

You will usually see this error because you've reached some kind of a transaction limit set by your administrator.

Please refer to the included error message for more details.

### Status 404

You will usually see this error in one of the following reasons:

- You've entered a wrong URL
- Your Access ID could not be found
- A resource you're trying to access does not exist. This could be a wallet ID, destination wallet ID (for transactions), etc.

### Status 500

You will only see this error if an unknown issue has occurred. Our system administrators will be automatically notified of this issue.

The recommended method for handling this issue would be to use a backoff scheme and retry this request
at a later time.

----

# Helper Library

There's a helper module packaged together with this doc in `hmac_auth_helpers.rb`.
You can inspect the Ruby code to help you understand how to implement this scheme in your language of choice.

You can also use it to generate a `curl` request for testing purposes. Here's an example (note that `access_id` and `secret_key` in this example are dummy values):

```
$ irb

irb(main):001:0> require "./hmac_auth_helpers.rb"
=> true

irb(main):002:0> HMACAuthHelpers.print_curl_request(url_base: 'https://your_custom_subdomain.balancecustody.ca', request_uri: '/api/v1/wallets', access_id: '93G9toV9KxgDisd9p', secret_key: '2AxHS3cqqUMrCCKDNGmgCU1ovjAYgzVwRoT3QMVW5j6b')

curl -XGET \
     -H "Content-Type: application/json" \
     -H "Date: Fri, 05 Jul 2019 15:52:17 GMT" \
     -H "Authorization: BalanceAPIAuth 93G9toV9KxgDisd9p:b86e3ffdf6b814f180c1d37bad328b2e241d90db747e98f44fd86a24e02b6fed" \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets
```

You can then copy the above `curl` command and paste it in your shell.
This request will be valid for 15 minutes, provided that you specified correct parameters.
