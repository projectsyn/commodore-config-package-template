from pathlib import Path

test_cases = "{{ cookiecutter.test_cases }}"

tests_dir = Path("tests")
tests_dir.mkdir(exist_ok=True)

for case in test_cases.split(" "):
    f = tests_dir / f"{case}.yml"
    f.touch()
