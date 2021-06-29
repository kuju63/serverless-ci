FROM amazonlinux:2

RUN curl -fsSL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install nodejs -y && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    npm i -g serverless --cache=/tmp/empty-cache && \
    rm -rf /tmp/empty-cache

ENV PATH=/usr/local/bin:$PATH \
    LANG=C.UTF-8 \
    PYTHON_VERSION=3.8.10

RUN yum install gcc \
    zlib-devel \
    bzip2 \
    bzip2-devel \
    readline-devel \
    sqlite \
    sqlite-devel \
    openssl-devel \
    tk-devel \
    libffi-devel \
    xz-devel \
    tar \
    make \
    xz -y && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    curl -L https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz | tar Jxv -C /opt > /dev/null && \
    (cd /opt/Python-${PYTHON_VERSION} && \
    ./configure --enable-loadable-sqlite-extensions \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --with-system-expat \
    > /dev/null && \
    make altinstall > /dev/null && \
    make install > /dev/null) && \
    python3 -m pip install --upgrade --no-cache pip && \
    yum remove tar xz -y && \
    yum clean all && \
    rm -rf /opt/Python-${PYTHON_VERSION} && \
    python -V

RUN cd /usr/local/bin \
    && ln -s idle3 idle \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config
