# Image name: harbor.cloud.infn.it/unpacked/aiinfn-gha-runner:latest
FROM ghcr.io/actions/actions-runner:latest
LABEL maintainer="lucio.anderlini@fi.infn.it"

ARG APPTAINER_VERSION=1.3.2

#labels
LABEL org.label-schema.apptainer-version=$APPTAINER_VERSION
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.description="Geant4 Docker image"
LABEL org.label-schema.url="https://github.com/landerlini/apptainer-gh-action"
LABEL org.label-schema.docker.cmd="docker build -t harbor.cloud.infn.it/unpacked/aiinfn-gha-runner:latest --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --no-cache=true ."

# Switch to root for Apptainer installation
USER root

ENV LANG=C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -yq --no-install-recommends install \
    ca-certificates \
    wget \
    && \
    cd /tmp && \
    wget https://github.com/apptainer/apptainer/releases/download/v${APPTAINER_VERSION}/apptainer_${APPTAINER_VERSION}_amd64.deb && \
    apt install -y ./apptainer_${APPTAINER_VERSION}_amd64.deb \
    && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*

# Install Python and Snakemake 
COPY --from=python:3.13 /usr/local /usr/local

RUN python3 --version && \
    python3.13 -m ensurepip && \
    python3.13 -m pip install \
        --root-user-action=ignore --disable-pip-version-check --no-cache-dir \
        "snakemake>=9" \
        "pygments" \
        snakemake-storage-plugin-s3 \
        git+https://github.com/landerlini/snakemake-storage-plugin-webdav.git \
        git+https://github.com/landerlini/snakemake-storage-plugin-fs.git \
        git+https://github.com/landerlini/snakemake-storage-helper.git 


# Switch to root for Apptainer installation
USER runner

# Default command to execute if none is provided to docker run
CMD ["bash"]
