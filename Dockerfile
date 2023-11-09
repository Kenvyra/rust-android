FROM registry.fedoraproject.org/fedora-minimal:38

RUN microdnf install -y \
    clang \
    curl \
    git-core \
    glibc-devel \
    glibc-devel.i686 \
    lld \
    patch \
    perl \
    python3 \
    rsync \
    tar \
    unzip \
    xz && \
    microdnf clean all

RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && \
    chmod +x /usr/bin/repo

WORKDIR /build
COPY . .

CMD [ "bash" ]
