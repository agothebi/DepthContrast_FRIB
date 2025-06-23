#!/bin/bash
#SBATCH --job-name="depthcontrast-setup"
#SBATCH --mem=32g
#SBATCH --gpus=1
#SBATCH --constraint=cuda10
#SBATCH --output=depthcontrast_setup.out

# Activate base conda
source /opt/conda/bin/activate

# Load appropriate CUDA module (must match cu101, not cu102)
module load CUDA/10.2.89

# Create environment from YAML file
conda env create -f depthcontrast_env.yaml

conda activate depthcontrast

pip install torch==1.5.1+cu101 torchvision==0.6.1+cu101 -f https://download.pytorch.org/whl/torch_stable.html

# For some reason, the Pillow version in the environment is not compatible with torchvision.
pip uninstall pillow -y
# Downgrade Pillow to a compatible version.
pip install pillow==6.2.2

# Confirm installation
python -c "import torch; print('CUDA Available:', torch.cuda.is_available())"
python -c "import torch; import torchvision; print(f'Torch: {torch.__version__}, Torchvision: {torchvision.__version__}')"

