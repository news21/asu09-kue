package com.news21.asu.kue.model.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class Project
	{
		public var name:String;
		public var description:String;
		public var primary_asset:Asset;
		public var cue_points:ArrayCollection = new ArrayCollection();
		public var created_at:Date;
		public var created_by:String;
		public var modified_at:Date;
		public var modified_by:String;

		public function Project()
		{
			
		}
		
		public function validate():Object
		{
			var o:Object = new Object();
			var a:Array = new Array();
			if(name.length == 0)
				a.push('name');
			if(description.length == 0)
				a.push('description');
			if(modified_by.length == 0)
				a.push('modified_by');
			
			if(a.length > 0) {
				o.status = 'failed';
				o.invalidArray = a;
			} else {
				o.status = 'success';
			}
			
			return o;
		}
	}
}