import os
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")
REPO = r"C:\Users\logan\nourishology"
html = open(os.path.join(REPO, "index.html"), encoding="utf-8").read()

print("=== STRUCTURE ===")
print("  starts with doctype:", html.startswith("<!DOCTYPE"))
print("  has <style> block  :", "<style>" in html)
print("  has hero           :", 'class="hero"' in html)
print("  has all 6 sections :", html.count("<section") == 6)
print("  sections balanced :", html.count("<section") == html.count("</section>"))
print("  divs balanced     :", html.count("<div") == html.count("</div>"))
print("  terminated        :", html.rstrip().endswith("</html>"))
print("  size              :", len(html), "bytes")

print("")
print("=== DRUG-CLAIM SCAN (must all be absent) ===")
banned = [
    "anti-inflammatory", "stabilizes the derma", "treats", "cures", "heals",
    "reduces inflammation", "topical supplement", "clinically proven",
    "dermatologist recommended", "eczema", "psoriasis", "dermatitis", "acne",
    "repairs the barrier", "restores", "medical grade",
]
hits = [b for b in banned if b in html.lower()]
print("  banned phrases    :", hits if hits else "none")

print("")
print("=== REQUIRED DISCLOSURES ===")
print("  FDA disclaimer    :", "Not evaluated by the Food and Drug Administration" in html)
print("  not a drug        :", "Not a drug and not a treatment" in html)
print("  patch test        :", "Patch test first" in html)
print("  stop-use guidance :", "Stop using it" in html)
print("  broken-skin warn  :", "open, weeping, blistered" in html)
print("  contamination warn:", "it can grow bacteria" in html)
print("  adverse-event line:", "reaction to report" in html)

print("")
print("=== FACTUAL CONSISTENCY WITH LABEL ===")
label = ["Water","Squalane","Glycerin","Shea Butter","Cetearyl Alcohol","Sunflower Lecithin",
         "Ceramide NP","Ceramide AP","Ceramide EOP","Tetrahydrocurcuminoids","Palmitamide MEA",
         "Ectoin","Astaxanthin","Xylitylglucoside","Anhydroxylitol","Tocopherol","Lactic Acid",
         "Xanthan Gum","Phenoxyethanol","Ethylhexylglycerin"]
missing = [i for i in label if i not in html]
print("  ingredients listed:", len(re.findall(r'class="row"', html)), "(label has", len(label), ")")
print("  missing from site :", missing if missing else "none")
print("  'Irish Moss' absent:", "Irish Moss" not in html)
print("  net weight 4 oz   :", "4 oz" in html and "8 oz" not in html)
print("  'THC' abbrev absent:", not re.search(r"\bTHC\b", html))

print("")
print("=== PLACEHOLDERS TO FILL ===")
for m in re.findall(r"REPLACE-WITH-[A-Z-]+", html):
    print("  ", m)
