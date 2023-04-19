### Week two study note (4/16/2023 - 4/22/2023)<!-- omit from toc -->

#### Pipe |
Pipe is used to redirect the output of one command as the input of another command. In the example below, we cat the file and count the number of lines.
```console
┌──[19:56:15]─[0]─[root@almanode1:~/scripts]
└──| cat filegen.sh | wc -l
15
```
