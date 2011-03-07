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
	
	public class CreateAssetCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{ 
			var obj:Object = notification.getBody() as Object;
			var proxy:ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
			proxy.importAsset(obj.atype,obj.filtername,obj.filters);
		}
		
	}
}