FROM postgres:17-bookworm

# install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    postgresql-server-dev-17 \
    wget \
    git \
    cmake \
    sudo

# install pgvector
RUN git clone --branch v0.7.0 https://github.com/pgvector/pgvector.git /tmp/pgvector && \
    cd /tmp/pgvector && \
    make && \
    make install && \
    rm -rf /tmp/pgvector

# install pgroonga dependencies
ENV PGROONGA_VERSION=4.0.1-1
ENV POSTGRESQL_VERSION=17
RUN \
    apt update && \
    apt install -y -V lsb-release wget && \
    wget https://apache.jfrog.io/artifactory/arrow/debian/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
    apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
    rm apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
    wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb && \
    apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb && \
    rm groonga-apt-source-latest-$(lsb_release --codename --short).deb && \
    apt update && \
    apt install -y -V \
    postgresql-${POSTGRESQL_VERSION}-pgdg-pgroonga=${PGROONGA_VERSION} \
    groonga-normalizer-mysql \
    groonga-token-filter-stem \
    groonga-tokenizer-mecab && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# COPY init.sql /docker-entrypoint-initdb.d/
