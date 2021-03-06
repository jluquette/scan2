#!/usr/bin/env Rscript
#SBATCH -c 1
#SBATCH -p park
#SBATCH -A park_contrib
#SBATCH -t 12:00:00
#SBATCH --mem-per-cpu=4G

args <- commandArgs(trailingOnly=TRUE)

if (length(args) != 2) {
    cat("assumes <dir> contains directories named chr1..chr22, which\n")
    cat("each contain a 'fit.rda' file corresponding to the final result\n")
    cat("of the grid search.\n")
    stop("usage: Rscript make_fits.R dir output.rda")
}

dir=args[1]
outfile=args[2]

if (file.exists(outfile))
    stop(sprintf("output file %s already exists", outfile))

fits <- do.call(rbind, lapply(1:22, function(chr) {
        f <- sprintf("%s/chr%d/fit.rda", dir, chr)
        if (file.exists(sprintf("%s/chr%d/fit.rda", dir, chr))) {
            load(f)
            return(c(chr, fits))
        } else
            return(c())
    }
))

colnames(fits) <- c('chr', 'a', 'b', 'c', 'd', 'logq')
print(fits)

save(fits, file=outfile)
