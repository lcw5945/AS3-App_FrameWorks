package com.starway.framework.html
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	/**
	 * 
	 * @author Cray
	 * 
	 */	
	public class IFrame extends Sprite {
		private var _source :String;		
		private var _width	:int;
		private var _height	:int;
		private var _color:uint;
		public function IFrame(pWidth:int = 320, pHeight:int = 240, pColor:uint = 0xffffff) {			
			_width = pWidth;
			_height = pHeight;
			_color = pColor;
			drawBg();
		}		
		private function drawBg():void{
			this.graphics.clear();
			this.graphics.beginFill(_color, 1);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
		}
		public function reDrawBg(ww:Number,hh:Number,cc:uint = 0xffffff):void{
			_width = ww;
			_height = hh;
			_color = cc;
			drawBg();
		}
		private function moveIFrame():void{
			var _localPt:Point = new Point(0, 0);
			var _globalPt:Point = this.localToGlobal(_localPt);			
			if (ExternalInterface.available) 
				ExternalInterface.call(JSScripts.move, _globalPt.x, _globalPt.y, _width, _height);				
		}
		
		public function get source():String {return _source;		}
		public function set source(pURL:String):void{
			if (pURL == "") return;			
			_source = pURL;			
			if (ExternalInterface.available) 
				ExternalInterface.call(JSScripts.url, pURL);
			moveIFrame();
		}
		override public function addChild(child:DisplayObject):DisplayObject {
			throw new Error("IFrame cann't addChild");
			return null;
		}		
		override public function set visible(pVisible:Boolean):void {
			super.visible = pVisible;
			if (ExternalInterface.available) 
				ExternalInterface.call(JSScripts.visible, pVisible.toString());			
		}	
		override public function set x(value:Number):void{
			super.x = value;
			moveIFrame();
		}
		override public function set y(value:Number):void{
			super.y = value;
			moveIFrame();
		}
	}
}

internal class JSScripts
{	
	public static var overflow:XML = new XML(
		<script>
				<![CDATA[
				function (p_para) {
					var objNode = document.getElementById("innerHtmlIFrameContainer");
					objNode.style.overflow = p_para;					
				}
				]]>
		</script>
	);
	public static var visible:XML = new XML(
		<script>
			<![CDATA[
				function(p_visible) 
				{
					var objNode = document.getElementById("myIFrameContainer");
					if (p_visible == "true") {
						objNode.style.visibility = "visible";
					}else {						
						objNode.style.visibility = "hidden";
					}					
				}
			]]>
		</script>
	);
	public static var url:XML = new XML(
		<script>
				<![CDATA[
				function (p_url) {
					var objNode = document.getElementById("myIFrameContainer");
					objNode.innerHTML = "<iframe id='innerHtmlIFrameContainer' src='" + p_url + "'frameborder='0'  allowTransparency='true'  ></iframe>";					
				}
				]]>
		</script>
	);
	public static var move:XML = new XML(
		<script>
				<![CDATA[
				function (p_x, p_y, p_w, p_h) {					
					var iframeNode = document.getElementById("myIFrameContainer");				
					iframeNode.style.left = p_x;					
					iframeNode.style.top = p_y;					
					var innerIFrame = document.getElementById("innerHtmlIFrameContainer");						
					innerIFrame.width = p_w;					
					innerIFrame.height = p_h;					
				}
				]]>
		</script>
	);
		
	
}