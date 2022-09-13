FROM python:3

ADD index.html index.html

EXPOSE 8080

CMD [ "-m http.server 8080" ]

ENTRYPOINT [“python3”]