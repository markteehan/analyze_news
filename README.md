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

4-Configure the connector for Kafka Spooldir from https://github.com/jcustenborder/kafka-connect-spooldir


