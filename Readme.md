# Build and run BRAKER2 pipeline in a container

Docker container to run [BRAKER2](https://github.com/Gaius-Augustus/BRAKER), a
pipeline for gene prediction.

Currently, this container runs the *master* versions of BRAKER (>= v2.15) and
Augustus (>= v3.3.3).


1. Get the Dockerfile:

```bash
git clone https://github.com/dcourtine/BRAKER2-docker.git
cd BRAKER2-docker
```

2. Get your own copy of GeneMark, **GeneMark-ES/ET/EP ver X.XX_lic** for **Linux 64**
from:
[http://exon.gatech.edu/GeneMark/license_download.cgi](http://exon.gatech.edu/GeneMark/license_download.cgi).
    - Do not forget to download the license key!
    - Move the files `gm_key_64.gz` and `gm_et_linux_64.tar.gz` in this repo.

3. Build the Docker
```bash
docker build -t braker2 .
```

4. Run the container. Move to the directory where you have your data (*genome*, *rnaseq_align.bam*, *prot.fa*, ...)
    - interactive
    ```bash
    docker run --rm -v $(pwd):/data braker2:latest
    #Once in the container:
    braker.pl --genome=<path/to/genome.fa> <other_parameters>
    ```
    - run directly braker
    ```bash
    docker run --rm -v $(pwd):/data braker2:latest braker.pl --genome=<path/to/genome.fa> <other_parameters>
    ```
