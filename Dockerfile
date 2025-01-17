FROM postgres:16.3

# Instala dependências necessárias
RUN apt-get update && apt-get install --no-install-recommends -y \
   build-essential \
   git \
   postgresql-server-dev-all \
   python3.11 \
   python3-pip -y \
   postgresql-plpython3-16 \
   && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
   && rm -rf /var/lib/apt/lists/*

# Definindo variáveis de ambiente para diretórios temporários
ARG WORKDIR=/tmp
ARG PGVECTOR=/tmp/pgvector
ARG PGAI=/tmp/pgai

# Definindo o diretório de trabalho
WORKDIR ${WORKDIR}

# Clonando o repositório pgvector e pgai
RUN git clone https://github.com/pgvector/pgvector.git
RUN git clone --branch v0.3.0 https://github.com/timescale/pgai.git ${PGAI}

# Compilação e instalação do pgvector
WORKDIR ${PGVECTOR}
RUN ls -la ${PGVECTOR} && git pull origin master && make
RUN make install

# Compilação e instalação do pgai
WORKDIR ${PGAI}
RUN make
RUN make install
