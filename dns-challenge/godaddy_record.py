#!python2

from __future__ import print_function
import requests
from sys import argv
from os import environ
import logging

logging.basicConfig(level=logging.DEBUG)
L = logging.getLogger('godaddy')


def usage():
    usage='''usage: godaddy_record.py MAIN_DOMAIN RECORD_TYPE RECORD_NAME RECORD_DATA

note: GoDaddy API key and secrets are read from environment variables GODADDY_API_KEY and GODADDY_API_SECRET

example:
  GODADDY_API_KEY=123 GODADDY_API_SECRET=456 python site.com TXT www text-for-www.site.com
'''

    print(usage)

def main():
    L.info('enter main')
    if len(argv) < 5:
        usage()
        exit(10)

    domain, rtype, name, data = argv[1:5]
    L.info('domain %s rtype %s name %s data %s', domain, rtype, name, data)
    url = environ['GODADDY_URL'].rstrip('/') + '/v1/domains/' + domain + '/records/' + rtype
    L.info('url %s', url)
    key = environ['GODADDY_API_KEY']
    L.info('key %s', key)
    secret = environ['GODADDY_API_SECRET']
    L.info('secret %s', secret)

    resp = requests.put(
        url,
        headers=dict(
            Accept='application/json',
            Authorization='sso-key ' + key + ':' + secret,
        ),
        json=[dict(
            data=data,
            name=name,
            ttl=600,
        ),]
    )
    L.info('send: %r', resp.request)
    L.info('get response: %r', resp)
    try:
        L.info('response payload: %s', resp.text)
    except:
        pass

    if not resp.ok:
        L.error('godaddy api request failed')
        exit(20)

    
if __name__ == '__main__':
    main()

