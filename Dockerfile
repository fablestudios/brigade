FROM --platform=${BUILDPLATFORM} golang:1.19.2-alpine3.16 AS builder
ARG TARGETARCH
ARG TARGETOS

RUN apk --no-cache add ca-certificates git

# Copy the code from the host and compile it
WORKDIR /src/brigade
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -a -installsuffix nocgo -o /brigade .

FROM --platform=${TARGETPLATFORM} alpine:3.16
RUN apk --no-cache add ca-certificates
COPY --from=builder /brigade /usr/local/bin/

USER nobody
ENTRYPOINT ["/usr/local/bin/brigade"]
