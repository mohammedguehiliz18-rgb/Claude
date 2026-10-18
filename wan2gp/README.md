# Wan2GP setup

Wan2GP needs an NVIDIA GPU. Run this on your GPU machine (Linux, with Miniconda installed):

```bash
bash wan2gp/setup.sh            # clones into ./Wan2GP
conda activate wan2gp
cd Wan2GP && python wgp.py      # then open http://localhost:7860
```

The script checks your GPU and picks the right versions:

| GPU | Python | PyTorch |
| --- | --- | --- |
| RTX 20xx – 50xx | 3.11.14 | 2.10.0 (CUDA 13.0) |
| GTX 10xx | 3.10.9 | 2.7.1 (CUDA 12.8) |

Why not `torch==2.7.0 … whl/test/cu124`? No torch 2.7.0 build exists on the
cu124 index, so that command fails. The current Wan2GP `requirements.txt` also
targets the newer stack above.

On Windows, use upstream's `scripts\install.bat` instead.
