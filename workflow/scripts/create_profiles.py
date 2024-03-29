from pathlib import Path


def main(matching_map, template_file, outdir):
    with open(template_file, "r") as fp:
        lines = fp.readlines()

    seqid = Path(outdir).name

    with open(Path(outdir, f"profile_{seqid}.txt"), "w") as fp:
        for line in lines:
            line = line.replace("input_study_one", matching_map.loc[seqid, 'file_path_study_one'], 1)
            line = line.replace("input_study_two", matching_map.loc[seqid, 'file_path_study_two'], 1)
            line = line.replace("output_path", f"{outdir}/METAL_output_{seqid}_", 1)
            fp.write(line)


main(matching_map=snakemake.params.matching_map,
     template_file=snakemake.input.template,
     outdir=snakemake.params.outdir)
