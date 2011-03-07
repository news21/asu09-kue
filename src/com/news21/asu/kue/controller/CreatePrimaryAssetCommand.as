package com.news21.asu.kue.controller
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.ProjectProxy;
	import com.news21.asu.kue.model.vo.Project;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import mx.utils.ObjectUtil;
	
	public class CreatePrimaryAssetCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{ 
			var proxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			proxy.importPrimaryAsset();
		}
		
	}
}