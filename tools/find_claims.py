import io
import re

h = io.open(r"C:\Users\logan\nourishology\index.html", encoding="utf-8").read()
for m in re.findall(r"[^<>\n]*(?:chemist|nurse)[^<>\n]*", h, re.I):
    print(repr(m.strip()))
