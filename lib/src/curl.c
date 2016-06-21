#include <stdlib.h>
#include <string.h>

#include <curl/curl.h>
#include <curl/easy.h>
#include <curl/curlbuild.h>
#include <neko.h>

#define STRINGIFY(x) #x

#define val_match_or_fail(v, t) if(!val_is_##t(v)) { failure("Excepted "#t" in `"__FILE__"' at line "STRINGIFY(__LINE__)"."); }

DEFINE_KIND(k_curl_handle);
DEFINE_KIND(k_curl_share);

typedef enum {
    CALLBACK_WRITE = 0,
    CALLBACK_READ,
    CALLBACK_HEADER,
    CALLBACK_PROGRESS,
    CALLBACK_DEBUG,
    CALLBACK_LAST
} hxcurl_callback_code;

typedef struct {
	CURL *curl;
	struct curl_slist *headers;

	// char *memory;
	// size_t size;
	buffer b;

	struct curl_httppost *formpost;
	struct curl_httppost *lastptr;

	value write_cb;
    value callback[CALLBACK_LAST];

    /* copy of error buffer var for caller*/
    char errbuf[CURL_ERROR_SIZE+1];

} hxcurl_handle;


// *******************************************
void setOptFormField( value v, field f, void *_form )
{
	hxcurl_handle *handle;
	handle = (hxcurl_handle *)_form;

	if (val_is_string(v))
	{
		char *s = val_string(v);
		if (*s != '@')
		{
			curl_formadd(
				 &(handle->formpost), &(handle->lastptr)
				,CURLFORM_COPYNAME, val_string(val_field_name(f))
				,CURLFORM_COPYCONTENTS, s
				,CURLFORM_END
			);
		}
		else
		{
			curl_formadd(
				 &(handle->formpost), &(handle->lastptr)
				,CURLFORM_COPYNAME, val_string(val_field_name(f))
				,CURLFORM_FILE, s + 1
				,CURLFORM_END
			);
		}
	}
}

size_t writeMemoryCallback( void *contents, size_t size, size_t nmemb, void *userp )
{
	size_t realsize = size * nmemb;

	hxcurl_handle *handle;
	handle = (hxcurl_handle *)userp;

	buffer_append_sub(handle->b, contents, realsize);
	/*
	handle->memory = (char *)realloc(handle->memory, handle->size + realsize + 1);
	if (handle->memory == NULL)
	{
		// out of memory!
		val_throw(alloc_string("not enough memory (realloc returned NULL)"));
	}

	memcpy(&(handle->memory[handle->size]), contents, realsize);
	handle->size += realsize;
	handle->memory[handle->size] = 0;
	*/

	return realsize;
}
// *******************************************


// *******************************************
/* Write callback for calling a neko callback */
size_t write_callback_func( void *contents, size_t size, size_t nmemb, void *stream )
{
	size_t realsize = size * nmemb;

    hxcurl_handle *handle;
    handle = (hxcurl_handle *)stream;

	value fn = handle->callback[CALLBACK_WRITE];
	if( fn != NULL && val_is_function(fn) )
	{
		val_call1(fn, copy_string(contents, realsize));
	}

    return realsize;
}

/* header callback for calling a neko callback */
size_t header_callback_func( void *contents, size_t size, size_t nmemb, void *stream )
{
	size_t realsize = size * nmemb;

    hxcurl_handle *handle;
    handle = (hxcurl_handle *)stream;

	value fn = handle->callback[CALLBACK_HEADER];
	if( fn != NULL && val_is_function(fn) )
	{
		val_call1(fn, copy_string(contents, realsize));
	}

	return realsize;
}

/* read callback for calling a neko callback */
size_t read_callback_func( void *ptr, size_t size, size_t nmemb, void *stream )
{
    hxcurl_handle *handle;
    handle = (hxcurl_handle *)stream;

    value s;
    size_t maxlen;
    size_t len;

	s = alloc_string("");
    maxlen = size*nmemb;

	value fn = handle->callback[CALLBACK_READ];
	if( fn != NULL && val_is_function(fn) )
	{
		s = val_call1(fn, alloc_int(maxlen));
	}

    len = val_strlen(s);
    if( len < 1 )
    {
    	return 0;
    }

    len = (len<maxlen ? len : maxlen);

    memcpy(ptr, val_string(s), (size_t)len);

	return (size_t) (len/size);
}

/* Progress callback for calling a perl callback */
int progress_callback_func( void *clientp, double dltotal, double dlnow, double ultotal, double ulnow )
{
    hxcurl_handle *handle;
    handle = (hxcurl_handle *)clientp;

    value args[4] = { alloc_int(dltotal), alloc_int(dlnow), alloc_int(ultotal), alloc_int(ulnow) };

	value fn = handle->callback[CALLBACK_PROGRESS];
	if( fn != NULL && val_is_function(fn) )
	{
		val_callN(fn, args, 4);
	}

	return CURLE_OK;
}

/* debug callback for calling a neko callback */
size_t debug_callback_func( CURL* curl, int type, char *debug_data, size_t size, void *stream )
{
    hxcurl_handle *handle;
    handle = (hxcurl_handle *)stream;

	value fn = handle->callback[CALLBACK_DEBUG];
	if( fn != NULL && val_is_function(fn) )
	{
		val_call2(fn, alloc_int(type), alloc_string(debug_data));
	}

    return CURLE_OK;
}
// *******************************************

value hxcurl_escape( value curl_handle, value str )
{
	val_check_kind(curl_handle, k_curl_handle);
	val_check(str, string);

	hxcurl_handle *handle = val_data(curl_handle);

	return alloc_string(curl_easy_escape(handle->curl, val_string(str), val_strlen(str)));
}
DEFINE_PRIM(hxcurl_escape, 2);

value hxcurl_error(value curl_handle)
{
	val_check_kind(curl_handle, k_curl_handle);

	hxcurl_handle *handle = val_data(curl_handle);

	return alloc_string(handle->errbuf);
}
DEFINE_PRIM(hxcurl_error, 1);

value hxcurl_init( )
{
	//int res;

	value curl_handle = alloc_abstract(k_curl_handle, alloc(sizeof(hxcurl_handle)));
	hxcurl_handle *handle = val_data(curl_handle);

	handle->curl = curl_easy_init();
	handle->write_cb = alloc_bool(false);
	handle->headers = NULL;
	handle->formpost = NULL;
	handle->lastptr = NULL;

	/* we always collect this, in case it's wanted */
	curl_easy_setopt(handle->curl, CURLOPT_ERRORBUFFER, handle->errbuf);

	return curl_handle;
}
DEFINE_PRIM(hxcurl_init, 0);

value hxcurl_close( value curl_handle )
{
	val_check_kind(curl_handle, k_curl_handle);

	hxcurl_handle *handle = val_data(curl_handle);

	curl_easy_cleanup(handle->curl);

	return val_null;
}
DEFINE_PRIM(hxcurl_close, 1);

value hxcurl_exec( value curl_handle )
{
	int res;
	value r;

	val_check_kind(curl_handle, k_curl_handle);

	hxcurl_handle *handle = val_data(curl_handle);

	// handle->size = 0;
	// handle->memory = (char *)malloc(1);
	handle->b = alloc_buffer(NULL);

	if( !val_bool(handle->write_cb) )
	{
		curl_easy_setopt(handle->curl, CURLOPT_WRITEFUNCTION, writeMemoryCallback);
		curl_easy_setopt(handle->curl, CURLOPT_WRITEDATA, handle);
	}

	if( handle->headers != NULL )
	{
		curl_easy_setopt(handle->curl, CURLOPT_HTTPHEADER, handle->headers);
	}

	res = curl_easy_perform(handle->curl);

	if( handle->headers != NULL )
	{
		curl_slist_free_all(handle->headers);
		handle->headers = NULL;
	}

	//printf("%d\n", handle->size);
	/*
	handle->memory = (char *)realloc(handle->memory, handle->size + 1);
	handle->memory[handle->size] = '\0';
	r = copy_string(handle->memory, handle->size + 1); // alloc_string(handle->memory);
	*/
	// r = copy_string(handle->memory, handle->size);
	r = buffer_to_string(handle->b);

	//printf("%d\n", val_strlen(r));
	//free(handle->memory);

	if( handle->formpost != NULL )
	{
		curl_formfree(handle->formpost);
		handle->formpost = NULL;
		handle->lastptr = NULL;
	}

	return r;
}
DEFINE_PRIM(hxcurl_exec, 1);

value hxcurl_setopt( value curl_handle, value opt, value v )
{
	int i;

	val_check_kind(curl_handle, k_curl_handle);
	val_match_or_fail(opt, int);

	hxcurl_handle *handle = val_data(curl_handle);

	if (val_int(opt) == CURLOPT_POSTFIELDS)
	{
		if( val_is_string(v) )
		{
			curl_easy_setopt(handle->curl, CURLOPT_POSTFIELDS, val_string(v));
		}
		else
		if( val_is_object(v) )
		{
			handle->formpost = NULL;
			handle->lastptr = NULL;

			val_iter_fields(v, setOptFormField, handle);

			curl_easy_setopt(handle->curl, CURLOPT_HTTPPOST, handle->formpost);
		}
		else
		{
			val_throw(alloc_string("hxcurl_setopt CURLOPT_POSTFIELDS: unsupported values.\n"));
		}
	}
	else
	if (val_int(opt) == CURLOPT_HTTPHEADER)
	{
		if( handle->headers != NULL )
		{
			curl_slist_free_all(handle->headers);
			handle->headers = NULL;
		}

		if (val_is_array(v))
		{
			value *strings = val_array_ptr(v);
			int len = val_array_size(v);
			for (i=0; i<len; i++)
			{
				//if( val_is_null(strings[i]) )
				if( strings[i] == NULL )
				{
					// Skip
				}
				else if( val_is_null(strings[i]) )
				{
					// Skip
				}
				else if( val_is_string(strings[i]) )
				{
					value s = strings[i];
					if( val_strlen(s) > 0 )
					{
						handle->headers = curl_slist_append(handle->headers, val_string(s));
					}
				}
			}
		}
		else
		{
			val_throw(alloc_string("hxcurl_setopt HTTPHEADER: Array<String> expected.\n"));
		}
	}
	else
	if (val_int(opt) == CURLOPT_SHARE)
	{
		val_check_kind(v, k_curl_share);

		curl_easy_setopt(handle->curl, CURLOPT_SHARE, val_data(v));
	}
	else
	{
		if (val_is_string(v))
		{
			curl_easy_setopt(handle->curl, (CURLoption)val_int(opt), val_string(v));
		}
		else
		if (val_is_int(v))
		{
			curl_easy_setopt(handle->curl, (CURLoption)val_int(opt), val_int(v));
		}
		else
		if (val_is_bool(v))
		{
			curl_easy_setopt(handle->curl, (CURLoption)val_int(opt), val_bool(v));
		}
		else
		{
			val_throw(alloc_string("hxcurl_setopt: TYPE NOT SUPPORTED!\n"));
		}
	}

	return val_true;
}
DEFINE_PRIM(hxcurl_setopt, 3);

value hxcurl_setheader( value curl_handle, value s )
{
	val_check_kind(curl_handle, k_curl_handle);
	val_check(s, string);

	hxcurl_handle *handle = val_data(curl_handle);

	handle->headers = curl_slist_append(handle->headers, val_string(s));

	return val_true;
}
DEFINE_PRIM(hxcurl_setheader, 2);

value hxcurl_getinfo( value curl_handle, value opt )
{
	int option;
	value ret;

	val_check_kind(curl_handle, k_curl_handle);
	val_match_or_fail(opt, int);

	hxcurl_handle *handle = val_data(curl_handle);

	option = val_int(opt);
	switch(option & CURLINFO_TYPEMASK)
	{
		case CURLINFO_STRING:
		{
			char * vchar;
			curl_easy_getinfo(handle->curl, option, &vchar);
			ret = alloc_string(vchar);
			break;
		}
		case CURLINFO_LONG:
		{
			long vlong;
			curl_easy_getinfo(handle->curl, option, &vlong);
			ret = alloc_int(vlong);
			break;
		}
		case CURLINFO_DOUBLE:
		{
			double vdouble;
			curl_easy_getinfo(handle->curl, option, &vdouble);
			ret = alloc_float(vdouble);
			break;
		}
		default: {
			ret = alloc_string("hxcurl_getinfo: BAD_CURL_INFO");
			val_throw(ret);
			break;
		}
	}
	return ret;
}
DEFINE_PRIM(hxcurl_getinfo, 2);

value hxcurl_set_cb_base( value curl_handle, value fn_read, value fn_write )
{
	val_check_kind(curl_handle, k_curl_handle);
	val_check_function(fn_read , 1);
	val_check_function(fn_write, 1);

	hxcurl_handle *handle = val_data(curl_handle);

	handle->write_cb = alloc_bool(true);

	handle->callback[CALLBACK_READ] = fn_read;
	handle->callback[CALLBACK_WRITE] = fn_write;

	curl_easy_setopt(handle->curl, CURLOPT_READFUNCTION, read_callback_func);
	curl_easy_setopt(handle->curl, CURLOPT_WRITEFUNCTION, write_callback_func);

	curl_easy_setopt(handle->curl, CURLOPT_READDATA, handle);
	curl_easy_setopt(handle->curl, CURLOPT_WRITEDATA, handle);

	return val_null;
}
DEFINE_PRIM(hxcurl_set_cb_base, 3);

value hxcurl_set_cb_ext( value curl_handle, value fn_header, value fn_progress )
{
	val_check_kind(curl_handle, k_curl_handle);
	val_check_function(fn_header, 1);
	val_check_function(fn_progress, 4);

	hxcurl_handle *handle = val_data(curl_handle);

	handle->callback[CALLBACK_HEADER] = fn_header;
	handle->callback[CALLBACK_PROGRESS] = fn_progress;

	curl_easy_setopt(handle->curl, CURLOPT_HEADERFUNCTION, header_callback_func);
	curl_easy_setopt(handle->curl, CURLOPT_PROGRESSFUNCTION, progress_callback_func);
	//	curl_easy_setopt(curl_handle, CURLOPT_XFERINFOFUNCTION, progress_callback_func);

	curl_easy_setopt(handle->curl, CURLOPT_WRITEHEADER, handle);
	curl_easy_setopt(handle->curl, CURLOPT_PROGRESSDATA, handle);
	//	curl_easy_setopt(curl_handle, CURLOPT_XFERINFODATA, handle);

	return val_null;
}
DEFINE_PRIM(hxcurl_set_cb_ext, 3);

value hxcurl_set_cb_debug( value curl_handle, value fn_debug )
{
	val_check_kind(curl_handle, k_curl_handle);
	val_check_function(fn_debug, 2);

	hxcurl_handle *handle = val_data(curl_handle);

	handle->callback[CALLBACK_DEBUG] = fn_debug;

	curl_easy_setopt(handle->curl, CURLOPT_DEBUGFUNCTION, debug_callback_func);

	curl_easy_setopt(handle->curl, CURLOPT_DEBUGDATA, handle);

	return val_null;
}
DEFINE_PRIM(hxcurl_set_cb_debug, 2);

//********************************************************* Share
/* make a new share */
value hxcurl_share_init( )
{
    CURLSH *curl_share = curl_share_init();

	value ret = alloc_abstract(k_curl_share, curl_share);

    return ret;
}
DEFINE_PRIM(hxcurl_share_init, 0);

value hxcurl_share_setopt( value curl_share, value opt, value v )
{
	int res;
	int option;

	val_check_kind(curl_share, k_curl_share);
	val_match_or_fail(opt, int);
	val_match_or_fail(v, int);

	res = CURLE_OK;
	option = val_int(opt);

	switch(option)
	{
		/* slist cases */
		case CURLSHOPT_SHARE:
		case CURLSHOPT_UNSHARE:
			res = curl_share_setopt(val_data(curl_share), option, val_int(v));
			//printf("curl_share_setopt %d %d %d", option, val_int(v), res);
			break;
	};

	//return alloc_int(res);
	return val_null;
}
DEFINE_PRIM(hxcurl_share_setopt, 3);

/* delete the share */
value hxcurl_share_delete( value curl_share )
{
	val_check_kind(curl_share, k_curl_share);

	curl_share_cleanup(val_data(curl_share));
	return val_null;
}
DEFINE_PRIM(hxcurl_share_delete, 1);
