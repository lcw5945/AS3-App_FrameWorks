package com.starway.framework.core.net.http
{
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class HTTPRequestMessage
	{
		/**
		 * content-type 
		 * form -->表单 name-value
		 * xml --> 纯文本格式数据，采用xml头指定编码格式
		 * soap_xml --> 纯文本格式数据，忽略xml头所指定编码格式而默认采用us-ascii编码
		 * upload -->FileReference.upload() 
		 */		
		
		public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
		public static const CONTENT_TYPE_XML:String = "application/xml";
		public static const CONTENT_TYPE_SOAP_XML:String = "text/xml; charset=utf-8";
		public static const CONTENT_TYPE_UPLOAD:String = "multipart/form-data";
		
		
		public static const POST_METHOD:String = "POST";
		public static const GET_METHOD:String = "GET";
		
		
		public function HTTPRequestMessage()
		{
		}
		/**
		 * 参数 
		 */		
		public var url:String;
        private var _method:String;

		/**
		 * private 私有 
		 */
		public function get method():String
		{
			return _method;
		}

		/**
		 * @private
		 */
		public function set method(value:String):void
		{
			value = value.toUpperCase();
			if(value == POST_METHOD)
			    _method = POST_METHOD;
			else if(value == GET_METHOD)
				_method = GET_METHOD;
		}

	}
}