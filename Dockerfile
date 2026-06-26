FROM nvidia/cuda:12.1.1-devel-ubuntu22.04
RUN apt-get update && apt-get install -y git wget curl
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/bash.bashrc
ENV PATH="/opt/conda/bin:$PATH"
RUN git clone https://github.com/h81189/PXDesign_server_minimal.git
WORKDIR /PXDesign_server_minimal
RUN chmod 777 install.sh && conda tos accept && ./install.sh --cuda-version 12.1 && conda run -n pxdesign pip uninstall torch -y && conda run -n pxdesign pip install --no-cache-dir torch==2.4.1+cu121 --index-url https://download.pytorch.org/whl/cu121
ENV PROTENIX_DATA_ROOT_DIR=/home/hari.koneru/PXDesign/release_data/ccd_cache
ENV TOOL_WEIGHTS_ROOT=/home/hari.koneru/PXDesign/tool_weights

RUN groupadd -g 10513 domainusers && useradd -m -u 20573 -g 10513 -s /bin/bash hari.koneru
USER hari.koneru