package com.starway.framework.utils
{
	

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class XMLUtils
	{
		public function XMLUtils()
		{
		}

		/**
		 * 判断XML 是否含有属性，如果有返回属性的值，如果没有返回空字符
		 * @result String
		 *
		 * */
		public static function hasAttribute(name:String, xml:XML):String
		{
			var attNamesList:XMLList=xml.@*;
			/*var xml:XML = <example id='123' color='blue'/>
			   trace(attNamesList is XMLList); // true
			   trace(attNamesList.length()); // 2
			   //trace(typeof (attNamesList[jj])); // xml
			   //trace(attNamesList[j].nodeKind()); // attribute
			 //trace(attNamesList[j].name()); // id and color*/

			for (var j:int=0; j < attNamesList.length(); j++)
			{

				if (attNamesList[j].name() == name)
				{
					return String(xml.attribute(name));
				}
			}
			return ""

		}

		/**
		 * 打乱XMLList
		 * 每次随机生成数组b的一个下标subscript，然后取出它所对应的数据a[subscript],
		 * 记下来.然后将数组b的最后一个数b[length]放到下标subscript的位置，同时将数组a长度减1。
		 * 尽管前若干次生成的下标subscript随机数有可能相同，但，因为每一次都把最后一个数填到取出的位置，
		 * 因此，相同下标subscript对应的数却绝不会相同，每一次取出的数都不会一样，这样，就保证了算法的确定性、有效性、有穷性.
		 * @result XMLList
		 * */
		public static function messXMLList(a:XMLList):XMLList
		{
			var subscript:uint;
			var b:XMLList=
				<></>;
			var m:uint;
			var source:XMLList=a.copy();
			while (source.length() > 0)
			{
				subscript=Math.floor(source.length() * Math.random());
				var temp:Object=source[subscript];
				source[subscript]=source[source.length - 1];
				delete source[source.length()];
				b[m]=temp;
				m++;
			}
			return b;
		}

	}
}