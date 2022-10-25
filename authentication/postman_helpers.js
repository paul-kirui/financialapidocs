// this snippet can be pasted into a Postman's (https://www.postman.com/) pre-request script as a
// way to perform authenticated requests against Balance Custody API
var moment = require("moment")

var accessId = "<ACCESS_ID>" // paste the access ID you receive from Balance Custody
var secretKey = "<SECRET_KEY>" // paste the secret key you receive from Balance Custody

var method = pm.request.method.toUpperCase()
var contentType = "application/json"
var requestUri = pm.request.url.getPath()
var now = new Date()
var timestamp = moment(now.toUTCString()).valueOf() / 1000
var dataHash = ''
if (pm.request.body && pm.request.body.toString() && pm.request.body.toString().length > 0) {
    dataHash = CryptoJS.enc.Hex.stringify(CryptoJS.SHA256(pm.request.body.toString()))
}

var canonicalString = method + "," + contentType + "," + requestUri + "," + dataHash + "," + timestamp.toString()

var signature = CryptoJS.enc.Hex.stringify(CryptoJS.HmacSHA256(canonicalString, secretKey))

var authorizationHeader = "BalanceAPIAuth " + accessId + ":" + signature

pm.environment.set("contentTypeHeader", contentType)           // must also set the "Content-Type" header to {{contentTypeHeader}}
pm.environment.set("authorizationHeader", authorizationHeader) // must also set the Authorization header to {{authorizationHeader}}
pm.environment.set("dateHeader", now.toUTCString())            // must also set the Date header to {{dateHeader}}
