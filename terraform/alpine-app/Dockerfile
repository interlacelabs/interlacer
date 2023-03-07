FROM golang:alpine AS build
RUN apk --no-cache add tzdata
RUN apk --no-cache add ca-certificates
WORKDIR /app
ADD prog.go /app
RUN apk update && apk add build-base
RUN cd /app && CGO_ENABLED=0 go build -ldflags="-w -s" -o prog prog.go

################################################
# alpine image
################################################

# FROM alpine:3.13.4
FROM alpine:3.16

# staging for go app
WORKDIR /app
COPY --from=build /app/prog /app/awesome-prog
ENV TZ=UTC

# ENTRYPOINT ["/app/awesome-prog"]
CMD ["/app/awesome-prog" ]