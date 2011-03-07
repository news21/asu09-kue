/*
  CodePeek - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.news21.asu.kue.controller
{

	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.observer.*;

	import com.news21.asu.kue.*;
	import com.news21.asu.kue.model.*;
	import com.news21.asu.kue.view.*;

	import org.puremvc.as3.utilities.air.desktopcitizen.DesktopCitizenConstants;
	
	/**
	 * Create and register <code>Proxy</code>s with the <code>Model</code>.
	 */
	public class StartupCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void	{
			
			var app:Kue = note.getBody() as Kue;
			
			facade.registerProxy(new ProjectProxy());
			facade.registerProxy(new FileSystemProxy());
			
			facade.registerMediator( new ApplicationMediator( app ) );
			
			sendNotification( DesktopCitizenConstants.WINDOW_OPEN, app.stage ); 
		}
	}
}