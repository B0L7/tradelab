#ifndef FRAMEWORK_ALERT_MQH
#define FRAMEWORK_ALERT_MQH

#ifdef FOR_OPTIMIZATION

#define ALERT_PUSH( message )

#else

#define ALERT_PUSH( message ) \
	Alert(StringFormat("[%s] - %s", \
					   CURRENT_SYMBOL, \
					   message) )

#endif

#endif