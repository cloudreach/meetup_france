#!/usr/bin/env python3
"""
Usage::
    ./server.py <port>
"""
from sys import argv
from http.server import BaseHTTPRequestHandler, HTTPServer
from random import randrange
import json
import multiprocessing
import time

class HttpHandler(BaseHTTPRequestHandler):

    leak = []

    def do_GET(self):
        start = time.time()
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        size = 80*1024
        message = '%0{}x'.format(size) % randrange(16**size)
        self.leak.append(message)
        response = {"message": message}
        sleepTime = 0.2-time.time()+start
        if sleepTime > 0:
            time.sleep(sleepTime)
        self.wfile.write(json.dumps({"message": message}).encode('utf-8'))

def run(port=80):
    server_address = ('', port)
    httpd = HTTPServer(server_address, HttpHandler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

if __name__ == '__main__':

    port = int(argv[1])

    process = multiprocessing.Process(target=run, name="Run", args=([port]))
    process.start()
