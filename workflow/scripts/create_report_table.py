import click
from pathlib import Path

@click.command()
@click.option("-i", "--input_path", required=True, help="Input path")
@click.option("-o", "--output_path", required=True, help="Output path")
def main(input_path, output_path):
    input = Path(input_path)
    files = [f for f in input.rglob('*.txt') if f.is_file()]

    header_ = True
    header = ""
    data = []

    for f in files:
        with open(f, 'r') as fp:
            if header_:
                header = fp.readline()
                header_ = False
            else:
                fp.readline()
            data.append(fp.readline())

    output = Path(output_path)
    with open(output, "w") as fp:
        fp.write(header)
        fp.writelines(data)


if __name__ == "__main__":
    main()
