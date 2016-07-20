package com.starway.framework.utils
{
	

	public class ObjectUtil
	{
		private static var dictype:Object = {
			"[object Boolean]": "boolean",
			"[object Number]": "number",
			"[object String]": "string",
			"[object Function]": "function",
			"[object Array]": "array",
			"[object Object]": "object"
		};
		public function ObjectUtil()
		{
		}
		
		public static function type(obj:*):String
		{
			if ( obj == null ) {
				return obj + "";
			}
			var dt:String = Object.prototype.toString.call(obj);
			dt = dt.replace(/-.*]/g, "]");
			return dictype[dt];
		}
		
		public static function each(obj:*, callback:Function):*
		{
			var value:Object, i:int=0, len:int,key:*;
			if(Object.prototype.toString.apply(obj) === '[object Array]')
			{
				len = obj.length;
				for(;i<len;i++){
					value = callback.call(obj[i], i, obj[i]);
					if(value === false)break;
				}
			}else{
				for(key in obj){
					value = callback.call(obj[key], key, obj[key]);
					if(value === false)break;
				}
			}
			return obj;	
		}
		
		public static function serializer(data:Object, str:String = ""):String
		{
			for(var key:* in data)
			{
				str == "" ? (str += key + ":" + data[key]) : (str += ", " +  key + ":" + data[key]);
			}
			return str;
		}
		

	}
}