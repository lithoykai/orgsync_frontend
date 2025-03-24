FROM debian:bullseye-slim AS base

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl unzip git bash xz-utils libglu1-mesa openjdk-17-jdk ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV FLUTTER_VERSION=3.19.2

WORKDIR /opt

RUN git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION flutter

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/opt/flutter/.pub-cache/bin:$PATH"

RUN flutter doctor -v
RUN flutter precache --web
RUN flutter --version

FROM base AS build

WORKDIR /app

COPY . .

RUN flutter pub get && flutter build web --release

FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 5000

CMD ["nginx", "-g", "daemon off;"]
