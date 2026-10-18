#!/usr/bin/env bash
# Wan2GP setup for Linux + NVIDIA GPU, following the upstream README (Oct 2026).
# Usage: bash setup.sh [install_dir]   (default: ./Wan2GP)
set -euo pipefail

DIR="${1:-Wan2GP}"
ENV=wan2gp

command -v conda >/dev/null || { echo "conda not found: install Miniconda first"; exit 1; }
command -v nvidia-smi >/dev/null || { echo "nvidia-smi not found: an NVIDIA GPU + driver is required"; exit 1; }

# Compute capability, e.g. "8.6" -> 86. GTX 10xx is 6.x and needs the legacy stack.
CC=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | head -1 | tr -d '.')
if [ "$CC" -lt 70 ]; then
  PY=3.10.9
  TORCH="torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/test/cu128"
else
  PY=3.11.14
  TORCH="torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 --index-url https://download.pytorch.org/whl/cu130"
fi
echo "GPU compute capability $CC -> Python $PY"

[ -d "$DIR" ] || git clone https://github.com/deepbeepmeep/Wan2GP.git "$DIR"
cd "$DIR"

eval "$(conda shell.bash hook)"
conda env list | grep -q "^$ENV " || conda create -y -n "$ENV" "python=$PY"
conda activate "$ENV"

pip install $TORCH
pip install -r requirements.txt

echo
echo "Done. Start with:  conda activate $ENV && cd $DIR && python wgp.py"
echo "Optional speed-ups (SageAttention, Flash): see docs/INSTALLATION.md"
