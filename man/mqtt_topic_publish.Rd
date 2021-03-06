% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mqtt_topic_publish.R
\name{mqtt_topic_publish}
\alias{mqtt_topic_publish}
\title{Publishes to mqtt topics}
\usage{
mqtt_topic_publish(
  topic,
  message_to_send = NULL,
  intern = F,
  host = "localhost",
  port = NULL,
  qos = 0,
  enable.debugging = F,
  retain_message = F,
  send_null_message = F,
  username = NA,
  password = NA,
  clientid = NULL
)
}
\arguments{
\item{topic}{character string, mqtt topic to publish to.}

\item{message_to_send}{character string, message to send. Defaults to NULL.}

\item{intern}{logical (not NA), indicates whether to capture the output as an R character vector. Defaults to FALSE.}

\item{host}{character string,  mqtt host to connect to. Defaults to localhost.}

\item{port}{integer, connect to the specified port. Default NULL denotes 1883 for plain MQTT or 8883 for MQTT
over TLS.}

\item{qos}{integer : 0 or 1 or 2, quality of service level to use for the message. Defaults to 0.}

\item{enable.debugging}{logical (not NA), whether debug messages should be enabled. Default is FALSE.}

\item{retain_message}{logical (not NA), whether whether message should be retained. Default is FALSE.}

\item{send_null_message}{logical (not NA), whether to send a null (zero length) message. Default is FALSE.}

\item{username}{character string, Provide a username to be used for authenticating with the broker. Defaults

                 to NA which denotes username not provided.}

\item{password}{character string, Provide a password to be used for authenticating with the broker. Using this

                 argument without also specifying a username is invalid. Defaults to NA which denotes password not provided.}

\item{clientid}{character string, id to use for this client. Defaults to NULL, means mosquitto_pub_ appended with
the process id of the client.}
}
\description{
The function \code{mqtt_topic_publish} publishes messages to mqtt topics
}
\examples{

#...... publishes message to localhost ......

\donttest{
mqtt_topic_publish( topic = 'magic/demo/note5', message_to_send = "Life is beautiful."  )
}

#.... Stores output as R character vector. Turning it off, just prints the output to console
# when debugging is enabled ....

\donttest{
mqtt_topic_publish( topic = 'magic/demo/note5', message_to_send = "Life is beautiful.", intern = T,
enable.debugging = T )
}

#.... Sending message with username and password ....

\donttest{
mqtt_topic_publish( topic = 'magic/demo/note5', message_to_send = "Life is beautiful.",
username = 'Soumya', password = 'Boral' )
}

}
