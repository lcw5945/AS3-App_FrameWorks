package com.starway.framework.utils
{
	
	import com.starway.framework.core.net.http.ResourceLoader;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontWeight;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextElement;
	
	import mx.utils.StringUtil;
	
	/**
	 * 
	 * @author Cray
	 * 
	 */
	public class TextUtil
	{
		public function TextUtil()
		{
		}
		
		/** 图片标签 **/
		private static const IMG:String = "img";
		
		/** 文本标签 **/
		private static const FONT:String = "font";
		
		/** 换行  **/
		private static const BR:String = "br";
		
		/** 超链接 **/
		private static const A:String = "a";
		/**
		 * html转换成xml 
		 * @param content
		 * @param txtColor
		 * @param size
		 * @return 
		 * 
		 */		
		private static function htmlToXml(content:String,family:String,color:String,size:int):XML
		{
			XML.ignoreWhitespace = false;
			var fontTxt:String = "<font famliy='{0}'color='{1}' size='{2}'>{3}</font>"
			var splitArray:Array = content.split(/(<.*?\/.*?>)/);
			var xml:XML = <body/>;
			for each (var str:String  in splitArray) 
			{
				if(str == "")continue;
				if(str.indexOf("<") != -1)
					xml.appendChild(new XML(str));
				else 
					xml.appendChild(new XML(StringUtil.substitute(fontTxt,family,color,size,str)));
			}
			
			return xml;
		}
		
		private static function htmlFormat(content:String):String
		{
			var character:Object = {
				'&nbsp' : ' '
			};
			
			return content.replace(/&nbsp/g,function():String{
				var c:String = arguments[0];
				return character[c];
			});
		}
		
		/**
		 * 把一串HTML变成一个个的HTML 
		 * @param conten
		 * @param color
		 * @param size
		 * @return 
		 * 
		 */		
		public static function htmlToArray(conten:String,family:String,color:String,size:int):Array
		{
			var xml:XML = htmlToXml(conten,family,color,size);
			var newXml:XML;
			var itemStr:String;
			var arr:Array = [];
			var attr:XMLList;
			for each(var item:XML in xml.children()){
				itemStr = item.text();
				if(item.name() == "font"){
					for(var i:int = 0;i < itemStr.length;i++){
						newXml = new XML(item);
						newXml.setChildren(itemStr.charAt(i));
						newXml.@bold = "true";
						arr.push(newXml.toXMLString());
					}
				}
				else if(item.name() == "img"){
					arr.push(item.toXMLString());
				}
			}
			return arr;
		}
		
		/**
		 * 将文本内容解析成 Vector数组，类型： GroupElement
		 * @param content
		 * @param txtColor
		 * @param size
		 * @return 
		 * 
		 */		
		public static function analyzeToGroups(content:String,fontFamily:String,fontColor:String,size:int,hrefColor:String="#00CC00"):Vector.<GroupElement>
		{
			var groupsVecor:Vector.<GroupElement> = new Vector.<GroupElement>;
			var contentVector:Vector.<ContentElement> = new Vector.<ContentElement>();
			
			//content 数组
			var groupElement:GroupElement = new GroupElement();
			//将内容转成xml
			var toXml:XML = htmlToXml(content,fontFamily,fontColor,size);
			var tagName:String;
			var eleFormat:ElementFormat;
			for each (var xml:XML in toXml.children()) 
			{
				tagName = xml.name();
				if(tagName == IMG){
					//资源
					var iconSprite:DisplayObject = ResourceLoader.getInstance().getDisplayResByUrl(xml.@src);
					eleFormat = new ElementFormat();
					eleFormat.dominantBaseline = TextBaseline.ASCENT;
					var face:GraphicElement = new GraphicElement(iconSprite,15,15,eleFormat);
					contentVector.push(face);
				}
				else if(tagName == FONT){
					//文本
					var color:int;
					var bold:Boolean;
					var famliy:String;
					//判断是否有颜色
					if(xml.attribute("color").length() > 0){
						color =  HtmlUtil.colorStrToInt(xml.@color)
					}
					else {
						color =  HtmlUtil.colorStrToInt(fontColor);
					}
					//字体是否是粗体
					if(xml.attribute("bold").length() > 0){
						bold =  Boolean(xml.@bold);
					}
					//是否设置字体
					if(xml.attribute("famliy").length() > 0){
						famliy = xml.@famliy;
					}else{
						famliy = fontFamily;
					}
					//是否设置字体
					if(xml.attribute("size").length() > 0){
						size = xml.@size;
					}else{
						size = size;
					}
					//创建文本格式化
					eleFormat = createFormat(famliy,color,size,bold);
					var te:TextElement = new TextElement(htmlFormat(xml.toString()),eleFormat);
					contentVector.push(te);
				}
				else if(tagName == BR){
					//保存组元素,重新初始化一个新组
					groupElement.setElements(contentVector);
					groupsVecor.push(groupElement);
					//新的组
					contentVector = new Vector.<ContentElement>;
					//content 数组
					groupElement = new GroupElement();
				}else if(tagName == A){

					var hyperlink:String = htmlFormat(xml.toString());
					//响应鼠标事件
					var eventDP:EventDispatcher = new EventDispatcher();
						eventDP.addEventListener(MouseEvent.MOUSE_OUT, function mouseOutHandler(event:MouseEvent):void{
							
						});
						eventDP.addEventListener(MouseEvent.MOUSE_OVER, function mouseOverHandler(event:MouseEvent):void{
							
						});
						eventDP.addEventListener(MouseEvent.CLICK, function mouseClickHandler(event:MouseEvent):void{
							navigateToURL(new URLRequest(hyperlink), "_blank");
						});
					
					//创建文本格式化
					var hc:uint = HtmlUtil.colorStrToInt(hrefColor);
					eleFormat = createFormat(famliy,hc,size,bold);
					var textElement:TextElement = new TextElement(hyperlink,eleFormat);
					textElement.eventMirror = eventDP;
					textElement.userData = hyperlink;
					contentVector.push(textElement);
				}
			}
			//如果有内容
			if(contentVector.length>0)
			{
				//保存组元素
				groupElement.setElements(contentVector);
				groupsVecor.push(groupElement);
			}
			return groupsVecor;
		}
		
		/**
		 * 创建一个样式对象
		 * @param color
		 * @param size
		 * @param bold
		 * @return 
		 * 
		 */
		public static function createFormat(family:String,color:int,size:int,bold:Boolean):ElementFormat
		{		
			var format:ElementFormat = new ElementFormat();
			format.fontSize = size;
			format.color = color;
			if(bold)
			    format.fontDescription = new FontDescription(family,FontWeight.BOLD);
			else
				format.fontDescription = new FontDescription(family,FontWeight.NORMAL);
			return format;
		}
	}
}