FROM golang:alpine as builder

RUN apk add --no-cache git ca-certificates

WORKDIR /etcdkeeper
ADD src/etcdkeeper ./

RUN go mod download && \
    go build -o etcdkeeper

FROM alpine

ENV HOST="0.0.0.0"
ENV PORT="8080"

RUN apk add --no-cache ca-certificates

WORKDIR /etcdkeeper
COPY --from=builder /etcdkeeper/etcdkeeper .
ADD assets assets

EXPOSE ${PORT}

ENTRYPOINT ./etcdkeeper -h $HOST -p $PORT