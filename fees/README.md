# Transaction fees

This API describes standard transaction fee levels.

The fees are approximate, and may change slightly at the time of transaction generation.

We cannot guarantee that any given fee will result in a transaction being included in a block.

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [Supported Currencies](#supported-currencies)
- [Fee Units](#fee-units)
- [API URL](#api-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
   - [`GET /api/v1/transaction_fees`](#get-apiv1transaction_fees)
   - [`GET /api/v1/transaction_fees/:currency`](#get-apiv1transaction_feescurrency)
- [Errors](#errors)

<!-- /MarkdownTOC -->


# Supported Currencies

See [Wallet API docs](wallets/README.md#supported-currencies).

# Fee Units

Fee units returned in this API correspond to the following units:

- **BTC**: Sat/B
- **BCH**: Sat/B
- **LTC**: Sat/B
- **DASH**: Sat/B
- **ETH**: Gwei
- **ETC**: Gwei
- **FIL**: nanoFIL
- **PAX**: Gwei
- **USDC**: Gwei
- **USDT**: Gwei
- **QCAD**: Gwei
- **EURS**: Gwei
- **BRLM**: Gwei
- **PAXG**: Gwei
- **CDAG**: Gwei
- **XRP**: XRP/op
- **XLM**: XLM/op
- **XMR**: Atomic Units/B (piconero)
- **AION**: Amp
- **AXIA**: Amp
- **AXL**: uAXL
- **VCAD**: Gwei

# API URL

You will receive your integration URL from your point of contact
at Balance, and will look like:
```
YOUR_CUSTOM_SUBDOMAIN.balancecustody.ca
```

----

# Authentication

The data exposed through this API is not sensitive and therefore any call to the endpoints is unauthenticated.

----

# API Endpoints

These `curl` examples work out of the box as the API does not require any headers to be set.

### `GET /api/v1/transaction_fees`

List all available currencies with their affiliated fee setting values. No parameters accepted.

#### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transaction_fees
```

#### Response
Returns a JSON struct for all currencies with their affiliated fee setting values.

Status: `200`

Data:
```json
{
   "btc":{
      "slow":{
         "fee_rate": 1.0,
         "blocks": 25,
         "unit": "sat/b"
      },
      "medium":{
         "fee_rate": 19.137,
         "blocks": 2,
         "unit": "sat/b"
      },
      "fast":{
         "fee_rate": 28.7055,
         "blocks": 1,
         "unit": "sat/b"
      }
   },
   "bch":{
      "slow":{
         "fee_rate": 1.0,
         "blocks": 1,
         "unit": "sat/b"
      },
      "medium":{
         "fee_rate": 3.0,
         "blocks": 1,
         "unit": "sat/b"
      },
      "fast":{
         "fee_rate": 5.0,
         "blocks": 1,
         "unit": "sat/b"
      }
   },
   "ltc":{
      "slow":{
         "fee_rate": 1.0,
         "blocks": 1,
         "unit": "sat/b"
      },
      "medium":{
         "fee_rate": 1.5645,
         "blocks": 1,
         "unit": "sat/b"
      },
      "fast":{
         "fee_rate": 5.215,
         "blocks": 1,
         "unit": "sat/b"
      }
   },
   "dash":{
      "slow":{
         "fee_rate": 1.2,
         "blocks": 25,
         "unit": "sat/b"
      },
      "medium":{
         "fee_rate": 4.43,
         "blocks": 2,
         "unit": "sat/b"
      },
      "fast":{
         "fee_rate": 6.645,
         "blocks": 1,
         "unit": "sat/b"
      }
   },
   "eth":{
      "slow":{
         "fee_rate": 0.5,
         "blocks": 1,
         "unit": "gwei"
      },
      "medium":{
         "fee_rate": 1.0,
         "blocks": 1,
         "unit": "gwei"
      },
      "fast":{
         "fee_rate": 3.0,
         "blocks": 1,
         "unit": "gwei"
      }
   },
   "etc":{
      "slow":{
         "fee_rate": 10.0,
         "blocks": 1,
         "unit": "gwei"
      },
      "medium":{
         "fee_rate": 20.0,
         "blocks": 1,
         "unit": "gwei"
      },
      "fast":{
         "fee_rate": 60.0,
         "blocks":1,
         "unit": "gwei"
      }
   },
   "fil":{
      "slow": {
         "fee_rate": 7.5606e-05,
         "blocks": 1,
         "unit": "nanoFil"
      },
      "medium": {
         "fee_rate": 0.00012601,
         "blocks": 1,
         "unit": "nanoFil"
      },
      "fast": {
         "fee_rate": 0.00025202,
         "blocks": 1,
         "unit": "nanoFil"
      }
   },
   "xrp":{
      "slow":{
         "fee_rate": 1.0e-05,
         "blocks": 1,
         "unit": "xrp/op"
      },
      "medium":{
         "fee_rate": 0.005,
         "blocks": 1,
         "unit": "xrp/op"
      },
      "fast":{
         "fee_rate": 0.01,
         "blocks": 1,
         "unit": "xrp/op"
      }
   },
   "xlm":{
      "slow":{
         "fee_rate": 1.0e-05,
         "blocks": 1,
         "unit": "xlm/op"
      },
      "medium":{
         "fee_rate": 1.0e-05,
         "blocks": 1,
         "unit": "xlm/op"
      },
      "fast":{
         "fee_rate": 0.0008,
         "blocks": 1,
         "unit": "xlm/op"
      }
   },
   "pax":{
      "slow":{
         "fee_rate": 0.5,
         "blocks": 1,
         "unit": "Gwei"
      },
      "medium":{
         "fee_rate": 1.0,
         "blocks": 1,
         "unit": "Gwei"
      },
      "fast":{
         "fee_rate": 3.0,
         "blocks": 1,
         "unit": "Gwei"
      }
   },
   "usdc":{
      "slow":{
         "fee_rate": 0.5,
         "blocks": 1,
         "unit": "gwei"
      },
      "medium":{
         "fee_rate": 1.0,
         "blocks": 1,
         "unit": "gwei"
      },
      "fast":{
         "fee_rate": 3.0,
         "blocks": 1,
         "unit": "gwei"
      }
   },
   "qcad":{
      "slow":{
         "fee_rate": 10.0,
         "blocks": 1,
         "unit": "gwei"
      },
      "medium":{
         "fee_rate": 20.0,
         "blocks": 1,
         "unit": "gwei"
      },
      "fast":{
         "fee_rate": 60.0,
         "blocks": 1,
         "unit": "gwei"
      }
   },
   "vcad":{
      "slow":{
         "fee_rate": 0.5,
         "blocks": 1,
         "unit": "gwei"
      },
      "medium":{
         "fee_rate": 1.0,
         "blocks": 1,
         "unit": "gwei"
      },
      "fast":{
         "fee_rate": 3.0,
         "blocks": 1,
         "unit": "gwei"
      }
   },
   "aion":{
      "slow":{
         "fee_rate": 10.0,
         "blocks": 1,
         "unit": "amp"
      },
      "medium":{
         "fee_rate": 15.0,
         "blocks": 1,
         "unit": "amp"
      },
      "fast":{
         "fee_rate": 30.0,
         "blocks": 1,
         "unit": "amp"
      }
   },
   "axl":{
      "slow":{
         "fee_rate": 10.0,
         "blocks": 1,
         "unit": "uaxl"
      },
      "medium":{
         "fee_rate": 15.0,
         "blocks": 1,
         "unit": "uaxl"
      },
      "fast":{
         "fee_rate": 30.0,
         "blocks":1,
         "unit": "uaxl"
      }
   }
}
```

### `GET /api/v1/transaction_fees/:currency`

Show details for a single currency. No parameters accepted.

#### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/transaction_fees/btc
```

#### Response
Returns a single currency's transaction fees JSON struct.

Status: `200`

Data:
```json
{
   "slow":{
      "fee_rate": 1.0,
      "blocks": 25,
      "unit": "<currency_fee_unit>"
   },
   "medium":{
      "fee_rate": 19.137,
      "blocks": 2,
      "unit": "<currency_fee_unit>"
   },
   "fast":{
      "fee_rate": 28.7055,
      "blocks": 1,
      "unit": "<currency_fee_unit>"
   }
}
```

# Errors

Errors in this API are the same as the ones specified in the [wallet API docs](../wallets/README.md#errors).

