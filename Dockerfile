FROM golang:buster AS gobuilder
WORKDIR /src
COPY go.mod go.mod
COPY dns_reverse_proxy.go dns_reverse_proxy.go
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o dns_reverse_proxy .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=gobuilder /src/dns_reverse_proxy /usr/local/bin/dns_reverse_proxy
EXPOSE 53
EXPOSE 53/udp
CMD ["dns_reverse_proxy"]
