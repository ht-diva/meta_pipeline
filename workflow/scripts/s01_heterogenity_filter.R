suppressMessages(library(data.table))
suppressMessages(library(optparse))

option_list <- list(
  make_option("--seqid", default=NULL, help="seqid name"),
  make_option("--input", default=NULL, help="Path and file name of GWAS summary statistics"),
  make_option("--NEF", default=1, help="Number of effective tests to apply Bonferroni correction"),
  make_option("--output", default=1, help="Output path and name for heterogenous sumstats"))
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
dataset<-fread(opt$input)

# filter snps significant in the meta-analysis and significant with opposite direction in single studies
threshold<-(-log10((5*10^(-8))/as.numeric(opt$NEF)))
unconsistent<-c("-+","+-")
heterogenous<-dataset[dataset$MLOG10P>=threshold&dataset$DIRECTION%in%unconsistent,]
heterogenous$SEQID<-rep(opt$seqi,nrow(heterogenous))
fwrite(heterogenous, opt$output,
       sep="\t", quote=F, col.names = T, na=NA)
cat("\nHeterogenous snps saved!\n")
