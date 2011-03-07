package com.news21.asu.kue.controller
{
	import com.news21.asu.kue.model.FileSystemProxy;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.Asset;
	import com.news21.asu.kue.model.vo.CuePoint;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	public class SaveCuePointCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{ 
			var cuepoint:CuePoint = notification.getBody() as CuePoint;
			//trace('ok the cue point is '+ObjectUtil.toString(cuepoint))
			var proxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			var fileproxy:FileSystemProxy = facade.retrieveProxy(FileSystemProxy.NAME) as FileSystemProxy;
			
			
			
			// check cuepoint ... if asset has file_name ... copy into assets directory and update vo
			if(proxy.currentAsset!=null)
				if(proxy.currentAsset.file_name!=null){
					cuepoint.asset.file_name = fileproxy.copyAsset(proxy.currentAsset.file_name);
					if(cuepoint.cuepoint_asset_file!=null){
						trace('gonna try to delete '+cuepoint.cuepoint_asset_file)
						fileproxy.removeAsset(cuepoint.cuepoint_asset_file);
					}
				}
			
			if(proxy.addProjectCuePoint(cuepoint))
			{
				fileproxy.writeProjectManifest( proxy.generateXMLProject() );
				fileproxy.writeCuePoints( proxy.generateFLVCoreCuePointsXML(proxy.project.cue_points.source) );
			}
			
			proxy.nullCurrentAsset();
		}
		
	}
}