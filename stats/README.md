# Stats

This API describes some account-level statistics.

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [API URL](#api-url)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
   - [`GET /api/v1/stats`](#get-apiv1stats)

<!-- /MarkdownTOC -->

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

### `GET /api/v1/stats`

List all available account-level statistics.

#### Request
```bash
curl https://your_custom_subdomain.balancecustody.ca/api/v1/stats
```

#### Response
Returns a JSON struct for all available statistics.

Status: `200`

Data:
```json
{
  "total_assets_in_custody": {
    "btc": {
      "offline": 0.78182549,
      "unit": "btc",
      "warm": 367.80627061
    },
    "bch": {
      "offline": 0.78182549,
      "unit": "bch",
      "warm": 367.80627061
    }
 }
}
```
