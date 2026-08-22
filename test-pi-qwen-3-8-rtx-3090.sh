#! /usr/bin/env bash

set -euv

echo "* Test Pi Qwen3.8 RTX 3090 *"

source set-host-envars

export LOGFILE=$HOME/Logfiles/qwen-3-8-27b.log
rm --force $LOGFILE

echo "..Downloading model"
llama download -hf unsloth/Qwen3.8-27B-GGUF
llama cli --cache-list

echo "..Testing unsloth/Qwen3.8-27B-GGUF"
llama serve -hf unsloth/Qwen3.8-27B-GGUF > $LOGFILE 2>&1 &
sleep 15
tail $LOGFILE

pi

pkill --full "llama serve"

echo "* Finished Test Pi Qwen3.8 RTX 3090 *"
echo ""
