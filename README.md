# Dot Files

This is a repository of config files I collected from web to improve my productivity.
NOTE: I didnt create the configs, I collected them, maybe customized a bit for my usecase. 
So full credits to original authors. 

The goak is to be able to quickly setup work place on new machines. 


## Setup

```bash
git clone https://github.com/thammegowda/dot-files.git ~/dot-files
# add the bashrc inside this repo to the ~/.bashrc
echo "source ~/dot-files/.bashrc" >> ~/.bashrc
```


## Setup miniconda

TODO automate this
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/miniconda3
~/miniconda3/bin/conda init bash  # this edits ~/.bashrc
```
