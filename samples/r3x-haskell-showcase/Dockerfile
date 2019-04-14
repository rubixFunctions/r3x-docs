FROM haskell:8.6

RUN apt-get update && apt-get install --yes \
    xz-utils \ 
    build-essential \ 
    libtool \
    libpcre3-dev \
    libpcre3 \
    make

WORKDIR /app

ADD . /app

RUN stack setup
RUN stack build

EXPOSE 8080

CMD ["stack", "exec", "r3x-haskell-sdk-exe"]