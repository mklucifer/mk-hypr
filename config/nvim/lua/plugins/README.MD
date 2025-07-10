## Must Install for Debugger to work

### Python
- debugpy
```
mkdir .virtualenvs
cd .virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
```

### C/C++/Rust
- Requires gdb 14.0+
```
sudo pacman -S gdb
```
