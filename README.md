## OSU Benchmark

This is a document for OSU Benchmark.

## Docker Image

### Intel MPI

```bash
cd /home/sleong/sandbox/docker-hpc-micro-benchmark/
docker build --tag registry.gsc.wustl.edu/sleong/osu-micro-benchmark:oneapi .
```

### CUDA and OpenMPI

Shown below is an example to build Docker image for OSU benchmark with OpenMPI and CUDA.

```bash
cd /home/sleong/sandbox/docker-hpc-micro-benchmark/
docker build --tag registry.gsc.wustl.edu/sleong/osu-micro-benchmark:openmpi-cuda-ofed -f Dockerfile.openmpi-cuda-lsf .
```

## Test


### osu_get_latency - Latency Test

1. Create a bsub batch file as shown below. For my example,  I named it `osu_get_latency.bsub`.
   ```bash
   #!/bin/bash

   #BSUB -q qa 
   #BSUB -n 2
   #BSUB -R "span[ptile=1]" 
   #BSUB -a "docker(registry.gsc.wustl.edu/sleong/osu-micro-benchmark:oneapi)"
   #BSUB -G compute-ris
   #BSUB -oo lsf-%J.log

   . /opt/intel/oneapi/setvars.sh
   hostlist=$(echo $LSB_HOSTS | tr ' ' '_')
   mpirun -np 2 $OSU_MPI_DIR/one-sided/osu_get_latency > ./osu_get_latency-$hostlist-$LSB_JOBID.log
   ```
2. Submit a job.  Shown below is an example.
   ```bash
   LSF_DOCKER_NETWORK=host LSF_DOCKER_IPC=host LSF_DOCKER_SHM_SIZE=20G bsub < osu_get_latency.bsub
   ```

### osu_get_bw - Bandwidth Test

1. Create a bsub batch file as shown below. For my example,  I named it `osu_get_bw.bsub`.
   ```bash
   #!/bin/bash

   #BSUB -q qa
   #BSUB -n 2
   #BSUB -R "span[ptile=1]"
   #BSUB -a "docker(registry.gsc.wustl.edu/sleong/osu-micro-benchmark:oneapi)"
   #BSUB -G compute-ris
   #BSUB -oo lsf-%J.log

   . /opt/intel/oneapi/setvars.sh
   hostlist=$(echo $LSB_HOSTS | tr ' ' '_')
   mpirun -np 2 $OSU_MPI_DIR/one-sided/osu_get_bw > ./osu_get_bw-$hostlist-$LSB_JOBID.log
   ```
2. Submit a job.  Shown below is an example.
   ```bash
   LSF_DOCKER_NETWORK=host LSF_DOCKER_IPC=host LSF_DOCKER_SHM_SIZE=20G bsub < osu_get_bw.bsub
   ```


## Helper

There is one helper script in ./bin directory.  Shown below are instructions on running the script.

1. Determine OSU benchmark program to run.
2. Run a test.  Shown below is an example command.
   ```bash
   QUEUE=subscription bin/osu-test.sh osu_gather -G compute-ris
   ```
