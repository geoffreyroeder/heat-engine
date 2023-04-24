"""Defines a library of paths that are useful across the project.

Example usage:
	from source_package.paths import timeseries_data_dir
	import pandas as pd

	data = pd.read_csv(timeseries_data_dir / "2016-2019.csv")
"""

from pyprojroot import here

root = here(proj_files=[".git"])  # pathlib.Path
notebooks_dir = root / "notebooks"
data_dir = root / "data"
timeseries_data_dir = data_dir / "timeseries"
