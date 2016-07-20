package com.starway.framework.utils
{

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class ArrayUtils
	{
		public function ArrayUtils()
		{
		}

		public static function tofristLowerCase(value:String):String
		{
			var str1:String;
			var str2:String;

			str1=value.substr(0, 1);
			str2=value.substr(1, value.length - 1);
			value=str1.toLowerCase() + str2;
			return value;
		}

		/**
		 * 删除数组中重复的内容
		 * @param array
		 * @param index
		 * @return
		 *
		 */
		public static function deleteRepeat(array:Array, index:int):Array
		{
			if (!array)
				return null;
			if (index >= array.length - 1)
				return array;

			for (var i:int=0; i < array.length; i++)
			{
				if ((index != i) && array[index] == array[i])
				{
					array.splice(i, 1);
					return deleteRepeat(array, index);
				}
			}
			return deleteRepeat(array, (index + 1));
		}

		public static function randomArray(array:Array, num:Number=5):Array
		{
			var len:int=array.length - 1;
			for (var n:int=0; n < num; n++)
			{
				var i:int=Math.round(Math.random() * len);
				var j:int=Math.round(Math.random() * len);
				var obj:Object=new Object;
				obj=array[j];
				array[j]=array[i];
				array[i]=obj;
			}

			return array;
		}

		/**
		 * 打乱数组
		 * 每次随机生成数组b的一个下标subscript，然后取出它所对应的数据a[subscript],
		 * 记下来.然后将数组b的最后一个数b[length]放到下标subscript的位置，同时将数组a长度减1。
		 * 尽管前若干次生成的下标subscript随机数有可能相同，但，因为每一次都把最后一个数填到取出的位置，
		 * 因此，相同下标subscript对应的数却绝不会相同，每一次取出的数都不会一样，这样，就保证了算法的确定性、有效性、有穷性.
		 * */
		public static function messArray(a:Array):Array
		{
			var subscript:uint;
			var b:Array=new Array();

			while (a.length > 0)
			{
				subscript=Math.floor(a.length * Math.random());
				var temp:Object=a[subscript];
				a[subscript]=a[a.length - 1];
				a.length--;
				b.push(temp);
			}
			return b;
		}
		/**
		 * 清空数组 
		 * @param a
		 * 
		 */        
		public static function emptyArray(a:Array):void
		{
			while(a.length>0)
			{
				a.pop();
			}
		}
	}
}