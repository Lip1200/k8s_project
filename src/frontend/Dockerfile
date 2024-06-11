FROM golang:1.22.4-alpine

WORKDIR /front

COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN go build -o /frontend


EXPOSE 8080
ENTRYPOINT ["/frontend"]
