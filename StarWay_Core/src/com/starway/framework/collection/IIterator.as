package com.starway.framework.collection
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 23, 2014 3:57:00 PM
	 */
	public interface IIterator
	{
		function reset():void;
		function next():Object;
		function hasNext():Boolean;
	}
}