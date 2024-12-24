#syntax=docker/dockerfile:experimental

FROM golang:latest as go
FROM node:latest as nodedev
COPY --from=go /usr/local/go /usr/local/go
ENV PATH /usr/local/go/bin:$PATH
ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update; \
    apt-get install -yqq --no-install-recommends \
    git xz-utils wget iputils-ping; \
    rm -rf /var/lib/apt/lists/*

# install go tools with go cache mounted
RUN --mount=type=cache,target=/root/.cache/go \
    go install golang.org/x/tools/gopls@latest; \
    go install github.com/a-h/templ/cmd/templ@latest; \
    go install github.com/air-verse/air@latest; \
    go clean -cache; \
    go clean -modcache