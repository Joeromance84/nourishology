import io
import os

p = r"C:\Users\logan\nourishology\index.html"
t = io.open(p, encoding="utf-8").read()
before = len(t)
t = t.lstrip()
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("trimmed leading whitespace:", before - len(t), "chars")
print("starts with doctype:", t.startswith("<!DOCTYPE"))
