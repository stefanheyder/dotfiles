#!/usr/bin/python3
import os
import re
import sys
from collections import defaultdict

def extract_imports(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
        # Regular expression to match import statements
        import_pattern = re.compile(r'^(?:from\s+(\S+)\s+)?import\s+(.+)$', re.MULTILINE)
        return import_pattern.findall(content)

def process_directory(directory):
    all_imports = defaultdict(set)
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.py'):
                file_path = os.path.join(root, file)
                imports = extract_imports(file_path)
                for from_import, import_names in imports:
                    if from_import:
                        package = from_import.split('.')[0]
                        all_imports[package].add(f"from {from_import} import {import_names}")
                    else:
                        for name in import_names.split(','):
                            package = name.strip().split('.')[0]
                            all_imports[package].add(f"import {name.strip()}")
    return all_imports

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <directory_path>")
        sys.exit(1)

    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a valid directory")
        sys.exit(1)

    imports = process_directory(directory)
    
    print("Unique imports by package:")
    for package, import_statements in sorted(imports.items()):
        print(f"\n## {package}")
        for statement in sorted(import_statements):
            print(f"  {statement}")

if __name__ == "__main__":
    main()

