clusters = {}
with open("all.fsa.clstr") as f:
     toks = (l.split(maxsplit=2) for l in f)
     active = ""
     for l in toks:
             if l[0] == '>Cluster':
                     active = l[1]
                     clusters[active] = []
                     continue
             clusters[active].append(l)

print(f"of {len(clusters)} clusters:")
known = list(c for c in clusters if [g for g in map(lambda g: g[2], clusters[c]) if g.startswith('>MEG_')])
unknown = list(c for c in clusters if not [g for g in map(lambda g: g[2], clusters[c]) if g.startswith('>MEG_')])
print(f"{len(known)} in DB already")
print(f"{len(unknown)} new genes")

unknown_clstrs = {i: clusters[i] for i in unknown}

matched = {}
with open("update.fsa.clstr") as f:
     toks = (l.split(maxsplit=2) for l in f)
     active = ""
     for l in toks:
             if l[0] == '>Cluster':
                     active = l[1]
                     matched[active] = []
                     continue
             matched[active].append(l)

def trim_header(h):
     if h.endswith("... *\n"): return h[:-6] + "\n"
     return h[:h.find("... at ")] + "\n"

candidates = {c: set(trim_header(g[2]) for g in matched[c]) for c in matched}
successes = set()
for new_gene in (set(trim_header(g[2]) for g in c) for c in unknown_clstrs.values()):
     for c in candidates:
          if candidates[c].intersection(new_gene):
               successes.add(c)

import csv

with open("matches.tsv", "w") as f:
     w = csv.writer(f, delimiter="\t")
     w.writerow(("matched cluster", "sequence", "", "header"))
     for s in successes:
          for m in matched[s]:
               w.writerow([s] + m)
