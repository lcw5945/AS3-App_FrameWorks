package com.starway.framework.core.net.http
{
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 24, 2014 4:50:32 PM
	 */
	public class HTTPResponseMessage
	{
		
		/**
		 * text,xml,json,variables,bytearray 
		 * json -->JSON
		 * text -->String
		 * xml -->XML
		 * variables --> name=value pairs
		 * bytearray --> ByteArray
		 */		
		public static const RESULT_FORMAT_TEXT:String = "text";
		public static const RESULT_FORMAT_XML:String = "xml";
		public static const RESULT_FORMAT_JSON:String = "json";
		public static const RESULT_FORMAT_VARIABLES:String = "variables";
		public static const RESULT_FORMAT_BYTEARRAY:String = "bytearray";
	}
}