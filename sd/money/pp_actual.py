#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "pandas",
#   "actualpy",
#   "python-dotenv",
# ]
# ///

"""Prepare bank statements for use in Actual Budget.

Move them from Downloads to a temp folder after processing.
"""

from pathlib import Path
from dotenv import load_dotenv
from actual import Actual
from actual.queries import get_transactions
import os

import tempfile
from datetime import date
from typing import NamedTuple

import pandas as pd

load_dotenv(Path(__file__).parent / ".env")
DIR = Path(tempfile.gettempdir()) / "pp_actual"
DOWNLOAD_DIR = Path.home() / "Downloads"

if DIR.exists():
    for file in DIR.iterdir():
        file.unlink()
    DIR.rmdir()
DIR.mkdir(parents=True, exist_ok=True)


class Config(NamedTuple):
    """Configuration for loading bank statements."""

    name: str
    file_regex: str
    skiprows: int
    date_column: str

    date_format: str = "%d.%m.%y"
    sep: str = ";"
    min_date: date = date(2023, 1, 1)
    rename_columns: dict[str, str] = {}


def load_last_statements(config: Config) -> pd.DataFrame:
    """Load the latest bank statement matching the config."""
    files = sorted(
        DOWNLOAD_DIR.glob(config.file_regex),
        key=lambda p: p.stat().st_ctime,
        reverse=True,
    )
    if not files:
        msg = f"No files found matching {config.file_regex} in {DOWNLOAD_DIR}"
        raise FileNotFoundError(msg)

    latest_file = files[0]
    print(f"Loading {latest_file} for {config.name}")

    df = pd.read_csv(
        latest_file,
        skiprows=config.skiprows,
        sep=config.sep,
        date_format=config.date_format,
    )
    df = df[
        pd.to_datetime(df[config.date_column], format=config.date_format)
        > pd.Timestamp(config.min_date)
    ]
    df = df.rename(columns=config.rename_columns)

    output_file = DIR / latest_file.name
    df.to_csv(output_file, index=False)
    processed_name = latest_file.stem + "_processed" + latest_file.suffix
    df.to_csv(DOWNLOAD_DIR / processed_name, index=False)

    return df


if __name__ == "__main__":
    dkb_config = Config(
        name="DKB",
        file_regex="*_DE47120300001035301918.csv",
        skiprows=4,
        date_column="Buchungsdatum",
    )

    configs = [
        dkb_config,
    ]

    for config in configs:
        df = load_last_statements(config)
        