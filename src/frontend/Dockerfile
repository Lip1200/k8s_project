FROM golang:1.22.4-alpine

WORKDIR /front

COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./

RUN go build -o /frontend
RUN go clean -cache -modcache -i -r

EXPOSE 8080
ENTRYPOINT [/frontend]
