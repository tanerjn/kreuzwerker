FROM lipanski/docker-static-website:latest

COPY . .

CMD ["/busybox", "httpd", "-f", "-v", "-p", "8000", "-c", "httpd.conf"]

