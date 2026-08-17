set -eu

if [[ "$(which nvidia-smi 2>/dev/null | wc -l)" -gt "0" \
  && "$(nvidia-smi --list-gpus 2>/dev/null | wc -l)" -gt "0" ]]

then
  export COMPUTE_MODE=CUDA

else
  export COMPUTE_MODE=CPU

fi

echo "COMPUTE_MODE: $COMPUTE_MODE"
