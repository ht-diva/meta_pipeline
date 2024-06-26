import pandas as pd
from pathlib import Path


def matching_map():
    path_list_study_one = config.get("path_list_study_one")
    path_list_study_two = config.get("path_list_study_two")
    temp_dict = {}
    missing_file = []

    with open(path_list_study_one, "r") as fp1, open(path_list_study_two, "r") as fp2:
        lines1 = [line.strip() for line in fp1.readlines()]
        lines2 = [line.strip() for line in fp2.readlines()]

    for line in lines1:
        path = Path(line)
        sequence_id = ".".join(path.stem.split(".")[:3])
        if path.exists():
            temp_dict[sequence_id] = {"file_path_study_one": str(path)}
        else:
            missing_file.append(str(path))

    for line in lines2:
        path = Path(line)
        sequence_id = ".".join(path.stem.split(".")[:3])
        if path.exists():
            temp_dict[sequence_id] = temp_dict.get(sequence_id, {})
            temp_dict[sequence_id]["file_path_study_two"] = str(path)
        else:
            missing_file.append(str(path))

    # Save missing files list
    missing_table = pd.Series(missing_file)
    missing_table.to_csv(ws_path("missing_files.csv"), sep="\t")

    # Save data with mismatching values
    # mismatching_dict = {
    #     key: temp_dict[key] for key in temp_dict if len(temp_dict[key]) <= 1
    # }

    mismatching_data = [
        (
            key,
            value.get("file_path_study_one", ""),
            value.get("file_path_study_two", ""),
        )
        for key, value in temp_dict.items()
        if len(value) <= 1
    ]

    mismatching_table = (
        pd.DataFrame.from_records(
            mismatching_data,
            columns=["seqid", "file_path_study_one", "file_path_study_two"],
        )
        .set_index("seqid", drop=True)
        .sort_index()
    )
    mismatching_table.to_csv(ws_path("mismatch_table.csv"), sep="\t")

    # return data with matching values
    # matching_dict = {
    #     key: temp_dict[key] for key in temp_dict if len(temp_dict[key]) > 1
    # }

    data = [
        (key, value["file_path_study_one"], value["file_path_study_two"])
        for key, value in temp_dict.items()
        if len(value) > 1
    ]

    matching_table = (
        pd.DataFrame.from_records(
            data, columns=["seqid", "file_path_study_one", "file_path_study_two"]
        )
        .set_index("seqid", drop=False)
        .sort_index()
    )

    return matching_table


def ws_path(file_path):
    Path(config.get("workspace_path")).mkdir(parents=True, exist_ok=True)
    return str(Path(config.get("workspace_path"), file_path))


def dst_path(file_path):
    return str(Path(config.get("dest_path"), file_path))
