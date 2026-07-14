# Big Data Ecosystem

## The MapReduce Framework

### Run a Python MapReduce word count job using Hadoop Streaming

I ran the job by specifying hadoop-streaming.jar because mapred didn't work :

```bash
hadoop jar /usr/hdp/3.1.0.0-78/hadoop-mapreduce/hadoop-streaming.jar   -D mapreduce.job.reduces=2   -files word_count/mapper.py,word_count/reducer.py   -input /education/$GROUP/resources/lab3/mapred-input   -output /education/$GROUP/$USER/lab3/word-count   -mapper "python3 mapper.py" -reducer "python3 reducer.py"
```

Here is the result of this part, word-count.

![](local-images/c9a06be7def2d3b8cc901bb345fb849e822a35dc.png)

Design a MapReduce job to get the most frequent word

### Design a MapReduce job to get the most frequent word

mapper.py : 

```python
#!/usr/bin/env python3
import sys

for line in sys.stdin:
    line = line.strip()
    if line:
        # Input:  word\tcount
        # Output: freq\tword\tcount (constant key forces single reducer)
        print("freq\t{}".format(line))
```

reducer.py :

```python
#!/usr/bin/env python3
import sys

max_word = None
max_count = 0

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    # Input: freq\tword\tcount
    parts = line.split('\t')
    if len(parts) == 3:
        word = parts[1]
        try:
            count = int(parts[2])
            if count > max_count:
                max_count = count
                max_word = word
        except ValueError:
            continue

if max_word:
    print("{}\t{}".format(max_word, max_count))
```

### Write the most_frequent MapReduce job

I ran the new job with this command.

```bash
hadoop jar /usr/hdp/3.1.0.0-78/hadoop-mapreduce/hadoop-streaming.jar -D stream.non.zero.exit.is.failure=false -files most_frequent/mapper.py,most_frequent/reducer.py -input /education/$GROUP/$USER/lab3/word-count -output /education/$GROUP/$USER/lab3/most-frequent -mapper "python3 mapper.py" -reducer "python3 reducer.py"
```

Here you can see the result.

![](local-images/1925932a4e9e3b321967aa0497a8419b5c3af40b.png)
