---
name: Skill to create a command output as a .png file
description: Execute a command that does not require any input from the terminal to create a .png file with their output, useful for short outputs
---

- Use the script in `informe/util/cap.sh` 
- Example `./cap.sh file-name 'command1' 'command2'`
- It creates a `file-name.png` image showing the execution of the specified shell command and their output.
- Save the images in `informe/src/fig/`, create a properly folder name relative
  to the report content to keep organized the project.
