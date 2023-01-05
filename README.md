# Dot Files

This is a repository of config files I collected from web to improve my productivity.
NOTE: I didnt create the configs, I collected them, maybe customized a bit for my usecase. 
So full credits to original authors. 

The goak is to be able to quickly setup work place on new machines. 

## Setup

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/thammegowda/dotfiles/master/setup.bash)"
```


## Setup miniconda

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O conda-setup.sh \
  && bash conda-setup.sh -b -p ~/miniconda3 \
  && ~/miniconda3/bin/conda init bash \
  && rm conda-setup.sh
```

Install conda packages
```bash
conda install -y -c conda-forge byobu emacs
```
  
