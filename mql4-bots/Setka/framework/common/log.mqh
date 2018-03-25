#ifndef FRAMEWORK_LOG_MQH
#define FRAMEWORK_LOG_MQH

#ifndef FRAMEWORK_LOCALIZATION_REWRITE
#define LOGGER_MSG_ERROR "E"
#define LOGGER_MSG_INFO "I"
#define LOGGER_MSG_DEBUG "D"
#define LOGGER_MSG_ALERT "A"
#endif

#ifdef FOR_OPTIMIZATION
#define log_print(message)
#define log_print_v(verb, message)
#define log_print_k(key, message)
#define log_print_vk(verb, key, message)
#define log_error(message)
#define log_error_k(message)
#define log_info(message)
#define log_info_k(message)
#define log_info_k2(key, message)
#define log_info_ex(message)
#define log_info_ex_k(message)
#define log_debug(message)
#define log_debug_k(message)
#define log_alert(message)
#define log_alert_k(message)
#define log_set_msg_key(key)
#else
#define log_print(message) log_print_without_dublicate ( message )
#define log_print_v(verb, message) if ( LogVerbose >= verb ) log_print( message )
#define log_print_k(key, message) log_print( StringFormat ( "%s - %s", key, message ) )
#define log_print_vk(verb, key, message) if ( LogVerbose >= verb ) log_print_k(key, message)
#define log_error(message) log_print_vk ( 1, StringFormat ( "[%s]", LOGGER_MSG_ERROR ), message )
#define log_error_k(key, message) log_print_vk ( 1, StringFormat ( "[%s]%s", SRC_LOG_ERROR, key ), message )
#define log_info(message) log_print_vk( 2, StringFormat ( "[%s]", LOGGER_MSG_INFO ), message )

#define log_info_k(message) log_print_vk ( 2, StringFormat ( "[%s]%s", LOGGER_MSG_INFO, log_current_msg_key ), message )
#define log_info_k2(key, message) log_print_vk ( 2, StringFormat ( "[%s]%s[%s]", LOGGER_MSG_INFO, log_current_msg_key, key ), message )

#define log_info_ex(message) log_print_vk ( 3, StringFormat ( "[%s]", LOGGER_MSG_INFO ), message )
#define log_info_ex_k(message) log_print_vk ( 3, StringFormat ( "[%s]%s", LOGGER_MSG_INFO, log_current_msg_key ), message )
#define log_debug(message) log_print_vk ( 4, StringFormat ( "[%s]", LOGGER_MSG_DEBUG ), message )
#define log_debug_k(message) log_print_vk ( 4, StringFormat ( "[%s]%s", LOGGER_MSG_DEBUG, log_current_msg_key ), message )

#define log_alert(message) \
	if( LogVerbose >= 1 ){ \
		string saved_message = StringFormat( "[%s] - %s", LOGGER_MSG_ALERT, message ); \
		ALERT_PUSH( saved_message ); \
		log_print( saved_message ); \
	}

#define log_alert_k(message) \
	if( LogVerbose >= 1 ){ \
		string saved_message = StringFormat( "%s[%s] - %s", log_current_msg_key, LOGGER_MSG_ALERT, message ); \
		ALERT_PUSH( saved_message ); \
		log_print( saved_message ); \
	}

#define log_set_msg_key(key) log_current_msg_key = key

string log_current_msg_key;
void log_print_without_dublicate ( string msg )
{
	static string double_last_msg;
	static string last_msg;

	if ( !ext_string_equals ( last_msg, msg, false )
			&& !ext_string_equals ( double_last_msg, msg, false ) ) {
		double_last_msg = last_msg;
		last_msg = msg;

		Print ( msg );
	}
}
#endif

#endif