suppressMessages(library(data.table))
suppressMessages(library(optparse))

option_list <- list(
  make_option("--seqid", default=NULL, help="seqid name"),
  make_option("--input", default=NULL, help="Path and file name of GWAS summary statistics"),
  make_option("--NEF", default=1, help="Number of effective tests to apply Bonferroni correction"),
  make_option("--output", default="results", help="Output path and name for only significant sumstats"))
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
dataset<-fread(opt$input)

# filter snps significant in the meta-analysis and significant with opposite direction in single studies
threshold<-(-log10((5*10^(-8))/as.numeric(opt$NEF)))
print(threshold)
print(opt$seqid)
signif<-dataset[dataset$MLOG10P>=threshold,]
print(signif[1,])
signif$SEQID<-rep(opt$seqid,nrow(signif))
fwrite(signif, opt$output,
       sep="\t", quote=F, col.names = T, na=NA)
cat("\nSignificant snps saved!\n")
