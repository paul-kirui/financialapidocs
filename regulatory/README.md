# Regulatory Compliance

This page describes the regulatory compliance integration details when processing eligible deposits or withdrawals.

<!-- MarkdownTOC levels="1,2,3" autolink="true" -->

- [Transaction Eligibility](#transaction-eligibility)
  - [Eligible Deposits](#eligible-deposits)
  - [Eligible Withdrawals](#eligible-withdrawals)
- [Processing Deposits](#processing-deposits)
  - [Via the UI](#via-the-ui)
  - [Via the API](#via-the-api)
    - [Originator Entity Struct](#originator-entity-struct)
    - [Third Party Entity Struct](#third-party-entity-struct)
  - [Default Originator Entity](#default-originator-entity)
- [Processing Withdrawals](#processing-withdrawals)
  - [Via the UI](#via-the-ui-1)
  - [Via the API](#via-the-api-1)
    - [Beneficiary Entity Struct](#beneficiary-entity-struct)
  - [Examples](#examples)
    - [Individual](#individual)
    - [Corporate](#corporate)
  - [List of countries accepted by the API](#list-of-countries-accepted-by-the-api)
  - [List of states/provinces accepted by the API](#list-of-statesprovinces-accepted-by-the-api)
  - [List of Identification Type Codes accepted by the API](#list-of-identification-type-codes-accepted-by-the-api)
  - [List of Nature of Relationship Type Codes accepted by the API](#list-of-nature-of-relationship-type-codes-accepted-by-the-api)
  - [List of Device Type Codes accepted by the API](#list-of-device-type-codes-accepted-by-the-api)
  - [Sample API Requests / Responses](#sample-api-requests--responses)
- [Create Wallet with Default Originator Entity](#create-wallet-with-default-originator-entity)
  - [Set Default Originator Entity for Wallet](#set-default-originator-entity-for-wallet)
  - [Read Default Originator Entity for a Wallet](#read-default-originator-entity-for-a-wallet)
  - [Get a List of Eligible Deposits Pending Regulatory Info](#get-a-list-of-eligible-deposits-pending-regulatory-info)
  - [Set an Originator Entity for an Eligible Deposit](#set-an-originator-entity-for-an-eligible-deposit)
  - [Create an Eligible Withdrawal with Beneficiary Entity](#create-an-eligible-withdrawal-with-beneficiary-entity)

<!-- /MarkdownTOC -->

# Transaction Eligibility

## Eligible Deposits

Eligible deposits are defined as transactions that arrive in your wallets that originated from a wallet outside of your Balance Custody instance over $1,000 CAD or part of a sum of deposits within 24hrs totalling over $10,000 CAD as required by FINTRAC. Balance Custody will determine whether deposits require submission of additional information.

## Eligible Withdrawals

Eligible withdrawals are defined as transactions originating from wallets in your Balance Custody instance that are destined for a wallet outside of your Balance Custody account (e.g. to an External Account) in the amount of more than $1,000 CAD.

# Processing Deposits

When receiving eligible deposits, your organization information is automatically set as the Beneficiary Entity, and you may be required to provide information about an Originator Entity and/or a Third Party Entity if applicable.

## Via the UI

You will see Eligible Deposits reflected in the "Alerts" page, where you will be able to submit this information.

## Via the API

You can query for all eligible deposits that require additional information using the following API call: [`GET /api/v1/transactions`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#get-apiv1transactions).

For example:
```bash
curl -XGET your_custom_subdomain.balancecustody.ca/api/v1/transactions?type=external&regulatory_status=pending
```

Look for the `regulatory_status` field in the transaction records returned from the above call. If this field is set to `missing_travel_rule_info`, then you can only submit Originator Entity information. If this field is set to `missing_lvctr_info`, then you will optionally be able to submit Third Party Entity information. Please refer to the entity struct definitions below to see which fields are required for `missing_travel_rule_info` vs `missing_lvctr_info` status.

Please note that the determination of `regulatory_status` is made by Balance, and it is possible for a transaction record to transition from `missing_travel_rule_info` to `missing_lvctr_info`, in which case you will be able to submit additional information.

You can then submit Originator Entity and Third Party Entity information using the following API call: [`PUT /api/v1/transactions/:id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#put-apiv1transactionsid).

For example:
```bash
curl -XPUT your_custom_subdomain.balancecustody.ca/api/v1/transactions/<transaction_id> -d '{"originator_entity": <see Originator Entity Struct definition below>, "third_party_entity": <see Third Party Entity Struct definition below>}'
```

### Originator Entity Struct

**Common Fields:**
- `kind` - string; required; one of: `individual`, `corporate`
- `address1` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`
- `address2` - string; optional; accepted for both `missing_travel_rule_info` and `missing_lvctr_info`
- `city` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`
- `state` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`; must be one of the values in [List of states/provinces accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-statesprovinces-accepted-by-the-api)
- `postcode` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`
- `country` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`; must be one of the values in [List of states/provinces accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-statesprovinces-accepted-by-the-api)
- `client_number` - string; optional; accepted for both `missing_travel_rule_info` and `missing_lvctr_info`
- `id_doc_type_code` - integer; required for `missing_lvctr_info`; signifies an "Identification Document Type Code"; please see [`List of Identification Type Codes accepted by the API`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/regulatory/README.md#list-of-identification-type-codes-accepted-by-the-api)
- `id_doc_type_code_other` - string; optional; accepted for `missing_lvctr_info`; signifies another "Identification Document Type" only if `id_doc_type_code` is selected as `3` for individual or `7` for corporate entity type
- `id_doc_number` - string; required for `missing_lvctr_info`; signifies an Identification Document Number
- `id_doc_jurisdiction_country` - string; required for `missing_lvctr_info`; signifies an Identification Document Jurisdiction Country; must be one of the values in [List of countries accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/regulatory/README.md#list-of-countries-accepted-by-the-api)
- `id_doc_jurisdiction_state` - string; required for `missing_lvctr_info`; signifies an Identification Document Jurisdiction State/Province; must be one of the values in [List of states/provinces accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/regulatory/README.md#list-of-statesprovinces-accepted-by-the-api)
- `device_type_code` - integer; optional; signifies a "Device Type Code"; please see [`List of Device Type Codes accepted by the API`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/regulatory/README.md#list-of-device-type-codes-accepted-by-the-api)
- `device_type_code_other` - string; optional; signifies another "Device Type Code"; required only if `device_type_code` is selected as `4`
- `device_identification_number` - string; optional; signifies Device Identification Number
- `device_ip_address` - string; optional; signifies an IPv4 or IPv6 string
- `requested_at` - string; date in ISO8601 format; optional; signifies date/time of the online session when the transfer occurred

**Fields for `kind=individual`:**
- `firstname` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`
- `lastname` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`
- `occupation` - string; required for `missing_lvctr_info`
- `dob` - string; required for `missing_lvctr_info`; must be specified in `YYYY-MM-DD` format
- `email` - string; optional; accepted for `missing_lvctr_info`

**Fields for `kind=corporate`:**
- `corporate_name` - string; required for both `missing_travel_rule_info` and `missing_lvctr_info`
- `authorized_person_first_name` - string; required for `missing_lvctr_info`; signifies first name of the person authorized to bind the entity or act with respect to the account
- `authorized_person_last_name` - string; required for `missing_lvctr_info`
- `authorized_person_other` - string; optional; accepted for `missing_lvctr_info`; e.g., Sr., Jr., Esq.
- `incorporation_number` - string; optional only if entity is not registered/incorporated; accepted for `missing_lvctr_info`; registration number or similar, if the entity is incorporated/registered
- `registration_country` - string; optional only if entity is not registered/incorporated; accepted for `missing_lvctr_info`; signifies this entity's Registration Country if the entity is incorporated/registered; must be one of the values in [List of countries accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-countries-accepted-by-the-api)
- `registration_state` - string; optional only if entity is not registered/incorporated; accepted for `missing_lvctr_info`; signifies this entity's Registration State/Province if the entity is incorporated/registered; must be one of the values in [List of states/provinces accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-statesprovinces-accepted-by-the-api)
- `nature_of_business` - string; required for `missing_lvctr_info`

### Third Party Entity Struct
**Common Fields:**
- `kind` - one of: `individual`, `corporate`
- `address1` - string
- `address2` - string
- `city` - string
- `state` - string; must be one of the values in [List of states/provinces accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-statesprovinces-accepted-by-the-api)
- `postcode` - string
- `country` - string; must be one of the values in [List of states/provinces accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-statesprovinces-accepted-by-the-api)
- `nature_of_relationship_code` - integer; signifies an "Nature of Relationship Type Code"; please see [`List of Nature of Relationship Type Codes accepted by the API`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-nature-of-relationship-type-codes-accepted-by-the-api)
- `nature_of_relationship_code_other` - string; signifies another "Nature of Relationship Code" if `nature_of_relationship_code` is selected as `9`

**Fields for `kind=individual`:**
- `firstname` - string
- `lastname` - string
- `occupation` - string
- `dob` - must be specified in `YYYY-MM-DD` format

**Fields for `kind=corporate`:**
- `corporate_name` - string
- `nature_of_business` - string

## Default Originator Entity

You are able to use the API to specify a Default Originator Entity for your wallets. Doing so will associate a specified originator with deposits to a given wallet, however you will still be required to confirm this via the API or the UI. Documentation on how to submit a Default Originator Entity can be found here:
[`PUT /api/v1/wallets/:wallet_id`](https://gitlab.com/paradiso-ventures/api-docs/-/blob/master/wallets/README.md#put-apiv1walletsid)


In the UI, if a Default Originator Entity is set for a receiving wallet, you will see all the Originator Entity fields pre-filled with this information when reviewing a transaction via the Alerts page.

In the API, if a default originator entity is set for a receiving wallet, you will see an `originator_entity` field when querying for deposits using the [`GET /api/v1/transactions/:id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#get-apiv1transactionsid) and the [`GET /api/v1/wallets/:wallet_id/transactions/:transaction_id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#get-apiv1walletswallet_idtransactionstransaction_id) calls. The entity will have an `is_confirmed: false` field set. This is done purely for convenience, as you will then still be required to submit an `originator_entity` for that deposit.

# Processing Withdrawals

When sending Eligible Withdrawals, your organization information is automatically set as the Originator Entity, and you are required to provide information about the Beneficiary Entity.

## Via the UI

A Beneficiary Information form will be presented to you to fill in the required fields in the Transaction Builder after the "Build" step if the transaction is eligible.

## Via the API

When submitting a withdrawal request, you will get a 400 error, with the following body: `{"error":"param is missing or the value is empty: beneficiary_entity"}` if the transaction requires a Beneficiary Entity, but does not include it in the request payload. You should handle that error by providing the `beneficiary_entity` field.

For example:
```bash
curl -XPOST your_custom_subdomain.balancecustody.ca/api/v1/wallets/<wallet_id>/transactions -d '{..., beneficiary_entity: <see Beneficiary Entity Struct definition below>}'
```

It is possible to add multiple beneficiaries to the API call by adding a `beneficiary_entities` field to the request body. the beneficiary_entities contains an array of the beneficiary_entity structs.

For example:
```bash
curl -XPOST your_custom_subdomain.balancecustody.ca/api/v1/wallets/<wallet_id>/transactions -d '{..., beneficiary_entities: [<see Beneficiary Entity Struct definition below>}]'
```

Note that a request will result in a 400 error if the request body contains both beneficiary_entity and beneficiary_entities fields simultaniously.

### Beneficiary Entity Struct

**Common Fields:**
- `kind` - required; can be one of: `individual`, `corporate`
- `address1` - required; string
- `address2` - optional; string
- `city` - required; string
- `state` - required; string; can be state, province, etc; must be one of the values in [List of states/provinces accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-statesprovinces-accepted-by-the-api)
- `postcode` - required; string; can be postal code, zip code, etc.
- `country` - required; string; must be one of the values in [List of countries accepted by the API](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#list-of-countries-accepted-by-the-api)
- `client_number` - optional; string; account number or other reference number (if any).

**Fields for `kind=individual`:**
- `firstname` - required for `individual` kind; string
- `lastname` - required for `individual` kind; string

**Fields for `kind=corporate`:**
- `corporate_name` - required for `corporate` kind; string

## Examples

### Individual
```json
{
  "kind": "individual",
  "firstname": "John",
  "lastname": "Doe",
  "address1": "325 Front St W",
  "address2": "4th floor (OneEleven)",
  "city": "Toronto",
  "state": "Ontario",
  "postcode": "M5V 2Y1",
  "country": "Canada",
  "client_number": "1337"
}
```

### Corporate
```json
{
  "kind": "corporate",
  "corporate_name": "Acme Inc.",
  "address1": "325 Front St W",
  "address2": "4th floor (OneEleven)",
  "city": "Toronto",
  "state": "Ontario",
  "postcode": "M5V 2Y1",
  "country": "Canada",
  "client_number": "1337"
}
```

## List of countries accepted by the API
```json
["Canada", "United States", "Mexico", "Afghanistan", "Åland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia (Plurinational State of)", "Bonaire (Sint Eustatius and Saba)", "Bosnia and Herzegovina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros (the)", "Congo (the Democratic Republic of the)", "Congo (the)", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Curaçao", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France, Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey, C.I.", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and McDonald Islands", "Holy See (the)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey, C.I.", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea (Dem. People's Rep. of)", "Korea (the Republic of)", "Kuwait", "Kyrgystan", "Lao People's Dem. Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia (Former Yugoslav Republic)", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Micronesia (Federated States of)", "Moldova (the Republic of)", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Palestine (State of)", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion Island", "Romania", "Russian Federation (the)", "Rwanda", "Saint Barthélemy", "Saint Helena", "Saint Kitts and Nevis", "Saint Lucia", "Saint Martin (French part)", "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Serbia and Montenegro", "Seychelles", "Sierra Leone", "Singapore", "Sint Maarten (Dutch part)", "Slovakia (Slovak Republic)", "Slovenia", "So. Georgia and So. Sandwich Islands", "Solomon Islands", "Somalia", "South Africa", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan", "Tajikistan", "Tanzania (United Republic of)", "Thailand", "Timor-Leste", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands (the)", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates (the)", "United Kingdom (the)", "United States Minor Outlying Is.'s", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela (Bolivarian Republic of)", "Viet Nam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]
```

## List of states/provinces accepted by the API

Accepts any non-empty string, except when the country is set to Canada, United States, or Mexico. In those cases, the values below are accepted:
```json
{
    "Canada":[
        "Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Nova Scotia","Northwest Territories","Nunavut","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"
    ],
    "United States":[
        "Alaska","Alabama","Arkansas","Arizona","California","Colorado","Connecticut","District of Columbia","Delaware","Florida","Georgia","Hawaii","Iowa","Idaho","Illinois","Indiana","Kansas","Kentucky","Louisiana","Massachusetts","Maryland","Maine","Michigan","Minnesota","Missouri","Mississippi","Montana","North Carolina","North Dakota","Nebraska","New Hampshire","New Jersey","New Mexico","Nevada","New York","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Virginia","Vermont","Washington","Wisconsin","West Virginia","Wyoming"
    ],
    "Mexico":[
        "Aguascalientas","Baja, Calif. (North)","Baja, Calif. (South)","Campeche","Chihuahua","Chiapas","Colima","Coahuila de Zaragoza","Distrito","Durango","Guerreo","Guanajuato","Hidalgo","Jalisco","Michoacan de Ocampo","Morelos","Mexico (State)","Nayarit","Nuevo Leon","Oaxaca","Puebla","Quintana Roo","Queretaro de Arteaga","Sinaloa","San Luis Potosi","Sonora","Tamaulipas","Tabasco","Tlaxcala","Veracruz-Llave","Yucatan","Zacatecas"
    ]
}
```

## List of Identification Type Codes accepted by the API

This is an integer type.

**For `kind=individual` entities the accepted values are:**
- `1` - Birth certificate
- `2` - Passport
- `3` - Other
- `4` - Driver's licence
- `5` - Provincial health card
- `14` - Citizenship card
- `15` - Certificate of Indian Status
- `32` - Permanent resident card
- `33` - Record of landing
- `34` - Credit file
- `35` - Government issued identification
- `36` - Insurance documents
- `37` - Provincial or territorial identity card
- `38` - Record of employment
- `39` - Travel visa
- `40` - Utility statement

**For `kind=corporate` entities the accepted values are:**
- `1` - Articles of association
- `2` - Certificate of corporate status
- `3` - Certificate of incorporation
- `4` - Letter/Notice of assessment
- `5` - Partnership agreement
- `6` - Annual report
- `7` - Other

## List of Nature of Relationship Type Codes accepted by the API

This is an integer type.

- `1` - Accountant
- `2` - Agent
- `3` - Borrower
- `4` - Broker
- `5` - Customer
- `6` - Employee
- `7` - Friend
- `8` - Relative
- `9` - Other
- `10` - Legal counsel
- `11` - Employer
- `12` - Joint/Secondary owner
- `13` - Power of attorney

## List of Device Type Codes accepted by the API

This is an integer type.

- `1` - Computer/Laptop
- `2` - Mobile phone
- `3` - Tablet
- `4` - Other

## Sample API Requests / Responses

Keep in mind that headers (including authentication headers) are not included in these examples to keep them brief.

# Create Wallet with Default Originator Entity

(Full API Call Documentation: [`POST /api/v1/wallets`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#post-apiv1wallets))

***Request:***
```bash
curl -XPOST \
     -d '{"name": "foo", "description": "bar", "custom_id": "ABCDefgh123", "default_originator_entity": {"kind":"individual","firstname":"John","lastname":"Doe","address1":"325 Front St W","address2":"4th floor (OneEleven)","city":"Toronto","state":"Ontario","postcode":"M5V 2Y1","country":"Canada","client_number":"1337"}}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets
```

***Response:***
```json
{
    "id": 1,
    "type": "wallet",
    "kind": "warm",
    // ...
    "default_originator_entity": {
      "kind": "individual",
      "firstname": "John",
      "lastname": "Doe",
      "address1": "325 Front St W",
      "address2": "4th floor (OneEleven)",
      "city": "Toronto",
      "state": "Ontario",
      "postcode": "M5V 2Y1",
      "country": "Canada",
      "client_number": "1337"
    }
}
```

## Set Default Originator Entity for Wallet

(Full API Call Documentation: [`PUT /api/v1/wallets/:id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#put-apiv1walletsid))

Note that if you attempt to set a default originator entity for a wallet that already has one set - the API will return a 400 error with the following body: `{"error": "Default originator already set for this wallet."}`.

***Request:***
```bash
curl -XPUT \
     -d '{"default_originator_entity": {"kind":"individual","firstname":"John","lastname":"Doe","address1":"325 Front St W","address2":"4th floor (OneEleven)","city":"Toronto","state":"Ontario","postcode":"M5V 2Y1","country":"Canada","client_number":"1337"}}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/2
```

***Response:***

Same as [Create Wallet with Default Originator Entity](#create-wallet-with-default-originator-entity)

## Read Default Originator Entity for a Wallet

(Full API Call Documentation: [`GET /api/v1/wallets/:id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#get-apiv1walletsid))

Note that `default_originator_entity` field is only returned for the [`GET /api/v1/wallets/:id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#get-apiv1walletsid) API call, and is NOT returned for the [`GET /api/v1/wallets`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#get-apiv1wallets) API call.

***Request:***
```bash
curl -XGET https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1
```

***Response:***

Same as [Create Wallet with Default Originator Entity](#create-wallet-with-default-originator-entity)

## Get a List of Eligible Deposits Pending Regulatory Info

(Full API Call Documentation: [`GET /api/v1/transactions`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#get-apiv1transactions))

***Request:***
```bash
curl -XGET your_custom_subdomain.balancecustody.ca/api/v1/transactions?type=external&regulatory_status=pending
```

***Response:***

Same as [`GET /api/v1/transactions`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#get-apiv1transactions).

## Set an Originator Entity for an Eligible Deposit

(Full API Call Documentation: [`PUT /api/v1/transactions/:id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/REAMDE.md#put-apiv1transactionsid))

***Request:***
```json
curl -XPUT your_custom_subdomain.balancecustody.ca/api/v1/transactions/1 -d '{"originator_entity": {"kind":"individual","firstname":"John","lastname":"Doe","address1":"325 Front St W","address2":"4th floor (OneEleven)","city":"Toronto","state":"Ontario","postcode":"M5V 2Y1","country":"Canada","client_number":"1337"}}'
```

***Response:***

Same as [`GET /api/v1/transactions/:id`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/transactions/README.md#get-apiv1transactionsid)

## Create an Eligible Withdrawal with Beneficiary Entity

(Full API Call Documentation: [`POST /api/v1/wallets/:wallet_id/transactions`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#post-apiv1walletswallet_idtransactions))

***Request:***
```bash
curl -XPOST \
     -d '{"destination": {"type": "wallet","id": 2}, "amounts": {"btc": 1.23, "eth": 4.56}, "notes": "foo bar", "originator_entity": {"kind":"individual","firstname":"John","lastname":"Doe","address1":"325 Front St W","address2":"4th floor (OneEleven)","city":"Toronto","state":"Ontario","postcode":"M5V 2Y1","country":"Canada","client_number":"1337"}}' \
     https://your_custom_subdomain.balancecustody.ca/api/v1/wallets/1/transactions
```

***Response:***

Same as [`POST /api/v1/wallets/:wallet_id/transactions`](https://gitlab.com/paradiso-ventures/api-docs/-/tree/master/wallets/README.md#post-apiv1walletswallet_idtransactions)
