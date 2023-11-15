# Use the official Ubuntu image as the base image                                                                                       [3/11327]
FROM ubuntu:20.04

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/root/.local/bin:/opt/ghc/bin:/opt/cabal/bin:$PATH

# Install necessary dependencies
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:hvr/ghc && \
    apt-get update -y && \
    apt-get install -y \
        git \
        curl \
        libgmp-dev \
        zlib1g-dev \
        libtinfo-dev \
        libsqlite3-dev \
        libpq-dev \
        libmysqlclient-dev \
        libssl-dev

# Install Stack
RUN curl -sSL https://get.haskellstack.org/ | sh

# Copy the Yesod project files to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Build the Yesod app with Stack
RUN stack setup && \
    stack build

# Expose the port the Yesod app will run on
EXPOSE 3000

# Start the Yesod app
CMD ["stack", "exec", "--", "website"]
