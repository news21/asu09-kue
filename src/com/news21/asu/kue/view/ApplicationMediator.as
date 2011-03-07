/*
  CodePeek - Google Code Search for Adobe RIA Developers
  Copyright(c) 2007-08 Cliff Hall <clifford.hall@puremvc.org>
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package com.news21.asu.kue.view
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;

	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.view.components.*;
	import com.news21.asu.kue.model.*;
	
	import org.puremvc.as3.utilities.air.desktopcitizen.DesktopCitizenConstants;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		// Cannonical name of the Mediator
		public static const NAME:String = 'ApplicationMediator';
		
		public function ApplicationMediator( viewComponent:Object ) 
		{
			// pass the viewComponent to the superclass where 
			// it will be stored in the inherited viewComponent property
			super( NAME, viewComponent );

			// Create and register Mediators for the Stage and
			// components that were instantiated by the mxml application
//			facade.registerMediator( new StageMediator( app.stage ) );	
			facade.registerMediator( new AppCanvasMediator( app.acanvas ) );	
			
			// retrieve and cache a reference to frequently accessed proxys
			//searchesProxy = SearchesProxy( facade.retrieveProxy( SearchesProxy.NAME ) );
			
			// set the available searchTypes ( as returned by the searchesProxy )
			// as the dataprovider for the application's tree subcomponent
			//app.tree.dataProvider = searchesProxy.searchTypes;
			
			// Listen for events from the view component 
			//app.addEventListener( CodePeek.TREE_ITEM_SELECTED, onTreeItemSelect );

		}

		/**
		 * List all notifications this Mediator is interested in.
		 * <P>
		 * Automatically called by the framework when the mediator
		 * is registered with the view.</P>
		 * 
		 * @return Array the list of Nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			
			return [ DesktopCitizenConstants.WINDOW_READY 
					];
		}

		/**
		 * Handle all notifications this Mediator is interested in.
		 * <P>
		 * Called by the framework when a notification is sent that
		 * this mediator expressed an interest in when registered
		 * (see <code>listNotificationInterests</code>.</P>
		 * 
		 * @param INotification a notification 
		 */
		override public function handleNotification( note:INotification ):void 
		{
			/*switch ( note.getName() ) {
				
				// Time to show the application window
				case DesktopCitizenConstants.WINDOW_READY:
					app.showControls = true;
					break;

				// The code search has returned success
				case ApplicationFacade.CODE_SEARCH_SUCCESS:
					// Reset the tree, open the proper folder 
					// and select the proper item				
					app.tree.dataProvider = searchesProxy.searchTypes;
					app.tree.validateNow();
					var details:Array = note.getBody() as Array;
					var searchType:XMLList = details[0];
					var search:XMLList = details[1];
					app.browser.location = search.@url;
					app.tree.selectedItem = searchType;
					app.tree.expandItem(app.tree.selectedItem, true);
					app.tree.selectedItem = search;
					break;
			}*/
		}

		

		/**
		 * Cast the viewComponent to its actual type.
		 * 
		 * <P>
		 * This is a useful idiom for mediators. The
		 * PureMVC Mediator class defines a viewComponent
		 * property of type Object. </P>
		 * 
		 * <P>
		 * Here, we cast the generic viewComponent to 
		 * its actual type in a protected mode. This 
		 * retains encapsulation, while allowing the instance
		 * (and subclassed instance) access to a 
		 * strongly typed reference with a meaningful
		 * name.</P>
		 * 
		 * @return app the viewComponent cast to org.puremvc.as3.demos.air.CodePeek
		 */
		protected function get app():Kue{
			return viewComponent as Kue;
		}

		// Cached reference to search proxy
		//private var searchesProxy:SearchesProxy;
	}
}