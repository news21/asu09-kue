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
	
	public class OpenExistingProjectCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{ 
			var fileproxy:FileSystemProxy = facade.retrieveProxy(FileSystemProxy.NAME) as FileSystemProxy;
			fileproxy.importExistingZip();
		}
		
	}
}