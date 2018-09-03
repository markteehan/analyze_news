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
2 - Download and install Confluent Enterprise
Open https://www.confluent.io/download/ and click Download to get the latest Confluent Enterprise
Select ".tar.gz" for the Desired Download Format, and enter your email address.
The download size is ~300MB.

3 - Unpack & Start Confluent Open Source. No changes will be made to your machine. It can be removed after the workshop.
```
cd ~/Downloads
F=`ls -ltr1 |grep confluent|grep gz|tail -1`
echo;echo;echo "About to unpack and start using $F."
echo "Hit return to continue, or <CTRL-C> to abort..please wait.."
sleep 2
tar -mzxvf $F
```

4-Download the connector for Kafka Spooldir (source is  https://github.com/jcustenborder/kafka-connect-spooldir )
Connectors are open source, not executable, so normally each one must be compiled using Maven.
To save time, download a connector pre-compiled for Mac OS (40MB) by running these commands:

```
cd ~/Downloads
D=https://www.dropbox.com/s/o9p12fggk42bvr3
F=news_events_tarfile.tar
wget $D/$F
rm -rf gdelt_tarfile
tar -mzxvf $F
F=`ls -d1r */|grep confluent|tail -1`
cp     gdelt_tarfile/restart_confluent.sh           ~/Downloads/restart_confluent.sh
cp     gdelt_tarfile/getnews.sh                     ~/Downloads/getnews.sh
cp     gdelt_tarfile/quickstart-spooldir.properties ~/Downloads/$F/etc/kafka-connect-spooldir/quickstart-spooldir.properties
cp -R  gdelt_tarfile/kafka-connect-spooldir         ~/Downloads/$F/share/java/kafka-connect-spooldir
rm     news_events_tarfile.tar
rm -rf gdelt_tarfile
```

The connecter is now installed and configured to automatically load new news events into Kafka.


5-Start Confluent Enterprise
```
cd ~/Downloads
F=`ls -d1r */|grep confluent|tail -1`
export PATH=~/Downloads/$F/bin:$PATH
sh restart_confluent.sh
confluent stop connect
```

Create a topic to store News Events.
#Change: this must be a compacted topic as eventid must be unique for joins to functions.
```
kafka-topics --create --zookeeper localhost:2181 --topic GDELT_EVENT --partitions 8 --replication-factor 1 --config cleanup.policy=compact

WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic "GDELT_EVENT".
```


Start the Spooldir Connector Standalone
```
D=`ls -d1r */|grep confluent|tail -1`; cd ~/Downloads/$D
connect-standalone etc/kafka/connect-standalone.properties ~/Downloads/kafka-connect-spooldir/config/GDELT.EVENT.properties
```

Get the latest news stories. Repeat this command on every quarter hour to get the latest news.
```
cd ~/Downloads
sh getnews.sh
```

The Kafka-Spooldir connecter will automatically load new News Event files into the kafka topic.
We can check this by consuming the News Events:
In a new terminal window, run this
```
cd ~/Downloads; F=`ls -d1r */|grep confluent|tail -1` ;cd $F; export PATH=~/Downloads/$F/bin:$PATH
kafka-avro-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic GDELT_EVENT 
```

After displaying the News Events, press Control-C to stop the consumer:
```
^C
...
Processed a total of 1544 messages
```

Open C3:
http://localhost:9021/

.. inspect topics etc
.. click kSQL

In the Query editor create a stream over the topic. Column names are not specified because of the scheama registry.
```
CREATE STREAM GDELT_STREAM  WITH (kafka_topic='GDELT_EVENT', value_format='AVRO');
```
Inspect in Control Center - this is a stream, but not a new topic.

Create five new streams to filter news by tone: from very negative to very positive:
```
CREATE STREAM S_VERYNEG AS SELECT * FROM GDELT_STREAM WHERE AVGTONE < -10;
CREATE STREAM S_NEG     AS SELECT * FROM GDELT_STREAM WHERE AVGTONE < -0.5  AND AVGTONE > -10;
CREATE STREAM S_NEU     AS SELECT * FROM GDELT_STREAM WHERE AVGTONE > -0.5  AND AVGTONE < 0.5;
CREATE STREAM S_POS     AS SELECT * FROM GDELT_STREAM WHERE AVGTONE >  0.5  AND AVGTONE < 10;
CREATE STREAM S_VERPOS  AS SELECT * FROM GDELT_STREAM WHERE AVGTONE >  10;
```
We have started building a streaming application. Filters are metadata - they do not duplicate the messages.
Aggregate the data to rank the countries where wach category of news is being reports.

```
CREATE 














61 topic columns to a subset of columns that we are interested in.
Add parameter "auto.offset.reset=earliest" 
```
CREATE STREAM GDELT_STREAM (EventId bigint, Day bigint, MonthYear bigint, Actor1Code varchar, Actor1Name varchar, Actor1CountryCode varchar, Actor1Type1Code varchar, Actor2Code varchar, Actor2Name varchar, Actor2CountryCode varchar, Actor2Type1Code varchar, AvgTone double, SourceUrl varchar)
WITH (kafka_topic='GDELT_EVENT', value_format='AVRO');
```
Click Streams | ... | Query | Run Query to see the news events





Next :
1, open kSQL and create the stream over the topic. Do an inspect data
2, In kSQL create an aggregated stream over the stream. Load more data. Inspect the data.
3, Point: this is so muuch easier than implementing SQL Contexts using Spark Streaming.


Phase II:
1, wrap the SQL so that it can return JSON
2, Return news query results to a D3 sankey diagram in chrome
3, Show that the rest API can also be used to run SQL to retrieve data results (not just continuous queries).



===================
Notes


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

Consume the News Events using Kafka Rest
We need to start a webserver

confluent load CsvSpoolDir -d /Users/teehan/Downloads/confluent-5.0.0/etc/kafka-connect-spooldir/quickstart-spooldir.properties

the tarfile contains:
     file restart_confluent.sh                                    ==> Downloads
     file getnews.sh                                              ==> Downloads     
     file kafka-connect-spooldir/quickstart-spooldir.properties   ==> confluent-5.0.0/etc
directory kafka-connect-spooldir                                  ==> confluent-5.0.0/share/java






