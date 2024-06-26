rule sync_outputs_folder:
    input:
        ws_path("output/{seqid}/{seqid}.gwaslab.tsv.bgz"),
        ws_path("output/{seqid}/{seqid}.gwaslab.tsv.bgz.tbi"),
        ws_path("output/{seqid}/{seqid}_significant_snp.tsv"),
    output:
        touch(dst_path("output/{seqid}/.delivery.done")),
    params:
        folder=ws_path("output/{seqid}/"),
        output_folders=dst_path("output"),
        exclude=config.get("exclude_file"),
    resources:
        runtime=lambda wc, attempt: attempt * 60,
    shell:
        """
        rsync -rlptoDvz --chmod "D755,F644" --exclude-from {params.exclude} {params.folder} {params.output_folders}"""


rule sync_tables:
    input:
        table_minp=ws_path("min_pvalue_table.tsv"),
        table_if=ws_path("inflation_factors_table.tsv"),
    output:
        touch(dst_path("tables_delivery.done")),
    params:
        table_minp=dst_path("min_pvalue_table.tsv"),
        table_if=dst_path("inflation_factors_table.tsv"),
    resources:
        runtime=lambda wc, attempt: attempt * 10,
    shell:
        """
        rsync -rlptoDvz {input.table_minp} {params.table_minp} && \
        rsync -rlptoDvz {input.table_if} {params.table_if}"""


rule sync_plots:
    input:
        ws_path("plots/{seqid}.png"),
    output:
        dst_path("plots/{seqid}.png"),
    resources:
        runtime=lambda wc, attempt: attempt * 30,
    shell:
        """
        rsync -rlptoDvz {input} {output}"""
