FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-lang-european \
    texlive-bibtex-extra \
    biber \
    git \
    texlive-xetex \
    python3 \
    python3-pip \
    python-is-python3 \
    latexmk && \
    pip install pygments && \
    rm -rf /var/lib/apt/lists/*
COPY fonts/ /usr/share/fonts/opentype
RUN fc-cache -f -v
