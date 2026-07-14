# Big Data Ecosystem

## HDFS and YARN interaction

**Before : setup env**

```bash
echo "export GROUP=1" >> ~/.bashrc
source .bashrc
```

### Create HDFS workspace and upload files to HDFS

```bash
hadoop fs -mkdir education
hadoop fs -mkdir education/$GROUP
hadoop fs -mkdir education/$GROUP/$USER
hadoop fs -mkdir education/$GROUP/$USER/lab1
hadoop fs -mkdir education/$GROUP/$USER/lab2
cd education/$GROUP/$USER
vim lab1/sentence.txt
    "I discover the tremendous Hadoop."
hadoop fs -put sentence.txt education/$GROUP/$USER/lab1/
hadoop fs -cp education/$GROUP/$USER/lab1/sentence.txt education/$GROUP/$USER/lab1/sentence.txt education/$GROUP/$USER/lab2/
hdfs fsck education/1/login/lab1/sentence.txt
```

<img title="" src="local-images/305a434026dcf201fb4837e0b9e22882b7b9ce38.png" alt="" data-align="inline">

## Submit an application in YARN

```bash
yarn jar /usr/hdp/3.1.0.0-78/hadoop-mapreduce/hadoop-mapreduce-examples-3.1.1.3.1.0.0-78.jar pi 6 100000000
yarn app -list
```

![](local-images/014a82ed007fb9fc21b2119ed9a7afac5d74972e.png)

![](local-images/9cd2ba327a4c96cd940ff677d23c71dffb0f21cf.png)

![](local-images/9cd2ba327a4c96cd940ff677d23c71dffb0f21cf.png)

## WordCount example application

```bash
## 3
hadoop fs -ls education/1/login/lab2
yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples-3.1.1.3.1.0.0-78.jar wordcount education/$GROUP/$USER/lab2 education/$GROUP/$USER/lab2/output-moby-dick
```

![](local-images/fbd1d0828b551947a3e8dc6fb044d6707f2f8809.png)

## Setting up password-less SSH & Kerberos

```bash
## 4
ls -al ~/.ssh/id_*.pub
ssh-keygen -t ed25519 -C "email"
ls ~/.ssh/id_*

ssh-copy-id login@node.au.adaltas.cloud
ssh login@node.au.adaltas.cloud

vim /etc/krb5.conf
kinit login
```

![](local-images/9293dc31d5443e920ab247bcbab952fb7c13b673.png)

## Accessing Hadoop Web UIs using Kerberos

![](local-images/d13ee03214ac64ee00d190ed72b31187ffcfcd84.png)

```bash
ssh login@node.au.adaltas.cloud
yarn jar /usr/hdp/3.1.0.0-78/hadoop-mapreduce/hadoop-mapreduce-examples-3.1.1.3.1.0.0-78.jar pi 6 100000000
```

![](local-images/2fc7a2aae5aa7bcd9965a8564a3e37ef6c745b68.png)

![](local-images/18c967e1408a76eb556faac98934ca87e4134226.png)
