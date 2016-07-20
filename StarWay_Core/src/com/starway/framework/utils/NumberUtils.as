package com.starway.framework.utils
{

	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class NumberUtils
	{
		public function NumberUtils()
		{
		}


		public static function isInt(num:Number):Boolean
		{
			return num == Math.floor(num);
		}

		/**
		 * len：随机数组的长度
		 * max: 最大数
		 * */
		public static function randomNumberArray(len:Number, maxNum:Number, resArray:Array):Array
		{
			if (len > 0)
			{
				var r:Number=Math.round(Math.random() * maxNum);
				var bRepeat:Boolean=false;
				for (var m:Number=0; m < resArray.length; m++)
				{
					if (r == resArray[m])
						bRepeat=true;
				}
				if (!bRepeat)
				{
					len--;
					resArray.push(r);
				}

				return randomNumberArray(len, maxNum, resArray);
			}
			else
				return resArray;
		}


	}
}