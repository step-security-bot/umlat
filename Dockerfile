# Mostly from: https://github.com/GoogleContainerTools/distroless/blob/main/examples/python3-requirements/Dockerfile
# Build a virtualenv using the appropriate Debian release

FROM debian:12-slim@sha256:d02c76d82364cedca16ba3ed6f9102406fa9fa8833076a609cabf14270f43dfc AS build
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes git python3-venv gcc libpython3-dev
WORKDIR /app
RUN git clone https://github.com/wiedehopf/mlat-client
WORKDIR /app/mlat-client
RUN python3 -m venv /venv && \
    . /venv/bin/activate && \
    python3 setup.py build && \
    python3 setup.py install

# Copy the virtualenv into a distroless image
FROM gcr.io/distroless/python3-debian12:nonroot@sha256:5c7661ddc1f43e50ee97404b12146d34ac34afc9ab7e713c3bac189efb074e10
COPY --from=build /venv /venv
ENTRYPOINT ["/venv/bin/mlat-client"]
