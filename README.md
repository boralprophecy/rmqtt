# rmqtt - An MQTT client for R

Enable applications to connect to an MQTT broker to publish messages, and to subscribe to topics and receive published messages. It also provides some helper functions to make publishing one off messages to an MQTT server very straightforward. Tools are provided to interoperate with ‘MQTT’ message brokers in R.

## How to use ?

Follow this steps to start using :

1) Download and install mosquitto for your OS ( https://mosquitto.org/download/ )

2) Open console and change to mosquitto installation directory

3) Write **mosquitto -v** in prompt and press enter - This will start the mosquitto broker on local host

4) Install **rmqtt** from CRAN `install.packages("rmqtt")` or from Github `remotes::install_github("boralprophecy/rmqtt")`

5) In R, write `setwd( mosquitto_installation_directory )` to change to mosquitto installation directory

6) Run `mqtt_topic_publish( topic = 'topic1', message_to_send = 'Hello World !' )` to publish the message **Hello World !** to  **topic1** in local host

7) Run `mqtt_topic_subscribe( topic = 'topic2' )` to subscribe to **topic2**


To create an effect of two clients, one publishing and another subscribing, install **MQTT-Lens** ( a chrome extension ). Then you can subscribe in R window and publish message from **MQTT-Lens** to test or vice versa.

Guide to use **MQTT-Lens** : http://www.steves-internet-guide.com/using-mqtt-lens/
