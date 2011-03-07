package com.news21.asu.kue.controller
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.FileSystemProxy;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.Asset;
	import com.news21.asu.kue.model.vo.Project;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CreateNewProjectCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{ 
			var project:Project = notification.getBody() as Project;
			var projectproxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			var fileproxy:FileSystemProxy = facade.retrieveProxy(FileSystemProxy.NAME) as FileSystemProxy;
			var current_asset:Asset = projectproxy.primaryAsset;
			
			// create dir structure,create manifest & copy selected primary asset to new project dir on desktop
			var newasset:File = fileproxy.createNewProjectStructure(projectproxy.primaryAssetFile);
			
			// set project nfo
			projectproxy.project = project;
			projectproxy.currentUser = project.modified_by;
			
			// update project.primary_asset with new path
			projectproxy.primaryAssetFile = newasset;
			current_asset.file_name = newasset.name;
			projectproxy.primaryAsset = current_asset;
			
			trace(newasset.url);
			fileproxy.writeProjectManifest( projectproxy.generateXMLProject() );
			projectproxy.nullCurrentAsset();
			
			sendNotification(ApplicationFacade.PROJECT_INITIALIZED);
		}
		
	}
}