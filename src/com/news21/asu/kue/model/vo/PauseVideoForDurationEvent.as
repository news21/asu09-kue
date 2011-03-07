package com.news21.asu.kue.model.vo
{	
	public class PauseVideoForDurationEvent implements com.news21.asu.kue.model.vo.IPlayerEvent
	{
		public static const NAME:String = "pause-video-for-duration";
		public var params:Object;
		
		public function PauseVideoForDurationEvent() 
		{
			params = [{'label':'pauseforduration','data':true}];
		}

		public function getPlayerEvent():Object 
		{
			return {'name':NAME,'params':params};
		}
		
		public function setParams(a:Array):void {}
	}
}