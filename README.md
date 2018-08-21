# analyze_news
A quick tour of Kafka functionality using Global News


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




