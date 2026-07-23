---
name: create a mermaid graph
description: Script to use mmdc to create a mermaid file in pdf, useful for the laboratory report
---

You can check the skill's script folder to create a mermaid graph.

Save the mermaid code in `/informe/src/fig/` relative to the git root directory
and create a properly folder inside it to maintain the code organized
(considering the content report structure).

Script usage:

```bash
# output: a file.pdf graph, ready to be used in the report
.agent/skills/mermaid/scripts/create_mmdc_graph.sh file.mmdc
```
