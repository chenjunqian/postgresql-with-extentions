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
RUN sudo apt install -y -V ca-certificates lsb-release wget
RUN wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN sudo apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb
RUN sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
RUN sudo apt update
RUN sudo apt install -y -V postgresql-17-pgdg-pgroonga

# install PostgreSQL extentions
RUN echo "shared_preload_libraries = 'pgroonga,vector'" >> /usr/share/postgresql/postgresql.conf.sample

# COPY init.sql /docker-entrypoint-initdb.d/
