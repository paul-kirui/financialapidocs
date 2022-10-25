# Transactions

This document describes the API endpoints that are available to the clients of Balance
who have been whitelisted for programmatic access to their Warm Wallets.

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [Supported Currencies](#supported-currencies)
- [API URL](#api-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
    - [`GET /api/v1/transactions`](#get-apiv1transactions)
    - [`GET /api/v1/transactions/:id`](#get-apiv1transactionsid)
    - [`PUT /api/v1/transactions/:id`](#put-apiv1transactionsid)
- [Errors](#errors)

<!-- /MarkdownTOC -->


# Supported Currencies

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

Response data is for example purposes only and does not represent real crypto accounts.

## `GET /api/v1/transactions`

List all transactions. Includes internal and external transactions. Pagination TBD. No parameters accepted.

**Internal** transactions are defined as transactions between your Cold or Warm wallets managed by Balance Custody.

**External** transactions are defined as transactions that are originated externally, destined for your Cold or Warm wallets managed by Balance Custody.

#### Accepted parameters:

Accepts the following GET parameters as part of the query string:

**`status`**

Optional. Indicates the status of transactions to query for.
If not specified, returns all transactions.

Possible values are:

- `pending_approval` - Transaction is in this state if your warm wallets are set up to require extra approvals before being signed and broadcast by the warm wallets.
- `approved` - Transaction is in this state if it has been approved (or auto-approved if your warm wallets do not require extra approvals), but not yet signed and broadcast.
- `pending_generation` - Transaction is in this state after a submitted transaction has received all required approvals, while our asynchronous workers are validating and generating transaction data for signing with the wallets.
- `completed` - Transaction is in this state after it has been successfully signed and broadcast.
- `canceled` - Transaction is in this state if its execution has been canceled through the UI.
- `failed` - Transaction is in this state if it its execution failed at any of the steps. In this case the system administrators at Balance are notified and will contact you with next steps.


**`regulatory_status`**

Optional. Indicates the regulatory status of transactions to query for. This will be used when querying for deposits that require Travel Rule information to be submitted.

Possible values are:
- `pending` - indicates transactions that have missing Travel Rule information that must be provided.
- `completed` - indicates transactions that do not have missing Travel Rule information.

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

**`created_since`**

Optional. If specified, returns transactions that were created after the given timestamp. The `created_since` filter refers to the timestamp when a transaction was created or imported in the Balance database, whereas the `completed_since` filter refers to blockchain broadcast or confirmation time of a given transaction.

The `created_since` filter can be useful for scanning for transactions that were backfilled or imported long after they were confirmed in a block.

Values are UNIX timestamps (in seconds).

#### Request
Example without filters:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transactions
```

Example with the `status` filter:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transactions?status=completed
```

Example with completed_since:
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transactions?status=completed\&type=external\&completed_since=1585598824
```

Example with created_since:
(NOTE: this is the preferred method of polling for incoming external transactions)
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transactions?status=completed\&type=external\&created_since=1585598824
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
            "usdc": 1.23456789,
            "aion": 1.23456789
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
        "fee_units": {
            "btc":  "sat/b",
            "bch":  "sat/b",
            "ltc":  "sat/b",
            "dash": "sat/b",
            "eth":  "gwei",
            "etc":  "gwei",
            "xrp":  "xrp/op",
            "xlm":  "xlm/op",
            "pax":  "gwei",
            "usdc": "gwei"
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
            "usdc": 123.45,
            "aion": 1.23456789
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
            },
            {
                "currency": "aion",
                "transaction_id": "<AION_TX_ID>"
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
                "usdc": 12.34567890,
                "aion": 12.34567890
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
    }
]
```

Example of an **Incoming External** transaction:
```json
[
    {
        "id": 1,
        "hash": "<BCH_TX_ID>",
        "type": "external",
        "direction": "incoming",
        "timestamp": "2019-01-22T01:23:45.000-04:00",
        "block": 123456,
        "source_addresses": [
            "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ"
        ],
        "destination_addresses": [
            "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH"
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
                "btc":  "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH",
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
        "amount": 123.4567890,
        "fee": 0.12345678,
        "fee_unit": "sat/b",
        "currency": "bch"
    }
]
```

Example of an **Outgoing External** transaction:
```json
[
    {
    "id": 1,
    "type": "transaction",
    "status": "completed",
    "created_at": "2019-11-18T20:26:51.000Z",
    "requested_by": "api",
    "source": {
        "id": 1,
        "type": "wallet",
        "kind": "warm",
        "custom_id": "Source Wallet Custom Id",
        "name": "Source Wallet Name",
        "description": "Source Wallet Description",
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
            "btc":  "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH",
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
    "fee_units": {
        "btc":  "sat/b",
        "bch":  "sat/b",
        "ltc":  "sat/b",
        "dash": "sat/b",
        "eth":  "gwei",
        "etc":  "gwei",
        "xrp":  "xrp/op",
        "xlm":  "xlm/op",
        "pax":  "gwei",
        "usdc": "gwei"
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
    "notes": "Transaction Notes",
    "completed_at": "2019-11-18T20:26:51.000Z",
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
        "id": 1,
        "name": "Destination Wallet Name",
        "custom_id": "Destination Wallet Custom Id",
        "description": "Destination Wallet Description",
        "type": "external_account",
        "addresses": {
            "bch": "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH"
        }
    },
    "fees": {
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
    "fee_units": {
        "btc":  "sat/b",
        "bch":  "sat/b",
        "ltc":  "sat/b",
        "dash": "sat/b",
        "eth":  "gwei",
        "etc":  "gwei",
        "xrp":  "xrp/op",
        "xlm":  "xlm/op",
        "pax":  "gwei",
        "usdc": "gwei"
    }
  }
]
```

## `GET /api/v1/transactions/:id`

List details for an individual transaction. No parameters accepted.

NOTE: the `id` argument can be defined as one of two things:

1. the ID of an internal transaction (i.e. an integer)
2. the Hash of an externally originated transaction (i.e. a string)

#### Internal Transaction

##### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transactions/1
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
    "fee_units": {
        "btc":  "sat/b",
        "bch":  "sat/b",
        "ltc":  "sat/b",
        "dash": "sat/b",
        "eth":  "gwei",
        "etc":  "gwei",
        "xrp":  "xrp/op",
        "xlm":  "xlm/op",
        "pax":  "gwei",
        "usdc": "gwei"
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
    }
}
```

#### External Transaction

##### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transactions/021d6eb3a0a63d857619879a6f8b04124d75725d09d726fddec286829d4c7785
```

##### Response
Returns a transaction JSON struct.

Status: `200`

Example of an **Incoming External** transaction:

Data:
```json
{
    "id": 1,
    "hash": "021d6eb3a0a63d857619879a6f8b04124d75725d09d726fddec286829d4c7785",
    "type": "external",
    "direction": "incoming",
    "timestamp": "2019-01-22T01:23:45.000-04:00",
    "height": 123456,
    "source_addresses": [
        "1H1NtR2TxvpxVffhh13xKeX2vxENvRJcBZ"
    ],
    "destination_addresses": [
        "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH"
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
            "btc":  "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH",
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
    "amount": 123.4567890,
    "fee": 0.12345678,
    "fee_unit": "sat/b",
    "currency": "bch",
    "regulatory_status": "<One of: not_required, missing_travel_rule_info, completed>",
    "originator_entity": "<see TravelRuleEntity struct in regulatory/README.md>",
    "beneficiary_entity": "<see BeneficiaryEntity struct in regulatory/README.md>", # DEPRECATED
    "beneficiary_entities": "<array of BeneficiaryEntity structs, see regulatory/README.md>",
    "third_party_entity": "<see TravelRuleEntity struct in regulatory/README.md>"
}
```

Note: the `beneficiary_entity` field has been deprecated. It will only return the most recently assigned beneficiary entity for a transaction. Instead use the field `beneficiary_entities` which is an array containing all beneficiary entities assigned to the transaction.

Example of an **Outgoing External** transaction:

Data:
```json
{
    "id": 1,
    "type": "transaction",
    "status": "completed",
    "created_at": "2019-11-18T20:26:51.000Z",
    "requested_by": "api",
    "source": {
        "id": 1,
        "type": "wallet",
        "kind": "warm",
        "custom_id": "Source Wallet Custom Id",
        "name": "Source Wallet Name",
        "description": "Source Wallet Description",
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
            "btc":  "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH",
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
    "fee_units":{
        "btc":  "sat/b",
        "bch":  "sat/b",
        "ltc":  "sat/b",
        "dash": "sat/b",
        "eth":  "gwei",
        "etc":  "gwei",
        "xrp":  "xrp/op",
        "xlm":  "xlm/op",
        "pax":  "gwei",
        "usdc": "gwei"
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
    "notes": "Transaction Notes",
    "completed_at": "2019-11-18T20:26:51.000Z",
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
            "currency": "USDC",
            "transaction_id": "<USDC_TX_ID>"
        }
    ],
    "destination": {
        "id": 1,
        "name": "Destination Wallet Name",
        "custom_id": "Destination Wallet Custom Id",
        "description": "Destination Wallet Description",
        "type": "external_account",
        "addresses": {
            "bch": "13UbCqnsjBd9Z9KAN4MosoqRhx9BouufKH"
        }
    },
    "fees": {
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
    "fee_units": {
        "btc":  "sat/b",
        "bch":  "sat/b",
        "ltc":  "sat/b",
        "dash": "sat/b",
        "eth":  "gwei",
        "etc":  "gwei",
        "xrp":  "xrp/op",
        "xlm":  "xlm/op",
        "pax":  "gwei",
        "usdc": "gwei"
    }
}
```

## `PUT /api/v1/transactions/:id`

Update details of a transaction with a given ID.

Currently, you are only able to update regulatory compliance fields for external deposits.

NOTE: the `id` argument can be defined as one of two things:

1. the ID of an internal transaction (i.e. an integer)
2. the Hash of an externally originated transaction (i.e. a string)

#### Accepted parameters:
- `is_originator_declared` - a boolean; if provided, and set to `false` - then your organization information is used as an Originator Entity, and no further parameters for Originator Entity are required.
- `originator_entity` - an object of type [Originator Entity](regulatory/README.md#originator-entity-struct). Signifies the originator of the deposit. Only persisted if the destination wallet does not already have a default originator entity set, and if the deposit does not already have an originator entity set. You should aim to provide all available information. The Balance Custody platform will make a determinition about whether the information you provided is sufficient for the current transaction, and return a response code 200 if it is. If the information is insufficient, a 400 response code will be returned, along with an error message describing the missing field.
- `third_party_entity` - an object of type [Third Party Entity](regulatory/README.md#third-party-entity-struct). Signifies the third party that instructed this deposit to be made. Only persisted if the deposit does not already have a third party entity set. You should aim to provide all available information. The Balance Custody platform will make a determinition about whether the information you provided is sufficient for the current transaction, and return a response code 200 if it is. If the information is insufficient, a 400 response code will be returned, along with an error message describing the missing field.
- `is_client_instructed` - a boolean; default is 'false'; should be set to 'true' if one of your clients instructed this deposit for the provision of goods and services on your platform

#### Request
```bash
curl -XPUT \
     -d '{"originator_entity":{"firstname":"John","lastname":"Smith","address1":"1 King Road","address2":"Unit 30","city":"Toronto","state":"Ontario","postcode":"1A2 3B4","country":"Canada","account_id":"123-123123"}}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/transactions/1
```

#### Response
Same response as [`GET /api/v1/transactions/:id`](#get-apiv1transactionsid)

# Errors

Errors in this API are the same as the ones specified in the [wallet API docs](../wallets/README.md#errors).
