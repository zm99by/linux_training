#!/usr/bin/env python3

import http.server
import socketserver
import base64
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 6543

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if PORT == 5432:
            message = "🎉 Congrats! The service is now running on the correct port.<br>"
            secret = base64.b64encode(b"supersecretpassword123").decode()
            html = f"<html><body>{message}<hr><b>🔐 Secret:</b> {secret}</body></html>"
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(html.encode())
        else:
            self.send_error(500, "Wrong port - configuration error")

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Mock server started on port {PORT}")
    httpd.serve_forever()
