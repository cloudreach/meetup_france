#!/usr/bin/env python3
"""
Usage::
    ./client.py <server>:<port>
"""
from sys import argv
from datetime import datetime
import urllib.request
import multiprocessing

def run(url):
    try:
        while(True):
            try:
                content = urllib.request.urlopen(url).read()
                print("{} GET {} : {} bytes".format(datetime.now(), url, len(content)))
            except Exception as e:
                print("{} GET {} : error {} :(".format(datetime.now(), url, e))
    except KeyboardInterrupt:
        pass

if __name__ == '__main__':

    url = "http://{}".format(argv[1])

    process = multiprocessing.Process(target=run, name="Run", args=([url]))
    process.start()
