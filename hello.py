import os
import sys

if len(sys.argv) != 2:
    print("Usage: python3 hello.py <file>")
    sys.exit(1)

file_path = sys.argv[1]

if not os.path.isfile(file_path):
    print("Error: file does not exist")
    sys.exit(1)

size = os.path.getsize(file_path)

print(f"File size: {size} bytes")
