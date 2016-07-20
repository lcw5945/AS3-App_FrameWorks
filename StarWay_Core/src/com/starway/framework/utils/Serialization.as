package com.starway.framework.utils
{
	

	public class Serialization
	{
		/**
		 * 把对象序列化为字符串
		 * @param obj
		 * @return 序列化后的字符串
		 *
		 */
		public static function serialize(obj:Object):String
		{
			var str:String="{";
			for(var key:String in obj)
			{
				str += key + ":" +  obj[key] + ",";
			}
			return str;
		}

		/**
		 * 把字符串反序列化为对象
		 * @param str 需要反序列化的字符串
		 * @return 反序列化后的对象
		 *
		 */
		public static function deserialize(str:String):Object
		{
	
			return {};
		}
	}
}