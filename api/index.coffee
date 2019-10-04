require('dotenv').config()
fs = require 'fs'
soapRequest = require 'easy-soap-request'
util = require 'util'
{ parseString } = require 'xml2js'
app = require('express')()

# dummyXmlRS = fs.readFileSync('../Samples_NDC/Booking\ path\ with\ \ EPU\ Seat/AirShopping\ RS.xml', 'utf-8')

headers =
  'user-agent': 'dogswaggle'
  'Content-Type': 'text/xml;charset=UTF-8'
  'soapAction': 'https://stg.farelogix.com/xmlts/uatuadm',

flatten = (data) ->
  if Array.isArray data
    if data.length is 1
      return flatten data[0]
    else
      for val, i in data
        data[i] = flatten val

  else if typeof data is 'object'
    for key, val of data
      data[key] = flatten val
    return data

  else
    return data


getFlights = ->
  new Promise (resolve, reject) ->
    url = 'https://stg.farelogix.com/xmlts/uatuadm'
    xml = fs.readFileSync('./flightsRequest.xml', 'utf-8')
    { response } = await soapRequest { url, headers, xml, timeout: 10000 }
    { body } = response

    parseString body, (err, result) ->
      if err
        reject err
      else
        res = result['SOAP-ENV:Envelope']['SOAP-ENV:Body'][0]['ns1:XXTransactionResponse'][0]['RSP'][0]['AirShoppingRS'][0]
        res = res['DataLists'][0]['FlightSegmentList'][0]['FlightSegment']
        res = flatten res
        console.log res
        resolve res


app.get '/',  (req, res) -> res.send "Welcome to 🐕 DogSwaggle"

app.get '/flights',  (req, res) ->
  xml = await getFlights()
  res.send xml


app.listen(process.env.PORT || 3000)
