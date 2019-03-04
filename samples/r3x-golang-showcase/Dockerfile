FROM golang:alpine as builder
RUN apk update && apk add git
RUN adduser -D -g '' appuser
RUN go get github.com/rubixFunctions/r3x-golang-sdk
ENV SOURCES /go/src/github.com/rubixFunctions/r3x-showcase-apps/r3x-golang-showcase
COPY . ${SOURCES}
WORKDIR ${SOURCES}
RUN cd ${SOURCES} && CGO_ENABLED=0 go build
FROM scratch
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/src/github.com/rubixFunctions/r3x-showcase-apps/r3x-golang-showcase/r3x-golang-showcase /r3x-golang-showcase
USER appuser
ENV PORT 8080
ENTRYPOINT [ "/r3x-golang-showcase" ]