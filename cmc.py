import urllib2
import json

from elasticsearch import Elasticsearch
es = Elasticsearch(host='eratostenes')

def coinmarketcap_request():
    uri = "http://coinmarketcap.northpole.ro/api/v5/all.json"
    req = urllib2.Request(uri)
    resp = urllib2.urlopen(req).read()
    _json = json.loads(resp)
    return _json

def save(_payload):
    es.index(index='coinmarketcap', doc_type='all', id=_payload['timestamp'], body=_payload)

def download_and_save():
    payload = coinmarketcap_request()
    save(payload)
    logging.info('Inserted '+ str(payload['timestamp']) + ' with ' + str(len(payload['markets'])) + ' markets and ' + str(len(payload['currencyExchangeRates'])) + ' fiat currency rates into coinmarketcap/all')

import logging
LOG_FILENAME = 'cmc.log'
logging.basicConfig(filename=LOG_FILENAME,level=logging.INFO)

download_and_save()
