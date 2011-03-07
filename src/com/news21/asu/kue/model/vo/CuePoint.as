package com.news21.asu.kue.model.vo
{	
	import com.news21.asu.kue.model.vo.Asset;
	
	public class CuePoint
	{
		public var cuepoint_id:int;
		public var cuepoint_asset_file:String;
		public var type:String;
		public var name:String;
		public var time:int;
		public var duration:int;
		public var asset:Asset;
		public var player_events:Array = new Array();
		public var created_at:Date;
		public var created_by:String;
		public var modified_at:Date;
		public var modified_by:String;

		public function CuePoint()
		{
			
		}
	}
}