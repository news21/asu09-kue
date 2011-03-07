package com.news21.asu.kue.model.vo
{	
	public class PauseVideoEvent implements com.news21.asu.kue.model.vo.IPlayerEvent
	{
		public static const NAME:String = "pause-video";
		public var params:Object;
		
		public function PauseVideoEvent() 
		{
			params = [{'label':'pause','data':true}];
		}

		public function getPlayerEvent():Object 
		{
			return {'name':NAME,'params':params};
		}
		
		public function setParams(a:Array):void {}
	}
}