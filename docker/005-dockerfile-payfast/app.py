from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"PayFast API - OK")
    def log_message(self, format, *args):
        print(f"Request: {args[0]} {args[1]}")

HTTPServer(('0.0.0.0', 8000), Handler).serve_forever()
