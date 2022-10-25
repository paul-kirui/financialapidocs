# External accounts

This document describes the API endpoints that are available to the clients of Balance
who have been whitelisted for programmatic access to their External accounts.

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [Supported Currencies](#supported-currencies)
- [API URL](#api-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
  - [`GET /api/v1/external_accounts`](#get-apiv1external_accounts)
  - [`GET /api/v1/external_accounts/:id`](#get-apiv1external_accountsid)
- [Errors](#errors)

<!-- /MarkdownTOC -->


# Supported Currencies

Currently the API supports 10 currencies. Below is a list of these currencies,
the ticker symbol that must be used when interacting with this API, as well as the
units in which the fee rates will be returned:

- **Bitcoin** (`btc`) - `Satoshi / byte`
- **Bitcoin Cash** (`bch`) - `Satoshi / byte`
- **Litecoin** (`ltc`) - `Litoshi / byte`
- **Dash** (`dash`) - `Duff / byte`
- **Ethereum** (`eth`) - `Gwei`
- **Ethereum Classic** (`etc`) - `Gwei`
- **Ripple** (`xrp`) - `XRP / tx`
- **Stellar Lumens** (`xlm`) - `XLM / op`
- **Paxos** (`pax`) - `Gwei`
- **USD Coin** (`usdc`) - `Gwei`
- **Paxos Gold** (`paxg`) - `Gwei`
- **Stasis EURS** (`eurs`) - `Gwei`
- **BR.Mint** (`brlm`) - `Gwei`
- **Canadian Natural Dollar** (`cdag`) - `Gwei`
- **Monero** (`xmr`) - `piconero`
- **QCAD** (`qcad`) - `Gwei`

Currently QCAD is in preview, access to `QCAD` must be requested from your point of contact at Balance.

# API URL

You will receive your integration URL from your point of contact
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

These `curl` examples work out of the box as the API does not require any headers to be set.

### `GET /api/v1/external_accounts`

List all approved external accounts. No parameters accepted.

#### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/external_accounts
```

#### Response
Returns all external accounts with their affiliated fees JSON struct.

Status: `200`

Data:
```json
[
   {
      "id": 1,
      "type": "wallet",
      "kind": "external",
      "custom_id": "Custom ID",
      "name": "External account name",
      "description": "External account description",
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
]
```

### `GET /api/v1/external_accounts/:id`

Show details for a single external account. No parameters accepted.

#### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/external_accounts/1
```

#### Response
Returns a single external account.

Status: `200`

Data:
```json
{
   "id": 1,
   "type": "wallet",
   "kind": "external",
   "custom_id": "Custom ID",
   "name": "External account name",
   "description": "External account description",
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

# Errors

Errors in this API are the same as the ones specified in the [wallet API docs](../wallets/README.md#errors).

