package com.news21.asu.kue.model
{
	import com.news21.asu.kue.ApplicationFacade;
	import com.news21.asu.kue.model.vo.Asset;
	import com.news21.asu.kue.model.vo.CuePoint;
	import com.news21.asu.kue.model.vo.PauseVideoEvent;
	import com.news21.asu.kue.model.vo.PauseVideoForDurationEvent;
	import com.news21.asu.kue.model.vo.Project;
	import com.news21.asu.util.XMLLoader;
	
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.FileFilter;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ProjectProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'ProjectProxy';
		
		private var _project:Project;
		private var _primaryAsset:Asset;
		private var _primaryAssetFile:File;
		private var _defaultDirectory:File;
		private var _stream:FileStream = new FileStream();
		
		private var _currentAsset:Asset;
		private var _currentCuePoint:CuePoint;
		private var _currentUser:String;
		private var fileChooser:File;
		private var xmlLoader:XMLLoader;
		
		public function ProjectProxy() {
			super( NAME );
			
			_project = new Project();
			_defaultDirectory = File.documentsDirectory;
		}
		
		public function get cue_points():ArrayCollection
		{
			return _project.cue_points;
		}
		
		public function get currentUser():String
		{
			return _currentUser;
		}
		
		public function set currentUser(cu:String):void
		{
			_currentUser = cu;
		}
		
		public function get primaryAssetFile():File
		{
			return _primaryAssetFile;
		}
		
		public function set primaryAssetFile(paf:File):void
		{
			_primaryAssetFile = paf;
		}
		
		public function get project():Project
		{
			return _project;
		}
		
		public function set project(p:Project):void
		{
			_project = p;
		}
		
		public function get primaryAsset():Asset
		{
			return _primaryAsset;
		}
		
		public function set primaryAsset(pa:Asset):void
		{
			_primaryAsset = pa;
		}
		
		public function get currentAsset():Asset
		{
			return _currentAsset;
		}
		
		public function set currentAsset(a:Asset):void
		{
			_currentAsset = a;
		}
		
		public function nullCurrentAsset():void
		{
			_currentAsset = null;
		}
		
		
		/**
		* Called when the user clicks the Open button. Opens a file chooser dialog box, in which the 
		* user selects a primaryAsset. 
		*/
		public function importPrimaryAsset():void 
		{	
			var flvFilter:FileFilter = new FileFilter("Flash Video", "*.flv");
			
			if (_primaryAssetFile) 
				fileChooser = _primaryAssetFile;
			else
				fileChooser = _defaultDirectory;
				
			fileChooser.browseForOpen("Open",[flvFilter]);
			fileChooser.addEventListener(Event.SELECT, paOpenSelected);
		}
		
		
		/**
		* Called when the user selects the currentFile in the FileOpenPanel control. The method passes 
		* File object pointing to the selected primaryAsset, and opens a File_stream object in read mode (with a FileMode
		* setting of READ).
		*/
		private function paOpenSelected(event:Event):void 
		{
			fileChooser.removeEventListener(Event.SELECT,paOpenSelected);
			var selectedpa:File = event.target as File;
			setPrimaryAssetFile(selectedpa.nativePath);
		}
		
		public function setPrimaryAssetFile(pfile:String):void
		{
			_primaryAssetFile = undefined;
			_primaryAssetFile = new  File(pfile);
			
			var na:Asset = new Asset();
			na.file_name = _primaryAssetFile.name;
			na.type = ApplicationFacade.ASSETTYPE_VIDEO;
			na.modified_by = _project.modified_by;
			_primaryAsset = na;
			
			_project.primary_asset = na;
			
			trace(_primaryAssetFile.name);
			sendNotification(ApplicationFacade.PRIMARY_ASSET_SELECTED);
		}
		
		
		public function importAsset(atype:String,filtername:String,filters:String):void 
		{	
			var flvFilter:FileFilter = new FileFilter(filtername, filters);
			fileChooser = _defaultDirectory;
			
			trace('before it starts '+ObjectUtil.toString(this.project));
			
			_currentAsset = undefined;
			_currentAsset = new Asset();
			
			_currentAsset.type = ApplicationFacade.ASSETTYPE_VIDEO;
			_currentAsset.modified_by = _project.modified_by;
			
			fileChooser.browseForOpen("Open",[flvFilter]);
			fileChooser.addEventListener(Event.SELECT, aOpenSelected);
		}
		private function aOpenSelected(event:Event):void 
		{
			fileChooser.removeEventListener(Event.SELECT,aOpenSelected);
			var cafile:File = event.target as File;
			_currentAsset.file_name = cafile.url;
			
			sendNotification(ApplicationFacade.ASSET_SELECTED);
		}
		
		public function deleteProjectCuePoint(cp:CuePoint):Boolean
		{
			// remove old cuepoint ... only 1 cue point allowed per second
			trace('trying to remove old');
			for(var i:int=0;i<_project.cue_points.length;i++)
			{
				trace(_project.cue_points[i].id+' == ' +cp.time);
				if(_project.cue_points[i].id == cp.time){
					_project.cue_points.removeItemAt(i);
				}	
			}
			
			sendNotification(ApplicationFacade.CUE_POINT_SAVED);
			
			return true;
		}
		
		public function addProjectCuePoint(cp:CuePoint):Boolean
		{
			var sort:Sort = new Sort();
			sort.fields = [new SortField('time', false,false,new Object())];
			
			cp.cuepoint_id = cp.time;
			if(cp.asset.file_name!=null)
				cp.cuepoint_asset_file = cp.asset.file_name;
			
			// remove old cuepoint ... only 1 cue point allowed per second
			trace('trying to remove old');
			for(var i:int=0;i<_project.cue_points.length;i++)
			{
				trace(_project.cue_points[i].id+' == ' +cp.time);
				if(_project.cue_points[i].id == cp.time){
					_project.cue_points.removeItemAt(i);
				}	
			}
			
			var o:Object = new Object();			
			o.id = cp.time;		
			o.time = cp.time;
			o.type = cp.type;
			o.name = cp.asset.title;
			o.asset = cp.asset.type;
			o.duration = cp.duration;
			o.cuepoint = cp;
			trace(ObjectUtil.toString(o));
			_project.cue_points.addItem(o);
			_project.cue_points.sort = sort;
			_project.cue_points.refresh();
			
			sendNotification(ApplicationFacade.CUE_POINT_SAVED);
			
			return true;
		}
		
		
		public function createExistingProject(xmlUrl:String):void
		{
			_defaultDirectory = new File(xmlUrl);
			trace('create existing project from manifest '+xmlUrl);
			xmlLoader = new XMLLoader('file://'+xmlUrl+'/kue.xml');
            xmlLoader.addEventListener(XMLLoader.XML_LOADED, onXMLLoaded);
            xmlLoader.load();			
		}
		
		public function onXMLLoaded(e:Event):void 
		{
			//Remove XML Load Event Listener
			xmlLoader.removeEventListener(XMLLoader.XML_LOADED, onXMLLoaded);
			//Read XML Data
			var km:XML = xmlLoader.getXML();
			
			_project.name = km.name;
			_project.description = km.description;
			_project.modified_by = km.modified_by;
			
			var pa:Asset = new Asset();
			pa.file_name = km.primary_asset.asset[0].file_name;
			pa.type = km.primary_asset.asset[0].type;
			pa.title = km.primary_asset.asset[0].title;
			pa.width = km.primary_asset.asset[0].width;
			pa.height = km.primary_asset.asset[0].height;
			pa.x = km.primary_asset.asset[0].x;
			pa.y = km.primary_asset.asset[0].y;
			pa.length = km.primary_asset.asset[0].length;
			pa.body = km.primary_asset.asset[0].body;
			pa.link = km.primary_asset.asset[0].link;
			pa.created_at = new Date(km.primary_asset.asset[0].created_at.toString());
			pa.created_by = km.primary_asset.asset[0].created_by;
			pa.modified_at = new Date(km.primary_asset.asset[0].modified_at.toString());
			pa.modified_by = km.primary_asset.asset[0].modified_by;
			_project.primary_asset = pa;
			
			_primaryAsset = pa;
			_primaryAssetFile = File.desktopDirectory.resolvePath(_defaultDirectory.nativePath+'/assets/'+pa.file_name);
			//trace(_primaryAssetFile.url);
			var cp:CuePoint;
			var cpa:Asset;
			var cpe:*;
			
			
				var sort:Sort = new Sort();
				sort.fields = [new SortField('time', false,false,new Object())];
				var o:Object;
			
			for (var i:int = 0; i < km.cue_points.cue_point.length(); i++) {
				cp = new CuePoint();
				cp.type = km.cue_points.cue_point[i].type;
				cp.time = km.cue_points.cue_point[i].time;
				cp.name = km.cue_points.cue_point[i].name;
				cp.duration = km.cue_points.cue_point[i].duration;
				cp.created_at = new Date(km.cue_points.cue_point[i].created_at.toString());
				cp.created_by = km.cue_points.cue_point[i].created_by;
				cp.modified_at = new Date(km.cue_points.cue_point[i].modified_at.toString());
				cp.modified_by = km.cue_points.cue_point[i].modified_by;
				
				cpa = new Asset();
				cpa.file_name = km.cue_points.cue_point[i].asset.file_name;
				cpa.type = km.cue_points.cue_point[i].asset.type;
				cpa.title = km.cue_points.cue_point[i].asset.title;
				cpa.width = km.cue_points.cue_point[i].asset.width;
				cpa.height = km.cue_points.cue_point[i].asset.height;
				cpa.x = km.cue_points.cue_point[i].asset.x;
				cpa.y = km.cue_points.cue_point[i].asset.y;
				cpa.length = km.cue_points.cue_point[i].asset.length;
				cpa.body = km.cue_points.cue_point[i].asset.body;
				cpa.link = km.cue_points.cue_point[i].asset.link;
				cpa.created_at = new Date(km.cue_points.cue_point[i].asset.created_at.toString());
				cpa.created_by = km.cue_points.cue_point[i].asset.created_by;
				cpa.modified_at = new Date(km.cue_points.cue_point[i].asset.modified_at.toString());
				cpa.modified_by = km.cue_points.cue_point[i].asset.modified_by;
				cp.asset = cpa;
				
				trace(km.cue_points.cue_point[i].player_events.player_event.length())
				for (var j:int = 0; j < km.cue_points.cue_point[i].player_events.player_event.length(); j++) {
					trace(km.cue_points.cue_point[i].player_events.player_event[j].name)
					switch ( km.cue_points.cue_point[i].player_events.player_event[j].name.toString() ) {
						case 'pause-video':
							cpe = new PauseVideoEvent();
							trace(ObjectUtil.toString(cpe))
							cp.player_events.push(cpe);
							break;
						case 'pause-video-for-duration':
							cpe = new PauseVideoForDurationEvent();
							cp.player_events.push(cpe);
							break;
						case 'minify-video':
							cpe = new PauseVideoForDurationEvent();
							cp.player_events.push(cpe);
							break;
					} 
				}
				
				//trace('pay attention ... '+ObjectUtil.toString(cp))
				o = new Object();			
				o.id = cp.time;		
				o.time = cp.time;
				o.type = cp.type;
				o.name = cp.asset.title;
				o.asset = cp.asset.type;
				o.duration = cp.duration;
				o.cuepoint = cp;
				
				_project.cue_points.addItem(o);
				_project.cue_points.sort = sort;
				_project.cue_points.refresh();
				
			}
			
			//trace(ObjectUtil.toString(_project));
			sendNotification(ApplicationFacade.PROJECT_INITIALIZED);
			sendNotification(ApplicationFacade.CUEPOINT_XML_CHANGED);
		}
		
		
		public function generateXMLProject():String
		{
			var nd:Date = new Date();
			var pxml:String = '<project>\n'
			+ '<name><![CDATA['+_project.name+']]></name>\n'
			+ '<description><![CDATA['+_project.description+']]></description>\n'
			+ '<primary_asset>\n'
			+ generateXMLAsset(_primaryAsset)
			+ '</primary_asset>\n'
			+ '<cue_points>\n'
			+ generateXMLCuePoints(_project.cue_points.source)
			+ '</cue_points>\n'
			+ '<created_at><![CDATA['+nd.toString()+']]></created_at>\n'
			+ '<created_by><![CDATA['+_project.modified_by+']]></created_by>\n'
			+ '<modified_at><![CDATA['+nd.toString()+']]></modified_at>\n'
			+ '<modified_by><![CDATA['+_project.modified_by+']]></modified_by>\n'
			+ '</project>';
			
			return pxml;
		}
		
		public function generateXMLCuePoints(cpoints:Array):String
		{
			var nd:Date = new Date();
			var cpxml:String;
			var cp:CuePoint;
			
			for(var i:int=0;i<cpoints.length;i++)
			{
				cp = cpoints[i].cuepoint;
				cpxml = '\n'
				+ '<cue_point>\n'
				+ '<type><![CDATA['+cp.type+']]></type>\n'
				+ '<time><![CDATA['+cp.time+']]></time>\n'
				+ '<name><![CDATA['+cp.name+']]></name>\n'
				+ '<duration><![CDATA['+cp.duration+']]></duration>\n'
				+ generateXMLAsset(cp.asset)
				+ '<player_events>\n'
				+ generateXMLPlayerEvents(cp.player_events)
				+ '</player_events>\n'
				+ '<created_at><![CDATA['+nd.toString()+']]></created_at>\n'
				+ '<created_by><![CDATA['+_project.modified_by+']]></created_by>\n'
				+ '<modified_at><![CDATA['+nd.toString()+']]></modified_at>\n'
				+ '<modified_by><![CDATA['+_project.modified_by+']]></modified_by>\n'
				+ '</cue_point>';
					
			}
			return cpxml;
		}
		
		public function generateXMLPlayerEvents(pevents:Array):String
		{
			var nd:Date = new Date();
			var pexml:String;
			var pe:*;
			
			for(var i:int=0;i<pevents.length;i++)
			{
				pe = pevents[i].getPlayerEvent();
				pexml = '<player_event>\n'
				+ '<name><![CDATA['+pe.name+']]></name>\n'
				+ '<params>\n';
				for(var j:int=0;j<pe.params.length;j++)
				{
					pexml = pexml + '<' + pe.params[j]['label'].toString() + '>' + pe.params[j]['data'].toString() + '</' + pe.params[j]['label'].toString() + '>'; 
				}
				pexml = pexml + '</params>\n'
				+ '</player_event>';
			}
			return pexml;
		}
		
		public function generateXMLAsset(a:Asset):String
		{
			var nd:Date = new Date();
			var axml:String = '<asset>\n'
			+ '<file_name><![CDATA['+a.file_name+']]></file_name>\n'
			+ '<type><![CDATA['+a.type+']]></type>\n'
			+ '<title><![CDATA['+a.title+']]></title>\n'
			+ '<width><![CDATA['+a.width+']]></width>\n'
			+ '<height><![CDATA['+a.height+']]></height>\n'
			+ '<x><![CDATA['+a.x+']]></x>\n'
			+ '<y><![CDATA['+a.y+']]></y>\n'
			+ '<length><![CDATA['+a.length+']]></length>\n'
			+ '<body><![CDATA['+a.body+']]></body>\n'
			+ '<link><![CDATA['+a.link+']]></link>\n'
			+ '<created_at><![CDATA['+nd.toString()+']]></created_at>\n'
			+ '<created_by><![CDATA['+_project.modified_by+']]></created_by>\n'
			+ '<modified_at><![CDATA['+nd.toString()+']]></modified_at>\n'
			+ '<modified_by><![CDATA['+_project.modified_by+']]></modified_by>\n'
			+ '</asset>';
			
			return axml;
		}
		
		
		public function generateFLVCoreCuePointsXML(cpoints:Array):String
		{
			var nd:Date = new Date();
			var cpxml:String = '<FLVCoreCuePoints>';
			var cp:CuePoint;
			var pe:*;
			
			for(var i:int=0;i<cpoints.length;i++)
			{
				cp = cpoints[i].cuepoint;
				cpxml = cpxml +'\n'
				+ '<CuePoint>\n'
				+ '<Time><![CDATA['+cp.time+']]></Time>\n'
				+ '<Type><![CDATA['+cp.type+']]></Type>\n'
				+ '<Name><![CDATA['+cp.name+']]></Name>\n'
				+ '<Parameters>\n'
				+ '<Parameter><Name>duration</Name><Value><![CDATA['+cp.duration+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_type</Name><Value><![CDATA['+cp.asset.type+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_file</Name><Value><![CDATA['+cp.asset.file_name+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_width</Name><Value><![CDATA['+cp.asset.width+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_height</Name><Value><![CDATA['+cp.asset.height+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_x</Name><Value><![CDATA['+cp.asset.x+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_y</Name><Value><![CDATA['+cp.asset.y+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_length</Name><Value><![CDATA['+cp.asset.length+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_body</Name><Value><![CDATA['+cp.asset.body+']]></Value></Parameter>\n'
				+ '<Parameter><Name>asset_link</Name><Value><![CDATA['+cp.asset.link+']]></Value></Parameter>\n';
				for(var j:int=0;j<cp.player_events.length;j++)
				{
					pe = cp.player_events[j].getPlayerEvent();
					for(var n:int=0;n<pe.params.length;n++)
					{
						cpxml = cpxml + '<Parameter><Name>event_' + pe['name'].toString()+'_' + pe.params[n]['label'].toString() + '</Name><Value>' + pe.params[n]['data'].toString() + '</Value></Parameter>\n';
					}
				}
				cpxml = cpxml + '</Parameters>\n'
				+ '</CuePoint>';
					
			}
			cpxml = cpxml + '</FLVCoreCuePoints>';
			return cpxml;
		}
	}
}