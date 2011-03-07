package com.news21.asu.kue.model.vo
{
	public class Asset
	{
		public var file_name:String;
		public var type:String;
		public var title:String;
		public var width:int = 0;
		public var height:int = 0;
		public var x:int = 0;
		public var y:int = 0;
		public var length:int = 0;
		public var body:String;
		public var link:String;
		public var created_at:Date;
		public var created_by:String;
		public var modified_at:Date;
		public var modified_by:String;

		public function Asset()
		{
			
		}
	}
}