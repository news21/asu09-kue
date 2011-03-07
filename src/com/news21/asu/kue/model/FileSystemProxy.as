package com.news21.asu.kue.model
{
	import com.news21.asu.kue.ApplicationFacade;
	
	//import deng.fzip.*;
	import flash.utils.ByteArray;
	import  nochump.util.zip.*;
	import flash.utils.IDataInput;
	
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.*;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.interfaces.*;

	public class FileSystemProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'FileSystemProxy';
		 
		private var defaultDirectory:File;
		private var tempDir:File;
		//private var zip:FZip;
		private var zipFile:ZipOutput;
		private var fileChooser:File;
		private var _defaultDirectory:File;
		
		public function FileSystemProxy( ) {
			super( NAME );
			
			_defaultDirectory = File.documentsDirectory;
		}
		
		
		public function importExistingZip():void 
		{	
			var zipFilter:FileFilter = new FileFilter("Kue Zip", "*.zip");
			fileChooser = _defaultDirectory;
				
			fileChooser.browseForOpen("Open",[zipFilter]);
			fileChooser.addEventListener(Event.SELECT, zipOpenSelected);
		}
		private function zipOpenSelected(event:Event):void 
		{
			//zip = new FZip();
			zipFile = new ZipOutput();
			fileChooser.removeEventListener(Event.SELECT,zipOpenSelected);
			var tempZip:File = event.target as File;
			
			defaultDirectory = File.desktopDirectory.resolvePath( "kue_project" );
			if ( !defaultDirectory.exists )
			{
			   defaultDirectory.createDirectory();
			}
			else
			{
				var time:Date= new Date();
				var txt:String = String(time.hours)+""+String(time.minutes)+""+String(time.seconds)+""+String(time.milliseconds);
				defaultDirectory = File.desktopDirectory.resolvePath( "kue_project"+"_"+txt );
				defaultDirectory.createDirectory();
			}
			 
			var stream:FileStream = new FileStream();  
			stream.open(tempZip,FileMode.READ);
			var zippedFile:ZipFile = new ZipFile(stream);  
			
			for(var i:int = 0; i < zippedFile.entries.length; i++) {
				var zipEntry:ZipEntry = zippedFile.entries[i] as ZipEntry;  
				trace(zipEntry.name);
				var entryFile:File = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+'/'+zipEntry.name );
				// extract the entry's data from the zip
				var entry:FileStream = new FileStream(); 
				entry.open(entryFile, FileMode.WRITE);  
				entry.writeBytes(zippedFile.getInput(zipEntry));  
				entry.close();  
				
			}
			
			sendNotification(ApplicationFacade.CREATE_EXISTING_PROJECT,defaultDirectory.nativePath);
			/*
			var ur:URLRequest = new URLRequest(tempZip.url);
			zip.addEventListener(Event.COMPLETE, unzipProjectAndBuild);
			zip.load(ur);
			trace(zip.active);
			trace(zip.getFileCount());
			*/
			
			/*
			var bytes:ByteArray = new ByteArray();
			var flNameLength:Number; 
			var xfldLength:Number;
			var offset:Number;
			var compSize:Number; 
			var uncompSize:Number;
			var compMethod:int;
			var signature:int;
			
			var tempstream:FileStream = new FileStream();
			
			tempstream.open(tempZip, FileMode.READ);
			
			bytes.endian = Endian.LITTLE_ENDIAN;
			while (tempstream.position < tempZip.size) 
    		{
    			tempstream.readBytes(bytes, 0, 30);
    			bytes.position = 0; 
		        signature = bytes.readInt(); 
				trace(signature);
			
		        // if no longer reading data files, quit 
		        if (signature != 0x04034b50) 
		        { 
		            break; 
		        }
		        bytes.position = 8; 
        		compMethod = bytes.readByte();  // store compression method (8 == Deflate)
        		trace(compMethod)
        		offset = 0;    // stores length of variable portion of metadata  
		        bytes.position = 26;  // offset to file name length 
		        flNameLength = bytes.readShort();    // store file name 
		        offset += flNameLength;     // add length of file name 
		        bytes.position = 28;    // offset to extra field length 
		        xfldLength = bytes.readShort(); 
		        offset += xfldLength;    // add length of extra field
		        
		        // read variable length bytes between fixed-length header and compressed file data 
        		tempstream.readBytes(bytes, 30, offset);
        		
        		// read compressed file to offset 0 of bytes; for uncompressed files 
    			// the compressed and uncompressed size is the same 
    			tempstream.readBytes(bytes, 0, compSize);
    			
    			if (compMethod == 8) // if file is compressed, uncompress 
		        { 
		            bytes.uncompress(CompressionAlgorithm.DEFLATE); 
		        } 
    		}
			
			trace(bytes.length);
			zip.addEventListener(Event.COMPLETE, unzipProjectAndBuild);
			zip.loadBytes( bytes );
			*/
		}
		
		private function unzipProjectAndBuild(e:Event):void
		{
			/*
			//trace('done');
			zip.removeEventListener(Event.COMPLETE, unzipProjectAndBuild);
			var newfile:File;
			var stream:FileStream;
			var zfile:FZipFile;
			
			trace(zip.getFileCount())
			// unzip archive
			for(var i:uint = 0; i < zip.getFileCount(); i++) {
				zfile = zip.getFileAt(i);
				newfile = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+'/'+zfile.filename );
				//trace("  " + i + " (" + zfile.filename + "): " + zfile.getContentAsString());
				if(zfile.filename.indexOf("assets/") == 0){
					trace('should not be decompressed');
					stream = new FileStream();
					stream.open( newfile, FileMode.WRITE );
					stream.writeObject(zfile.content)
					stream.close();
				} else {
					stream = new FileStream();
					stream.open( newfile, FileMode.WRITE );
					stream.writeUTFBytes(zfile.getContentAsString())
					stream.close();
				}
			}
			*/
			
			//sendNotification(ApplicationFacade.CREATE_EXISTING_PROJECT,defaultDirectory.nativePath);
		}
		
		
		public function createNewProjectStructure(passet:File):File {
			defaultDirectory = File.desktopDirectory.resolvePath( "kue_project" );
			if ( !defaultDirectory.exists )
			{
			   defaultDirectory.createDirectory();
			}
			else
			{
				var time:Date= new Date();
				var txt:String = String(time.hours)+""+String(time.minutes)+""+String(time.seconds)+""+String(time.milliseconds);
				defaultDirectory = File.desktopDirectory.resolvePath( "kue_project"+"_"+txt );
				defaultDirectory.createDirectory();
			}
			var a_dir:File = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+"/assets" );
			a_dir.createDirectory();
			
			var pa:File = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+"/assets/"+passet.name );
			passet.copyTo( pa );
			
			writeProjectManifest();
			
			writeCuePoints();
			
			return pa;
		}
		
		public function writeProjectManifest(s:String=null):void
		{
			var manifestxml:File = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+"/kue.xml" );
			var kstream:FileStream = new FileStream();
			kstream.open( manifestxml, FileMode.WRITE );
			var koutputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			if(s!=null)
				koutputString = koutputString+s;
			koutputString = koutputString.replace(/\n/g, File.lineEnding);
			kstream.writeUTFBytes(koutputString);
			kstream.close();
		}
		
		public function writeCuePoints(s:String=null):void
		{
			var cuepointxml:File = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+"/cuepoints.xml" );
			var cstream:FileStream = new FileStream();
			cstream.open( cuepointxml, FileMode.WRITE );
			var coutputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			if(s!=null)
				coutputString = coutputString+s;
			coutputString = coutputString.replace(/\n/g, File.lineEnding);
			cstream.writeUTFBytes(coutputString);
			cstream.close();
			
			sendNotification(ApplicationFacade.CUEPOINT_XML_CHANGED);
		}
		
		public function zipProject():Boolean
		{
			/*
			zip = new FZip();
			addToZip( defaultDirectory );
			
			var file:File = File.desktopDirectory.resolvePath(defaultDirectory.name+".zip");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			zip.serialize(stream);
			stream.close();
			*/
			
			zipFile = new ZipOutput();  
			addToZip( defaultDirectory );
			zipFile.finish();  
			
			var archiveFile:File = File.desktopDirectory.resolvePath(defaultDirectory.name+".zip");
			var stream:FileStream = new FileStream();  
			stream.open(archiveFile,FileMode.WRITE);  
			stream.writeBytes(zipFile.byteArray);  
			stream.close();
			
			return true;
		}
		
		private function addToZip(directoryToZip:File,subPath:String=null):void
		{
			var directory:Array = directoryToZip.getDirectoryListing();
			var dirpath:String = null;
			var zipEntry:ZipEntry;
			
			if(directoryToZip.isDirectory && subPath!=null){
				dirpath = subPath;
			}
			
			for each (var f:File in directory)
			{
				if (f.isDirectory){
					//trace('is dir');
					addToZip(f,f.name);
				} else {
					var fs:FileStream = new FileStream();
					fs.open(f, FileMode.READ);
					var data:ByteArray = new ByteArray();
					fs.readBytes(data);
					fs.close();
					
					if(dirpath != null){
						//trace('want to add file '+dirpath+'/'+f.name);
						zipEntry = new ZipEntry(dirpath+'/'+f.name);  
						
						//zip.addFile(dirpath+'/'+f.name,data);
					} else {
						//trace('want to add file '+f.name);
						zipEntry = new ZipEntry(f.name);  
						//zip.addFile(f.name,data);
					}
					zipFile.putNextEntry(zipEntry);  
					zipFile.write(data);  
					zipFile.closeEntry();
				}
			}
			/*
			var directory:Array = directoryToZip.getDirectoryListing();
			var dirpath:String = null;
			
			if(directoryToZip.isDirectory && subPath!=null){
				dirpath = subPath;
				//trace('want to add directory '+dirpath);
			//} else {
				//trace('is not dir and sub is null');
			}
			
			for each (var f:File in directory)
			{
				if (f.isDirectory){
					//trace('is dir');
					addToZip(f,f.name);
				} else {
					var fs:FileStream = new FileStream();
					fs.open(f, FileMode.READ);
					var data:ByteArray = new ByteArray();
					fs.readBytes(data);
					fs.close();
					
					if(dirpath != null){
						//trace('want to add file '+dirpath+'/'+f.name);
						zip.addFile(dirpath+'/'+f.name,data);
					} else {
						//trace('want to add file '+f.name);
						zip.addFile(f.name,data);
					}
				}
			}
			*/
			
			
		}
		
		/*
		public function unzipExistingProject():void
		{
			zip = new FZip();
			zip.addEventListener(Event.OPEN, onOpen);
			zip.addEventListener(Event.COMPLETE, onComplete);
			zip.load(new URLRequest("famfamfam_silk_icons_v013.zip"));
		}
		
		private function onOpen(evt:Event):void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onComplete(evt:Event):void {
			done = true;
		}

			for(var i:uint = 0; i < zip.getFileCount(); i++) {
				
			}
		}
		
		*/
		
		public function removeAsset(a:String):void
		{
			var a_file:File = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+"/assets/"+a );
			a_file.moveToTrash();
		}
		
		public function copyAsset(a:String):String
		{
			var a_file:File = new File( a );
			var a_dir:File = File.desktopDirectory.resolvePath( defaultDirectory.nativePath+"/assets/"+a_file.name );
			a_file.copyTo(a_dir, true);
			
			return a_file.name;
		}
		
		public function copyInto(directoryToCopy:File, locationCopyingTo:File):void
		{
		  var directory:Array = directoryToCopy.getDirectoryListing();
		               
		  for each (var f:File in directory)
		  {
		    if (f.isDirectory)
		      copyInto(f, locationCopyingTo.resolvePath(f.name));
		    else
		      f.copyTo(locationCopyingTo.resolvePath(f.name), true);
		  }
		
		}
	}
}