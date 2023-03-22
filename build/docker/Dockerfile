FROM python:3.10-alpine

ENV PATH=/usr/local/src:$PATH

# Versions
ARG KUBESEAL_VERSION=0.19.4
ARG KUBECTL_VERSION=1.26.1


# install python build dependencies
RUN apk --no-cache add \
    gcc \
    musl-dev \
    libffi-dev \
    make \
    bash \
    openssl \
    curl \
    pcre2-tools \
    grep \
    git \
    jq \
    nano \
    apache2-utils

RUN apk add trivy --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

# update pip
RUN pip3 install --upgrade pip

# install requirements
COPY src/python/bootstrap/requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# install kubeseal
RUN curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz \
    -o kubeseal.tar.gz \
    && tar xfz kubeseal.tar.gz \
    && mv kubeseal /usr/local/bin \
    && chmod +x /usr/local/bin/kubeseal \
    && rm -f kubeseal.tar.gz

# install kubectl
RUN curl -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin

#install ssh-keygen
RUN   apk update && \
    apk add --no-cache \
    openssh-keygen

# install azure cli
RUN pip3 install azure-cli

# Installing Terraform
RUN apk add --update terraform


# Copy validation schemas
COPY src/python/bootstrap/schemas /usr/local/lib/python3.10/schemas

# copy binaries
COPY src/python/bootstrap/config-template /usr/local/bin

# copy templates
COPY src/templates /usr/local/src/templates

# copy initial config files
COPY src/configs /usr/local/src/configs

# Creator version
ARG CREATOR_VERSION=0.0.0

# set version
RUN echo "${CREATOR_VERSION}" > /usr/local/src/VERSION \
    && sed -Ei 's|creator:.*$|creator: '"${CREATOR_VERSION}"'|g' /usr/local/src/configs/config.yaml.initial

# copy bash scripts
COPY src/bash/ /usr/local/bin
RUN chmod +x /usr/local/bin/*

WORKDIR /mnt/pwd

# setup
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["bash"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]

