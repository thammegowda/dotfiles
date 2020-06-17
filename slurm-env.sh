# See `-o <output_format>, --format=<output_format>` under `man squeue` for what each field does.
format="\"%8i %9g %9u %5P %35j %2t %12M %12l %5D %3C %R %H %I %J %z\""
format="\"%8i %8g %9u %5P %30j %2t %12M %12l %5D %3C %10R %10b\""
flags="-S +i -o ${format}"
# Show the status of only your jobs
alias q="squeue -u $USER ${flags}"
# Show the status of all cluster jobs
alias qa="squeue -a ${flags}"
# Show detailed information about the given job ID
alias c="scontrol show jobid -dd"



alias qrsh="echo srun -p development -t 0-2:00:00 --mem=4G -N 1 -n 4 --pty bash"
