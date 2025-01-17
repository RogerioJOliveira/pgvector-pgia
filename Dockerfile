FROM postgres:17

RUN apt-get update && apt-get install --no-install-recommends -y \
   build-essential \
   git \
   postgresql-server-dev-all \
   python3.11 \
   python3-pip -y \
   postgresql-plpython3-16 \
   && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
   && rm -rf /var/lib/apt/lists/*

ARG WORKDIR=/tmp
ARG PGVECTOR=/tmp/pgvector
ARG PGAI=/tmp/pgai

WORKDIR ${WORKDIR}

RUN git clone https://github.com/pgvector/pgvector.git
RUN git clone --branch v0.3.0 https://github.com/timescale/pgai.git ${PGAI}

WORKDIR ${PGVECTOR}
RUN ls -la ${PGVECTOR} && git pull origin master && make
RUN make install

WORKDIR ${PGAI}
RUN make
RUN make install