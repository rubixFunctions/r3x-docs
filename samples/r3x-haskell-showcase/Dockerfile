FROM haskell:8.2.2 as builder

RUN apt-get update && apt-get install --yes \
    xz-utils \ 
    build-essential \ 
    libtool \
    libpcre3-dev \
    libpcre3 \
    make

# Copy local code to the container image.
WORKDIR /app
COPY . .

# Build and test our code, then build the “helloworld-haskell-exe” executable.
RUN stack setup
RUN stack build --copy-bins --ghc-options '-static -optl-static -optl-pthread -fPIC'

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM fpco/haskell-scratch

# Copy the "helloworld-haskell-exe" executable from the builder stage to the production image.
WORKDIR /root/
COPY --from=builder /root/.local/bin/helloworld-haskell-exe .

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080

# Run the web service on container startup.
CMD ["./helloworld-haskell-exe"]