# paths.py
from pathlib import Path
import os, sys

def find_project_root(marker: str = ".project-root") -> Path:
    p = Path.cwd().resolve()
    while not (p / marker).exists() and p.parent != p:
        p = p.parent
    if not (p / marker).exists():
        raise FileNotFoundError(
            f"Could not locate project root (missing {marker}). "
            f"Create an empty file named '{marker}' in your project root."
        )
    return p

PROJ_ROOT = find_project_root()
os.chdir(PROJ_ROOT)  # חשוב: כל הריצות יפעלו יחסית לשורש

DATA        = PROJ_ROOT / "data"
RAW         = DATA / "raw_data"
INTERIM     = DATA / "interim"
PROCESSED   = DATA / "processed"
REPORTS     = PROJ_ROOT / "my_ml_project" / "reports"  # או reports/
NOTEBOOKS   = PROJ_ROOT / "notebooks"

# יצירת תיקיות אם חסרות 
for d in [DATA, RAW, INTERIM, PROCESSED, REPORTS]:
    d.mkdir(parents=True, exist_ok=True)

def data_path(*parts) -> Path:
    "בונה נתיב לקובץ בתוך data, בלי חשיבה על \\ או /"
    return DATA.joinpath(*parts)
