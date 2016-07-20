package com.starway.framework.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 7, 2014 9:56:37 AM
	 */
	public class ClassUtil
	{
		public function ClassUtil()
		{
		}
		
		/**
		 * 判断是否子类是和父类是一个类型  或者 实现了接口
		 * @param subCls
		 * @param parCls
		 * @return 
		 * 
		 */				
		public static function isClassOneType(subClass:Class,praClass:Class):Boolean
		{
			var res:Boolean;
			var praType:String = getQualifiedClassName(praClass);
			var subXML:XML = describeType(subClass);
			if(praType == subXML.@name)return true;
			var extendsXmlInfo:XMLList = subXML..extendsClass;
			for each(var exml:XML in extendsXmlInfo)
			{
				var typeStr:String = exml.@type;
				if(typeStr.indexOf(praType)!=-1)
					res =true;
			}
			if(res)return true;
			else
			{
				var implXmlInfo:XMLList = subXML..implementsInterface;
				for each(var pxml:XML in implXmlInfo)
				{
					var typeStrs:String = pxml.@type;
					if(typeStrs.indexOf(praType)!=-1)
						res =true;
				}
			}
			return res;
		}
	}
}