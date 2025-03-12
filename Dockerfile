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
RUN apt-get install -y software-properties-common && \
    sudo add-apt-repository -y universe && \
    sudo add-apt-repository -y ppa:groonga/ppa && \
    apt-get update && \
    apt-get install -y \
    postgresql-17-pgroonga \
    groonga-tokenizer-mecab

# install PostgreSQL extentions
RUN echo "shared_preload_libraries = 'pgroonga,vector'" >> /usr/share/postgresql/postgresql.conf.sample

COPY init.sql /docker-entrypoint-initdb.d/
