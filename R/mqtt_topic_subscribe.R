#' Subscribes to mqtt topics
#'
#' The function \code{mqtt_topic_subscribe} subscribes to mqtt topics
#'
#' @param topic character string, mqtt topic to subscribe to.
#'
#' @param intern logical (not NA), indicates whether to capture the output as an R character vector. Defaults to FALSE.
#'
#' @param host  character string,  mqtt host to connect to. Defaults to localhost.
#'
#' @param port  integer, connect to the specified port. Default NULL denotes 1883 for plain MQTT or 8883 for MQTT
#'              over TLS.
#'
#' @param num.messages non negative integer, disconnect and exit the program immediately after the given count of
#'                     messages have been received. Defaults to 0, means it continues to collect messages until
#'                     stopped using Ctrl + C.
#'
#' @param timeout non negative integer, specifies a timeout in seconds how long to process incoming MQTT messages.
#'                Defaults to 0, means no timeout.
#'
#' @param verbose logical (not NA), print received messages verbosely. With this argument, messages will be printed as
#'                "topic payload". When this argument is not given, the messages are printed as "payload". Default
#'                is FALSE.
#'
#' @param append.eol logical (not NA), whether to add an end of line character when printing / capturing ( see intern )
#'                   the payload. Defaults to TRUE.
#'
#' @param enable.debugging logical (not NA), whether debug messages should be enabled. Default is FALSE.
#'
#' @param clientid character string, id to use for this client. Defaults to NULL, means mosquitto_sub_ appended with
#'                 the process id of the client. Cannot be used at the same time as the clientid.prefix argument.
#'
#' @param keepalive positive integer, umber of seconds between sending PING commands to the broker for the purposes of
#'                  informing it we are still connected and functioning. Defaults to 60 seconds.
#'
#' @details If both num.messages and timeout is supplied, disconnection happens whichever condition is fulfilled first.
#' append.eol allows streaming of payload data from multiple messages directly to another application unmodified.
#' Only really makes sense when not using -v.
#'
#' @examples
#'
#' mqtt_topic_subscribe( topic = 'magicblock/demo_user/temperature2', host = 'test.mosquitto.org' )
#'
#' #.... Stores output as R character vector. Turning it off, just prints the output to console ....
#'
#' mqtt_topic_subscribe( topic = 'magicblock/demo_user/temperature2', intern = T, host = 'test.mosquitto.org' )
#'
#' #.... Disconnects after receiving 5 messages ....
#'
#' mqtt_topic_subscribe( topic = 'magicblock/demo_user/temperature2', host = 'test.mosquitto.org', num.messages = 5 )
#'
#' #.... Disconnects after 6 seconds of starting connection with broker, also showing verbose ....
#'
#' mqtt_topic_subscribe( topic = 'magicblock/demo_user/temperature2', host = 'test.mosquitto.org', timeout = 6, verbose = T )
#'
#' #.... End of line character is not added after messages are received ....
#'
#' mqtt_topic_subscribe( topic = 'magicblock/demo_user/temperature2', host = 'test.mosquitto.org', num.messages = 5, append.eol = F )
#'
#' #.... Enabling debug messages .....
#'
#' mqtt_topic_subscribe( topic = 'magicblock/demo_user/temperature2', host = 'test.mosquitto.org', num.messages = 5, enable.debugging = T )




mqtt_topic_subscribe = function( topic, intern = F, host = 'localhost', port = NULL, num.messages = 0, timeout = 0, verbose = F,

                                 append.eol = T, enable.debugging = F, clientid = NULL, keepalive = 60 ){

  #..... Arguments check ......

  if( !is.character( topic ) ){ stop( 'topic must be character string.' ) }

  if( is.na( intern ) || !is.logical( intern ) ){ stop( 'intern must be logical (not NA).' ) }

  if( !is.character( host ) ){ stop( 'host must be character string.' ) }

  if( !is.null( port ) && round( port ) != port ){ stop( 'port must be either NULL or integer.' ) }

  if( round( num.messages ) != num.messages || num.messages < 0 ){ stop( 'num.messages must be non negative integer.' ) }

  if( round( timeout ) != timeout || timeout < 0 ){ stop( 'timeout must be non negative integer.' ) }

  if( is.na( verbose ) || !is.logical( verbose ) ){ stop( 'verbose must be logical (not NA).' ) }

  if( is.na( append.eol ) || !is.logical( append.eol ) ){ stop( 'append.eol must be logical (not NA).' ) }

  if( !is.null( clientid ) && !is.character( clientid ) ){ stop( 'clientid must be character string.' ) }

  if( round( keepalive ) != keepalive || keepalive <= 0 ){ stop( 'keepalive must be positive integer.' ) }


  mqtt_sub_base = ifelse( host == 'localhost', "mosquitto_sub", paste0( "mosquitto_sub -h ", host ) )    #.... adding host

  if( !is.null( port ) ){ mqtt_sub_base = paste0( mqtt_sub_base, ' -p ', port ) }    #.... adding port

  if( num.messages > 0 ){ mqtt_sub_base = paste0( mqtt_sub_base, ' -C ', num.messages ) }    #.... adding number of messages to receive

  if( timeout > 0 ){ mqtt_sub_base = paste0( mqtt_sub_base, ' -W ', timeout ) }    #.... adding timeout in seconds

  if( verbose ){ mqtt_sub_base = paste0( mqtt_sub_base, ' -v ' ) }    #..... adding vebose capability

  if( !append.eol ){ mqtt_sub_base = paste0( mqtt_sub_base, ' -N ' ) }    #...... disabling appending end of line character

  if( enable.debugging ){ mqtt_sub_base = paste0( mqtt_sub_base, ' -d ' ) }    #...... enabling debug messages

  if( !is.null( clientid ) ){ mqtt_sub_base = paste0( mqtt_sub_base, ' -i ', clientid ) }    #.... adding clientid

  mqtt_sub_base = paste0( mqtt_sub_base, ' -k ', keepalive )    #..... adding keepalive capability

  mqtt_sub_command = paste0( mqtt_sub_base, ' -t "', topic, '"' )     #..... adding topic

  system( mqtt_sub_command, intern = intern )

}
