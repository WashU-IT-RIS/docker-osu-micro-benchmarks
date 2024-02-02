starts=('compute1-exec-70')
hosts=($(bhosts -w -R 'select[cpumicro=cascadelake]' qa  | grep -v HOST | awk '{ print $1 }' | cut -f1 -d'.'))
for i in ${starts[@]}; do
   for j in ${hosts[@]}; do
     if ! [[ $i == $j ]]; then
       export NP=32 && LSF_DOCKER_NETWORK=host LSF_DOCKER_IPC=host LSF_DOCKER_SHM_SIZE=20G bsub -n $NP -m "$i $j" < osu_allgather_intel.bsub
     fi
   done
done
