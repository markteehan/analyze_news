# analyze_news
A quick tour of Kafka functionality using Global News


1 - Confluent Platform download/start/configure
a. On Mac - run the script to download files of current news stories:
 1. Open a terminal

2. cd ~/Downloads
 3. Download the script to get the latest news:
b. Download CP
c. Start CP
d. Configure connector kafka-connect-spooldir. talk about connectors.
e. Create the topic. Run any config changes needed (zookeeper for Rest service etc)


2 - Load CSV data to Kafka Use Kafka Connect - dont reinvent wheels
a. Introduce GDELT
b. Introduce connect. To be decided  how best to configure a working kafka-connect-spooldir without requiring maven
c. github: copy this script to pull down todays news. Run it (Mac only?)
c. Consume to check that data is imported. A quick overview of producing, consuming, offsets 
3 - Rest API a universal foundation for microservices
a. explain when the rest api is used, how it works. This is not running SQL, it is returning messages, cursor-style
b. configure CORS for the browser
c. github - download topics.html and run
d. show a D3 animated force diagram that connects news outlets, countries and subjects for the most recent 100-200 news stories
e. show the 3-steps to retrieving data using the RestAPI
4 - Control Center - Schema Registry Its not all cmd line. Coping with change using Schema Registry
a. Schema Registry - show v1.
b. Modify connect to add a new news attribute - SiteURL. 
c. Download and load new data. Observe evolution to schema version 2
d. Load new data (last 15 minutes)
e. refresh force diagram for last 100 news stories to consume news stories for versions 1 and 2
5 - Control Center - kSQL Platforms must also process data - build something deceptively simple using SQL
a. show topics and a quick tour of CP5.0 control center. Show kSQL pane.
b. cut|paste to create table 1: todays trending topics (TT) and current tone.
c. cut|paste to create table 2: for TT#1 show the Sites and Avgtone. Observe how the Avgtone has changed over time
d. You just built an application. 
6 Database vs Kafka Address the database argument - why some scenarios are unsuitable for MySQL
a. Depict and explain Table|Stream Duality using Site and Avgtone
b. Show how a streaming system has tables and streams but databases only have tables
c. Talk about how enterprise workloads are sometimes better for databases, sometime for streaming.
7 Conclude reinforce the implicit points
a. Performance - kafka is fast and layers of kSql require speed. Dont leave an overkill aftertaste.
b.  Resilience - whatever your DR reaquirements are, we can help. From Raspberry Pi to Uber.
c. Competitive - re-examine DWH/DB based systems and see which are a better fit for streaming. 
d.    Exciting - Microservices, Cloud, K8S, DevOps, blah blah
