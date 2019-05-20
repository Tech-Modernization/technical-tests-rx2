FROM golang:alpine AS builder

ENV GO111MODULE=on

RUN apk update --no-cache && \
  apk add git

WORKDIR /app
COPY . /app
RUN go build -o app .

# final stage
FROM alpine

ARG ci_sha
ARG ci_description
ARG ci_version
ENV CI_SHA=$ci_sha
ENV CI_DESCRIPTION=$ci_description
ENV CI_VERSION=$ci_version
ENV CI=true
ENV APP_PORT=10000
WORKDIR /app

RUN addgroup -g 2000 golang && \
  adduser -D -u 2000 -G golang golang
USER golang
COPY --from=builder /app/app .

EXPOSE 10000
CMD ["/app/app"]