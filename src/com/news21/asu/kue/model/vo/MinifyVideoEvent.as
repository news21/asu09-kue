package com.news21.asu.kue.model.vo
{	
	public class MinifyVideoEvent implements com.news21.asu.kue.model.vo.IPlayerEvent
	{
		public static const NAME:String = "minify-video";
		public var params:Object;
		
		public function MinifyVideoEvent() 
		{
			params = [{'label':'minify','data':true}];
		}

		public function getPlayerEvent():Object 
		{
			return {'name':NAME,'params':params};
		}
		
		public function setParams(a:Array):void {}
	}
}