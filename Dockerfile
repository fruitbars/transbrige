FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o transbridge

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/transbridge .
COPY --from=builder /app/config.example.yml ./config.yml
EXPOSE 8080
CMD ["./transbridge"]