# 2018 QChain Inc. All Rights Reserved.
# License: Apache v2, see LICENSE.

FROM amazonlinux:latest

# Configuration options
ARG python_runtime=36
ARG out_dir=/var/task
ARG backend_home=https://s3.us-east-2.amazonaws.com/qchain-backend/backend-master.zip
ARG boost_home=https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz

# Update and install compiler dependencies
RUN yum update -y
RUN yum upgrade -y
RUN yum -y install python${python_runtime}-devel gcc-c++

# Install Boost 1.60+ (AmazonLinux only provides 1.41 and 1.53)
RUN curl "$boost_home" -L -o boost.tar.gz
RUN tar xvf boost.tar.gz
RUN cd /boost_1_66_0 && ./bootstrap.sh && ./b2 install --with-thread

# Install Python dependencies
RUN python${python_runtime} -m pip install requests Cython
RUN yum -y install curl unzip
RUN curl "$backend_home" -L -o backend.zip
RUN unzip backend.zip
RUN rm backend.zip
RUN mv backend-master qchain

# Copy required scripts into the Docker image
COPY host.sh /build

# Set environment variables and entry point
ENV PYTHON_RUNTIME ${python_runtime}
ENV OUTDIR ${out_dir}
CMD /build ${PYTHON_RUNTIME} ${OUTDIR}
