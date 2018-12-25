FROM alpine:latest as build

# Check the JDK 12 EA downloads link to get the latest version number
RUN mkdir -p /opt/jdk \
    && wget -q "https://download.java.net/java/early_access/alpine/20/binaries/openjdk-12-ea+20_linux-x64-musl_bin.tar.gz" \
    && tar -xzf "openjdk-12-ea+20_linux-x64-musl_bin.tar.gz" -C /opt/jdk

RUN ["/opt/jdk/jdk-12/bin/jlink", \
     "--compress=2", \
     "--strip-debug", \
     "--no-header-files", \
     "--no-man-pages", \
     "--module-path", "/opt/jdk/jdk-12/jmods", \
     "--add-modules", "java.base,java.logging,jdk.unsupported", \
     "--output", "/custom-jre"]

FROM alpine:latest
COPY --from=build /custom-jre /opt/jdk/
ADD "app" /app
RUN mkdir /app/images \
    && mv /app/container*?jpg /app/images

CMD ["/opt/jdk/bin/java", \
     "--upgrade-module-path", "/app", \
     "-m", "ud.examples.imageserver/ud.examples.imageserver.Server"]
