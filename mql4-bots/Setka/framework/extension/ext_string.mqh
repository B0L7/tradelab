#ifndef FRAMEWORK_EXT_STRING_MQH
#define FRAMEWORK_EXT_STRING_MQH

#define EXT_STRING_EMPTY ""

#define dtos(value) DoubleToString(value, layer_account::digits())
#define ttos(value) TimeToString( value, TIME_DATE | TIME_MINUTES | TIME_SECONDS )
#define itos(value) IntegerToString(value)

#define ext_string_equals( first, second, check_case ) (StringCompare ( first, second, check_case ) == 0)

class ext_string {
public:
	static string replace ( string value, string find, string replaced ) {
		StringReplace ( value, find, replaced );
		return value;
	}

	static double truncate_real_part ( double value, int count ) {
		string buffer = DoubleToString ( value );
		int length = StringLen ( buffer );
		int index_of = StringFind ( buffer, ".", 0 );

		if ( length - index_of + 1 <= count ) {
			return value;
		}

		buffer = StringSubstr ( buffer, 0, index_of + 1 + count );
		return StringToDouble ( buffer );
	}

	static string get_sha256 ( string value ) {
		uchar data[];
		StringToCharArray ( value, data );
		ArrayResize ( data, ArraySize ( data ) - 1 );

		uchar key[1] = {0};

		uchar result[];
		CryptEncode ( CRYPT_HASH_SHA256, data, key, result );

		string resultStr = EXT_STRING_EMPTY;

		for ( int i = 0; i < ArraySize ( result ); i++ ) {
			resultStr += StringFormat ( "%02x", result[i] );
		}

		return resultStr;
	}
};

class str_builder {
private:
	string source;
public:
	str_builder() {
		source = EXT_STRING_EMPTY;
	}

	void append ( string value ) {
		source += value;
	}

	void append_line ( string value ) {
		source += value + "\r\n";
	}

	string to_str() {
		return source;
	}
};

#endif