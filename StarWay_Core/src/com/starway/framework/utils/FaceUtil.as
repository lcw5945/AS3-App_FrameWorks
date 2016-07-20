package com.starway.framework.utils
{
	import com.starway.framework.core.net.http.ResourceLoader;
	
	import flash.display.DisplayObject;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextElement;
	
	import mx.utils.StringUtil;

	public class FaceUtil
	{
		public function FaceUtil()
		{
		}
		
		/** 表情的过滤模式 */
		private static var iconReg:RegExp = /\[f\d{1,2}\]/;
		/** 表情数量 */
		private static const FACE_NUM:int = 2;
		public static function getContentArr(content:String,groupVector:Vector.<ContentElement>):void
		{
			var splitArr:Array = content.split(/(\[[f,i,vip][^\[]+?\])/);
			
			for(var i:int=0; i < splitArr.length; i++){
				var item:String = splitArr[i];
				if (iconReg.test(item)){
					var iconId:int = int(item.slice(2, item.length - 1));
					if( iconId > FACE_NUM){
						continue;
					}
					
					var url:String = StringUtil.substitute("f{0}.swf",iconId);
					var iconSprite:DisplayObject = ResourceLoader.getInstance().getDisplayResByUrl(url);
					
					var format:ElementFormat = new ElementFormat();
					format.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
					var face:GraphicElement = new GraphicElement(iconSprite,24,0,format);
					groupVector.push(face);
					
				}else{
					if(item == ""){
						continue;
					}
					
					var contentTE:TextElement = new TextElement(item,TextUtil.createFormat("宋体",0xffffff,12,false));
					groupVector.push(contentTE);
				}
			}
		}
	}
}