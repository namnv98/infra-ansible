

service:jmx:rmi:///jndi/rmi://171.244.63.246:9999/jmxrmi



```
[Unit]
Description=Apache Kafka Kraft Mode
Documentation=http://kafka.apache.org/documentation.html
After=network.target remote-fs.target
Requires=network.target remote-fs.target


[Service]
Type=simple
User=kafka
Group=sudo
Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64/
Environment="KAFKA_HEAP_OPTS=-Xms4G -Xmx4G"

Environment="JMX_PORT=9999"
Environment="KAFKA_OPTS=-Djava.security.auth.login.config=/data/kafka/config/kraft/kafka_server_jaas.conf \
 -Dcom.sun.management.jmxremote \
 -Dcom.sun.management.jmxremote.authenticate=false \
 -Dcom.sun.management.jmxremote.ssl=false \
 -Dcom.sun.management.jmxremote.local.only=false \
 -Dcom.sun.management.jmxremote.port=9999 \
 -Dcom.sun.management.jmxremote.rmi.port=9999 \
 -Djava.rmi.server.hostname=171.244.63.246"


ExecStart=/data/kafka/bin/kafka-server-start.sh /data/kafka/config/kraft/server.properties
ExecStop=/data/kafka/bin/kafka-server-stop.sh
Restart=on-failure
StandardOutput=append:/data/kafka/logs/kafka.log
StandardError=append:/data/kafka/logs/kafka.log

[Install]
WantedBy=multi-user.target
Alias=kafka-server.service
```


sudo systemctl daemon-reload
sudo systemctl restart kafka
