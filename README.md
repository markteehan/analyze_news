# analyze_news
A quick tour of Kafka functionality using Global News

Troubleshooting:
Pre-requisites:
1. this should work on any mac. If it doesnt then check:
 - Does you hostname resolve to "localhost" ok?
 - Is kafka/zookeeper already running? Ports 2181, 9092 etc should be free
 - Your Downloads directory should be writable and have a few hundred MB of free space
 
 Troubleshooting - reset
 ```
 confluent stop
 confluent start
 confluent stop kafka-rest
 ```
 

1 - Download the script to get the latest new events:
 1. Open a terminal
```
cd ~/Downloads
wget https://raw.githubusercontent.com/markteehan/analyze_news/master/getnews.sh
```
2 - Download and install Confluent Open Source
Open https://www.confluent.io/product/confluent-open-source/ and click Download to get the latest Confluent Open Source
Select ".tar.gz" for the Desired Download Format, and enter your email address.
The download size is ~300MB.

3 - Unpack & Start Confluent Open Source. No changes will be made to your machine. It can be removed after the workshop.
```
cd ~/Downloads
F=`ls -ltR1  confluent-oss*|tail -1`
echo;echo;echo "About to unpack and start using $F."
echo "Hit return to continue, or <CTRL-C> to abort" ; read continue_or_not
tar -mzxvf $F
D=`ls -tr |grep confluent|grep -v tar|tail -1`
cd $D
```

4-Download the connector for Kafka Spooldir from https://github.com/jcustenborder/kafka-connect-spooldir
Connectors are open source, not executable, so normally each one must be compiled using Maven.
To save time, download a connector pre-compiled for Mac OS (40MB) by running these commands:

```
cd ~/Downloads
D=https://www.dropbox.com/s/h36fengpfd8ikmd/
F=kafka-connect-spooldir.tar.gz
wget $D/$F
tar -mzxvf $F
```

5-Start Confluent Open Source
```
cd ~/Downloads
F=`ls -d1r */|grep confluent|tail -1`
cd $F
export PATH=$F/bin:$PATH
```

Check the status - all services should be down:
```
$ confluent status
This CLI is intended for development only, not for production
https://docs.confluent.io/current/cli/index.html
control-center is [DOWN]
ksql-server is [DOWN]
connect is [DOWN]
kafka-rest is [DOWN]
schema-registry is [DOWN]
kafka is [DOWN]
zookeeper is [DOWN]
```

Start Confluent:
```
$ confluent start
This CLI is intended for development only, not for production
https://docs.confluent.io/current/cli/index.html

Using CONFLUENT_CURRENT: /var/folders/2q/94rs_ths71g_qg5ndjd4l1w00000gn/T/confluent.bOR1wUdk
zookeeper is [UP]
kafka is [UP]
schema-registry is [UP]
kafka-rest is [UP]
connect is [UP]
ksql-server is [UP]
control-center is [UP]
```

Create a topic to store News Events
```
bin/kafka-topics --create --zookeeper localhost:2181 --topic GDELT_EVENT --partitions 8 --replication-factor 1
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic "GDELT_EVENT".
```

Start the Spooldir connector, which will "produce" the News Events into the Topic.
Once the connector has started, open a new terminal, and leave this session running
```
cd ~/Downloads
sh start_spopoldir_connector.sh


[2018-08-21 13:25:53,763] INFO Searching for file in ... gdelt_15mins 
[2018-08-21 13:25:53,765] INFO Found 1 file(s) to process 
[2018-08-21 13:25:53,772] INFO Opening /Users/teehan/Downloads/gdelt_15mins/20180820091500.export.csv 
...
etc
```

If the News Events were successfully produced to Kafka, then we should be able to consume them.
In a new terminal window, run this
```
cd ~/Downloads; F=`ls -d1r */|grep confluent|tail -1` ;cd $F; export PATH=$F/bin:$PATH
kafka-avro-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic GDELT_EVENT 
```

After displaying the News Events, press Control-C to stop the consumer:
```
^C
...
Processed a total of 1544 messages
```

