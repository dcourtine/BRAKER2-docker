From ubuntu:18.04
MAINTAINER Damien Courtine (courtine@ciml.univ-mrs.fr)

#inpired from
# - https://singularity-hub.org/containers/12515
# - https://github.com/blaxterlab/braker-docker/blob/master/Dockerfile

RUN apt-get update && apt-get upgrade -y -q

RUN apt-get install -y -q \
    software-properties-common \
    libboost-iostreams-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    zlibc \
    gcc-multilib \
    apt-utils \
    zlib1g-dev \
    python \
    cmake \
    tcsh \
    autoconf \
    build-essential \
    g++ \
    git \
    wget \
    gzip \
    perl \
    cpanminus \
    libgsl-dev \
    libboost-graph-dev \
    libsuitesparse-dev \
    liblpsolve55-dev \
    libsqlite3-dev \
    libmysql++-dev \
    bamtools \
    libbamtools-dev \
    libboost-all-dev \
    libssl-dev \
    libcurl3-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    ncbi-blast+ \
    python3-biopython

RUN  cpan App::cpanminus \
    && cpanm YAML \
        File::Spec::Functions \
        Hash::Merge \
        List::Util \
        Logger::Simple \
        Module::Load::Conditional \
        Parallel::ForkManager \
        POSIX \
        Scalar::Util::Numeric \
        File::Which \
        File::HomeDir \
        MCE::Mutex \
        threads \
        Math::Utils \
        Thread::Queue \
        List::MoreUtils

RUN mkdir /tools \ 
    && git clone https://github.com/samtools/htslib.git /tools/htslib \
    && cd /tools/htslib \
    && autoheader \ 
    && autoconf \
    && ./configure \
    && make \
    && make install \
    && git clone https://github.com/samtools/samtools.git /tools/samtools \
    && cd /tools/samtools \
    && autoheader \
    && autoconf -Wno-syntax \
    && ./configure \
    && make \
    && make install 

ENV TOOLDIR="/tools/"

RUN git clone https://github.com/Gaius-Augustus/Augustus.git  /tools/augustus \
    && cd /tools \
    && mkdir -p /tools/augustus/bin \
    && cd augustus \
    && cd src \
    && make \
    && for elt in aln2wig bam2hints bam2wig compileSpliceCands filterBam homGeneMapping joingenes; do cd /tools/augustus/auxprogs/$elt; make;done \
    && cd /tools

COPY gmes_linux_64.tar.gz /tools
RUN cd /tools \
    && tar xvf gmes_linux_64.tar.gz \
    && rm gmes_linux_64.tar.gz

RUN cd /tools \
    && git clone https://github.com/Gaius-Augustus/BRAKER.git \
    && wget http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/exonerate-2.2.0-x86_64.tar.gz \
    && gunzip exonerate-2.2.0-x86_64.tar.gz \
    && tar xvf exonerate-2.2.0-x86_64.tar \
    && chmod 777 exonerate-2.2.0-x86_64 \
    && chmod 777 exonerate-2.2.0-x86_64/bin \
    && chmod 777 exonerate-2.2.0-x86_64/bin/* \
    && git clone https://github.com/gatech-genemark/ProtHint.git /tools/ProtHint

RUN apt-get install cdbfasta

RUN adduser --disabled-password --gecos '' dockeruser
RUN mkdir /data
RUN chown -R dockeruser /data
RUN chmod a+w -R /tools/augustus/config
USER dockeruser
WORKDIR /data
RUN echo $HOME
COPY gm_key_64.gz /
RUN zcat /gm_key_64.gz > $HOME/.gm_key

ENV LANG="C"
ENV AUGUSTUS_CONFIG_PATH="/tools/augustus/config"
ENV PATH="/tools/augustus/bin:${PATH}"
ENV PATH="/tools/augustus/scripts:/tools/BRAKER/scripts:${PATH}"
ENV AUGUSTUS_BIN_PATH="/tools/augustus/bin"
ENV GENEMARK_PATH="/tools/gmes_linux_64"
ENV PATH="/tools/exonerate-2.2.0-x86_64/bin/:${PATH}"
ENV AUGUSTUS_SCRIPTS_PATH="/tools/augustus/scripts"
ENV ALIGNMENT_TOOL_PATH="/tools/ProtHint/bin/"



