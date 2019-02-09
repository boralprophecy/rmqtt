#' Subscribes to mqtt topics
#'
#' The function \code{mqtt_topic_subscribe} subscribes to mqtt topics
#'
#' @param topic character string, mqtt topic to publish to.
#' 
#' @param message_to_send character string, message to send. Defaults to NULL.
#' 
#' @param intern logical (not NA), indicates whether to capture the output as an R character vector. Defaults to FALSE.
#'
#' @param host  character string,  mqtt host to connect to. Defaults to localhost.
#'
#' @param port  integer, connect to the specified port. Default NULL denotes 1883 for plain MQTT or 8883 for MQTT
#'              over TLS.
#'              
#' @param qos integer : 0 or 1 or 2, quality of service level to use for the message. Defaults to 0.
#'              
#' @param enable.debugging logical (not NA), whether debug messages should be enabled. Default is FALSE.
#' 
#' @param retain_message logical (not NA), whether whether message should be retained. Default is FALSE.
#' 
#' @param send_null_message logical (not NA), whether to send a null (zero length) message. Default is FALSE.
#' 
#' @param username  character string, Provide a username to be used for authenticating with the broker. Defaults
#' 
#'                  to NA which denotes username not provided.
#' 
#' @param password  character string, Provide a password to be used for authenticating with the broker. Using this
#' 
#'                  argument without also specifying a username is invalid. Defaults to NA which denotes password not provided.
#'                  
#' @param clientid character string, id to use for this client. Defaults to NULL, means mosquitto_pub_ appended with
#'                 the process id of the client.
#' 
#'              
#' @examples
#' 
#' #...... publishes message to localhost ......
#'
#' mqtt_topic_publish( topic = 'magic/demo/note5', message_to_send = "Life is beautiful."  )
#' 
#' #.... Stores output as R character vector. Turning it off, just prints the output to console when debugging is enabled ....
#' 
#' mqtt_topic_publish( topic = 'magic/demo/note5', message_to_send = "Life is beautiful.", intern = T, enable.debugging = T  )
#' 
#' #.... Sending message with username and password ....
#' 
#' mqtt_topic_publish( topic = 'magic/demo/note5', message_to_send = "Life is beautiful.", username = 'Soumya', password = 'Boral'  )                   


mqtt_topic_publish = function( topic, message_to_send = NULL, intern = F, host = 'localhost', port = NULL, qos = 0,
                               
                               enable.debugging = F, retain_message = F, send_null_message = F, username = NA,
                               
                               password = NA, clientid = NULL ){
  
  #..... Arguments check ......
  
  if( !is.character( topic ) ){ stop( 'topic must be character string.' ) }
  
  if( ! send_null_message && !is.character( message_to_send ) ){ stop( 'message must be character string.' ) }
  
  if( send_null_message && is.character( message_to_send ) ){ stop( 'Either null message or a message string can be sent at once.' ) }
  
  if( is.na( intern ) || !is.logical( intern ) ){ stop( 'intern must be logical (not NA).' ) }
  
  if( !is.character( host ) ){ stop( 'host must be character string.' ) }
  
  if( !is.null( port ) && round( port ) != port ){ stop( 'port must be either NULL or integer.' ) }
  
  if( round( qos ) != qos || !( qos %in% c( 0, 1, 2 ) ) ){ stop( 'qos must be an integer among 0, 1 or 2.' ) }
  
  if( is.na( enable.debugging ) || !is.logical( enable.debugging ) ){ stop( 'enable.debugging must be logical (not NA).' ) }
  
  if( is.na( retain_message ) || !is.logical( retain_message ) ){ stop( 'retain_message must be logical (not NA).' ) }
  
  if( is.na( send_null_message ) || !is.logical( send_null_message ) ){ stop( 'send_null_message must be logical (not NA).' ) }
  
  if( !is.na( username ) && !is.character( username ) ){ stop( 'username must be character string or NA which means username not provided.' ) }
  
  if( !is.na( password ) && !is.character( password ) ){ stop( 'password must be character string or NA which means password not provided.' ) }
  
  if( is.character( username ) && grepl( ' ', username ) ){ stop( 'username cannot contain spaces.' ) }
  
  if( is.character( password ) && grepl( ' ', password ) ){ stop( 'password cannot contain spaces.' ) }
  
  if( is.na( username ) && is.character( password ) ){ warning( 'Not using password since username not set.' ) }
  
  if( !is.null( clientid ) && !is.character( clientid ) ){ stop( 'clientid must be character string.' ) }
  
  
  
  mqtt_pub_base = ifelse( host == 'localhost', "mosquitto_pub", paste0( "mosquitto_pub -h ", host ) )    #.... adding host
  
  if( !is.null( port ) ){ mqtt_pub_base = paste0( mqtt_pub_base, ' -p ', port ) }    #.... adding port
  
  if( enable.debugging ){ mqtt_pub_base = paste0( mqtt_pub_base, ' -d ' ) }    #...... enabling debug messages
  
  if( retain_message ){ mqtt_pub_base = paste0( mqtt_pub_base, ' -r ' ) }    #...... enabling debug messages
  
  if( !is.na( username ) ){    #..... adding username
    
    mqtt_pub_base = paste0( mqtt_pub_base, ' -u ', username )
    
    if( !is.na( password ) ){ mqtt_pub_base = paste0( mqtt_pub_base, ' -P ', password ) }    #...... adding password
    
  }
  
  if( send_null_message ){
    
    mqtt_pub_base = paste0( mqtt_pub_base, ' -n ' )    #..... sending null message
    
  } else{
    
    mqtt_pub_base = paste0( mqtt_pub_base, ' -m "', message_to_send, '"' )    #..... adding message ... quotes are necessary in case message contains space
    
  }
  
  if( !is.null( clientid ) ){ mqtt_pub_base = paste0( mqtt_pub_base, ' -i "', clientid, '"' ) }    #.... adding clientid
  
  mqtt_pub_base = paste0( mqtt_pub_base, ' -q ', qos )     #..... adding qos
  
  mqtt_pub_command = paste0( mqtt_pub_base, ' -t "', topic, '"' )     #..... adding topic ... quotes are necessary in case topic contains space
  
  system( mqtt_pub_command, intern = intern )
  
}



