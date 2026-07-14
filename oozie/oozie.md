# Big Data Ecosystem

## Oozie with mapreduce and Hive warehouse

- I devoted a substantial amount of time to configuring the required files.![](local-images/2ecd8d6498c97260b44974b7a4b4f97f655fcbf3.png)

- The commands used to manage the jobs are relatively slow while the jobs are in execution.

- The commands I employed most frequently are:

```bash
hdfs dfs -put -f oozie_wf/ /education/$GROUP/$USER
oozie job -run -config oozie_wf/job.properties -oozie http://oozie-1.au.adaltas.cloud:11000/oozie
oozie job -info 0000310-250821151231353-oozie-oozi-W -oozie http://oozie-1.au.adaltas.cloud:11000/oozie
```



- I repeatedly edited **workflow.xml** and the associated HQL scripts.![](local-images/98c39d35acc0f8f2260a685bfdcf9c1047582f62.png)

![](local-images/a0e68f3abe655469e48bea095412797cfe23a6dd.png)

- All the source files are located in the ⁠oozie_wf directory.

### Oozie word count, create a table and query it with HQL

- The complete code for this part can be found in the ⁠oozie_wf2 folder.

- To launch the Oozie job:

```bash
oozie job -run -config oozie_wf2/job.properties -oozie http://oozie-1.au.adaltas.cloud:11000/oozie
```

- To retrieve the status of a running Oozie job:

```bash
oozie job -info 0000431-250821151231353-oozie-oozi-W -oozie http://oozie-1.au.adaltas.cloud:11000/oozie
```

![](local-images/29e1147e0e3adf358bc63d1cc7c74da63c492fea.png)

![](local-images/71a10e4152c0e6cc31aa1ff26a725310714194c4.png)

![](local-images/775f035d79e13bb4b01d747f30de4e6cb99dc147.png)
