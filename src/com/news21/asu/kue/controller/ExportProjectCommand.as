package com.news21.asu.kue.controller
{
	import com.news21.asu.kue.model.FileSystemProxy;
	import com.news21.asu.kue.model.ProjectProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ExportProjectCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{ 
			var projectproxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			var fileproxy:FileSystemProxy = facade.retrieveProxy(FileSystemProxy.NAME) as FileSystemProxy;
			
			fileproxy.writeProjectManifest( projectproxy.generateXMLProject() );
			fileproxy.writeCuePoints( projectproxy.generateFLVCoreCuePointsXML(projectproxy.project.cue_points.source) );
			var zpd:Boolean = fileproxy.zipProject();
		}
		
	}
}