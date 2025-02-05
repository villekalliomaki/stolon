ARG PGVERSION

# Base image
FROM golang:1.16-buster AS build_base

WORKDIR /stolon

COPY go.mod .
COPY go.sum .

RUN go mod download

# Build binaries
FROM build_base AS builder

# Copy source
COPY . .

RUN make

# Final image
FROM postgres:$PGVERSION

RUN useradd -ms /bin/bash stolon

EXPOSE 5432

# copy the agola-web dist
COPY --from=builder /stolon/bin/ /usr/local/bin

RUN chmod +x /usr/local/bin/stolon-keeper /usr/local/bin/stolon-sentinel /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl
