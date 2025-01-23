import pandas as pd
import click
from pathlib import Path

@click.command()
@click.option("-i", "--input_path", required=True, help="Input path")
@click.option("-o", "--output_path", required=True, help="Output path")
@click.option("-f", "--filter_path", required=True, help="Snipid to filter path")
def main(input_path, output_path, filter_path):
    input = Path(input_path)
    snpid = Path(filter_path)

    snpid_df = pd.read_csv(snpid)
    sumstat_df = pd.read_csv(input, sep='\t', compression='gzip')

    sumstat_df = sumstat_df[~sumstat_df['SNPID'].isin(snpid_df['SNPID'])]

    sumstat_df.to_csv(output_path, sep='\t', compression='gzip', index=False)




if __name__ == "__main__":
    main()
