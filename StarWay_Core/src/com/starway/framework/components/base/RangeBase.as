package com.starway.framework.components.base
{
	import flash.display.Sprite;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 10, 2014 10:39:26 PM
	 */
	public class RangeBase extends Sprite
	{
		public function RangeBase()
		{
			super();
		}
		/**
		 * 最大值 
		 */		
		private var _maximum:Number = 100;

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(value:Number):void
		{
			if (value == _maximum)
				return;
			
			_maximum = value;
		}
		/**
		 * 最小值 
		 */
		private var _minimum:Number = 0;

		public function get minimum():Number
		{
			return _minimum;
		}

		public function set minimum(value:Number):void
		{
			if (value == _minimum)
				return;
			
			_minimum = value;
		}
		/**
		 * 介于最大值和最小值之间 
		 */		
		private var _value:Number=0;

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			if (value == _value)
				return;
			
			_value = value;
		}
		
		protected function nearestValidValue(value:Number, interval:Number):Number
		{ 
			if (interval == 0)
				return Math.max(minimum, Math.min(maximum, value));
			
			var maxValue:Number = maximum - minimum;
			var scale:Number = 1;
			
			value -= minimum;
			
			if (interval != Math.round(interval)) 
			{ 
				const parts:Array = (new String(1 + interval)).split("."); 
				scale = Math.pow(10, parts[1].length);
				maxValue *= scale;
				value = Math.round(value * scale);
				interval = Math.round(interval * scale);
			}   
			
			var lower:Number = Math.max(0, Math.floor(value / interval) * interval);
			var upper:Number = Math.min(maxValue, Math.floor((value + interval) / interval) * interval);
			var validValue:Number = ((value - lower) >= ((upper - lower) / 2)) ? upper : lower;
			
			return (validValue / scale) + minimum;
		}
		
		/**
		 * 每步的倍数
		 * 比如鼠标滑轮滑动一次的行数 在乘以此数字来计算 value值 
		 */		
		private var _stepMutiple:int = 1;

		public function get stepMutiple():int
		{
			return _stepMutiple;
		}

		public function set stepMutiple(value:int):void
		{
			_stepMutiple = value;
		}
		

		protected function setValue(value:Number):void
		{
			if (_value == value)
				return;
			if (!isNaN(maximum) && !isNaN(minimum) && (maximum > minimum))
				_value = Math.min(maximum, Math.max(minimum, value));
			else
				_value = value;
		}

	}
}