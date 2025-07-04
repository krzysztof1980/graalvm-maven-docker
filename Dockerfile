FROM debian:stable-slim

LABEL maintainer="SoftInstigate <info@softinstigate.com>"

ARG JAVA_VERSION="22.0.2-graalce"
ARG MAVEN_VERSION="3.9.9"

ENV SDKMAN_DIR=/root/.sdkman

COPY bin/entrypoint.sh /root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        fontconfig \
        libz-dev \
        locales \
        tzdata \
        unzip \
        zip \
        zlib1g-dev \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && curl 'https://get.sdkman.io' | bash \
    && rm -rf /var/lib/apt/lists/* \
    && echo "sdkman_auto_answer=true" > "${SDKMAN_DIR}/etc/config" \
    && echo "sdkman_auto_selfupdate=false" >> "${SDKMAN_DIR}/etc/config" \
    && echo "sdkman_insecure_ssl=true" >> "${SDKMAN_DIR}/etc/config" \
    && chmod +x "${SDKMAN_DIR}/bin/sdkman-init.sh" \
    && bash -c "source ${SDKMAN_DIR}/bin/sdkman-init.sh \
        && sdk version \
        && sdk install java $JAVA_VERSION \
        && sdk install maven $MAVEN_VERSION \
        && rm -rf ${SDKMAN_DIR}/archives/* \
        && rm -rf ${SDKMAN_DIR}/tmp/*"

SHELL ["/bin/bash", "-i", "-c"]

ENTRYPOINT [ "/root/entrypoint.sh" ]
