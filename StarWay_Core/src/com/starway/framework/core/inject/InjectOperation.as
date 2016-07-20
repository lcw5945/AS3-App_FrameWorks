package com.starway.framework.core.inject
{
	import com.starway.framework.core.entity.IEntityModle;
	import com.starway.framework.core.log.Log;
	import com.starway.framework.core.module.ModuleProxy;
	import com.starway.framework.core.objpool.ibase.IKeyObjectPool;
	
	import flash.utils.describeType;
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Nov 7, 2014 12:36:05 PM
	 */
	public class InjectOperation
	{
		public function InjectOperation()
		{
		}
		/**
		 * 分析action 
		 * 检查所有变量如果都注入完成则返回成功
		 * @param ins
		 * 
		 */		
		public function anlaysMeta(ins:Object):Boolean
		{
			var result:Boolean=true;
			var desXML:XML = describeType(ins).copy(); 
			var typeName:String = desXML.@name; 
			for (var i:int = 0, len:int = desXML.variable.length(); i < len;i++) 
			{ 
				var varXML:XML = desXML.variable[i]; 
				if(ins[varXML.@name] == null)
				{
					result=false;
					initVariableMeta(ins,typeName,varXML);
				}
			} 
			
			return result;
		}
		
		/**
		 * 
		 * @param ins
		 * @param typeName
		 * @param varXML
		 * 
		 */        	
		private function initVariableMeta(ins:Object,typeName:String,varXML:XML):void 
		{ 
			var name:String = varXML.@name; 			
			var type:String = varXML.@type;
			
			for (var i:int = 0, len:int = varXML.metadata.length(); i < len;i++) 
			{ 
				var mata:XML = varXML.metadata[i]; 
				var metaName:String = mata.@name; 
				
				switch (metaName) 
				{ 
					case "InjectModel": 
					{	
						instanceModelVar(ins,name,type);
						break; 
					}
					case "InjectIModuleProxy":
					{
						instanceModule(ins,name,type,varXML.metadata[0].arg[0].@value);
						break;
					}
					case "InjectContext":
					{
						//log
//						Log.getLogger(this).debug("注入 " + typeName + " ["+metaName+"]  " + name);
						instanceContext(ins,name,type);
						break;
					}
					case "InjectKeyVO":
					{
						instanceKeyVO(ins,name,type,varXML.metadata[0].arg[0].@value);
						break;
					}
				} 
			} 
		}
		
		/**
		 * 注入模块 
		 * @param ins
		 * @param variable
		 * @param type
		 * @param name
		 * 
		 */		
		private function instanceModule(ins:Object,variable:String,type:String,name:String):void
		{
			var modProxy:ModuleProxy = new ModuleProxy();
			modProxy.modName = name;
			ins[variable] = modProxy;
		}
		
		/**
		 * 注入KeyVo对象 
		 * @param ins
		 * @param variable
		 * @param type
		 * 
		 */		
		private function instanceKeyVO(ins:Object,variable:String,type:String,key:String):void
		{
			var res:Boolean = false;
			for(var typeCls:* in InjectGlobals.keyObjectPoolDic)
			{
				if(isOneType(typeCls,type))
				{
					var ikeypool:IKeyObjectPool = InjectGlobals.keyObjectPoolDic[typeCls];					
					ins[variable] = ikeypool.borrowObject(key);
					res = true;
					break;
				}
			}
		    res || Log.getLogger(this).error("注入失败 - Vo " + type + " ["+variable+"]  " + key);
		}
		
		/**
		 * 注入ontext 
		 * @param ins
		 * @param variable
		 * @param type
		 * 
		 */		
		private function instanceContext(ins:Object,variable:String,type:String):void
		{
			var res:Boolean = false;
			for(var key:String in InjectGlobals.contextContanier)
			{
				if(isOneType(InjectGlobals.contextContanier[key],type))
				{
					ins[variable] = InjectGlobals.contextContanier[key];
					res = true;
					break;
				}		
			}
			
			res || Log.getLogger(this).error("注入失败 - Context " + type + " ["+variable+"]");
		}
		/**
		 * 注入模型实例 
		 * @param ins
		 * @param variable
		 * @param type
		 * 
		 */		
		private function instanceModelVar(ins:Object,variable:String,type:String):void
		{
			var res:Boolean = false;
			for each(var entity:IEntityModle in  InjectGlobals.entityBeanMaps)
			{
				if(isOneType(entity,type))
				{
					ins[variable] = entity;
					res = true;
					break;
				}
			}
			
			res || Log.getLogger(this).error("注入失败 - Model " + type + " ["+variable+"]");
		}
		/**
		 * 判断实例是否和类是一个类型 
		 * @param subClass
		 * @param praType
		 * @return 
		 * 
		 */		
		private function isOneType(subClass:*,praType:String):Boolean
		{
			var res:Boolean;			
			var subXML:XML = describeType(subClass);
			if(praType == subXML.@name)return true;
			var extendsXmlInfo:XMLList = subXML..extendsClass;
			for each(var exml:XML in extendsXmlInfo)
			{
				var typeStr:String = exml.@type;
				if(typeStr.indexOf(praType)!=-1)
				{
					res =true;
					break;
				}
			}
			if(res)return true;
			else
			{
				var implXmlInfo:XMLList = subXML..implementsInterface;
				for each(var pxml:XML in implXmlInfo)
				{
					var typeStrs:String = pxml.@type;
					if(typeStrs.indexOf(praType)!=-1)
					{
						res =true;
						break;
					}
				}
			}
			return res;
		}
	}
}