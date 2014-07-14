package mui.module.samsung;

/**
	Supports reading and writing texts. Binary format file is not supported.
**/
#if !browser
@:native("FileSystem") extern
#end
class FileSystem
{
	public function new():Void {}

	/**
		Opens file in common storage area of an application.
		
		With this method, all the applications operate to input and output files in the same area. Due to this feature,
		the case that files used in other applications have the same name happens. It is required to create directories
		using application ID via `curWidget.id` and execute file operations in the directory.
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var fileObj = fileSystemObj.openCommonFile(curWidget.id + '/testFile.data', 'w');
			fileObj.writeAll('something to write.');
			fileSystemObj.closeCommonFile(fileObj);
		
		@param filePath path including a file name.
		@param mode
			"r" 	Open a file for reading. The file must exist.
			"w" 	Create an empty file for writing. If a file with the same 
					name already exists its content is erased and the file is 
					treated as a new empty file.
			"a" 	Append to a file. Writing operations append data at the end 
					of the file. The file is created if it does not exist.
			"r+" 	Open a file for update both reading and writing. The file 
					must exist.
			"w+"	Create an empty file for both reading and writing. If a 
					file with the same name already exists its content is 
					erased and the file is treated as a new empty file.
			"a+" 	Open a file for reading and appending. All writing 
					operations are performed at the end of the file, protecting 
					the previous content to be overwritten. You can reposition 
					(fseek, rewind) the internal pointer to anywhere in the 
					file for reading, but writing operations will move it back 
					to the end of file. The file is created if it does not exist.
	**/
	public function openCommonFile(filePath:String, mode:String):File {}

	/**
		Closes files opened by openCommonFile().
		
		Opened files should be closed. Especially, if a file is outputted by methods such as writeAll(), the output is not
		saved without closing the file object.
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var fileObj = fileSystemObj.openCommonFile(curWidget.id + '/testFile.data', 'w');
			fileObj.writeAll('something to write.');
			fileSystemObj.closeCommonFile(fileObj);
		
		@param fileObj The file instance returned by openCommonFile()
	**/
	public function closeCommonFile(fileObj:File):Bool {}

	/**
		Deletes files in Input/Output area
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var bResult = fileSystemObj.deleteCommonFile(curWidget.id + '/testFile.data');
		
		@param filePath path including the name of a file to delete
	**/
	public function deleteCommonFile(filePath:String):Bool {}

	/**
		Creates directories in file input/output area
		
		Creating a directory named curWidget.id to avoid crash between file names in other applications.
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var bResult = fileSystemObj.createCommonDir(curWidget.id);
		
		@param directoryPath path including the name of a directory to create
	**/
	public function createCommonDir(directoryPath:String):Bool {}

	/**
		Deletes directories in file input/out area
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var bResult = fileSystemObj.deleteCommonDir(curWidget.id);
		
		@param directoryPath path including a name of directory to delete
	**/
	public function deleteCommonDir(directoryPath:String):Bool {}

	/**
		Checks if there is a directory
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var bValid = fileSystemObj.isValidCommonPath(curWidget.id);
			if (!bValid) {
					fileSystemObj.createCommonDir(curWidget.id);
			}
		
		@param directoryPath path including a name of directory to confirm its existence
		
		@return
				0 : JS function failed  (directory does not exist - new directory needs to be created)
				1 : valid  (directory already exists)
				2 : invalid  (invalid path - directory cannot be created)
	**/
	public function isValidCommonPath(directoryPath:String):Int {}

	/**
		Able to see file information in USB
		
		File information in USB can be brought by „$USB_DIR‟. For the way to find out mounted path of USB,
		refer to storage plugin of Plugin guide.
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var usbPath = '$USB_DIR' + usb_mount_path;
			var arrFiles = fileSystemObj.readDir(usbPath);
			if (arrFiles) {
					for (var i=0; i < arrFiles.length; i++) {
						alert(arrFiles[i].name);
						alert(arrFiles[i].isDir);
					}
			}
		
		@param directoryPath Path of a directory that you want to see. Wors only for USB directory
		
		@return 	The Array containing file information. Each element has file information in a directory.
					Able to get information by referring to variables below.
						name : file name
						isDir : If a file is a directory, „true‟, if not, „false‟
						size : File Size (byte)
						atime : The time when to open a file or access time to a directory with cd command
						mtime : The time when file contents are changed
						ctime : The time when file information is changed
		
					If there is no directoryPath, return „false‟.
		
		TODO use "overload" modifier (with new haXe version) to support either String return ("false") or Array<DirectoryData>
	**/
	public function readDir(directoryPath:String):Array<DirectoryData> {}

	/**
		Opens files in an application
		
		openCommonFile() enablies files to input and output in common area of all applications, on the other hand,
		openFile() is only able to „read‟ files in directory where an application is installed.
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var fileObj = fileSystemObj.openFile('index.html', 'r');
			alert(fileObj.readAll());
			fileSystemObj.closeFile(fileObj);
		
		@param filePath path including a file name
		@param mode
				"r" : Open a file for reading. The file must exist. *only r mode is available.
	**/
	public function openFile(filePath:String, mode:String):File {}

	public function toString():String;
}

typedef DirectoryData = {
	var name:String;
	var isDir:String;
	var size:String;
	var atime:String;
	var mtime:String;
	var ctime:String;
}

@:native("File")
extern class File
{
	public function new():Void;

	/**
		Reads a line in an opened file
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var fileObj = fileSystemObj.openCommonFile(curWidget.id + '/testFile.data', 'r');
			var strLine = '';
			var arrResult = new Array();
			while((strLine=fileObj.readLine()) != "null") {
					arrResult.push(strLine);
			}

		@return Returns a line ranging to line feed character as a result. If there is nothing to read, return „null‟.
	**/
	public function readLine():String;

	/**
		Writes a line in an opened file
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var fileObj = fileSystemObj.openCommonFile(curWidget.id + '/testFile.data', 'w');
			fileObj.writeLine('something to write.');
			fileSystemObj.closeCommonFile(fileObj);
		
		@param text text to write in a file
	**/
	public function writeLine(text:String):Bool;

	/**
		Reads whole of the opened file
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var fileObj = fileSystemObj.openCommonFile(curWidget.id + '/testFile.data', 'r');
			var strResult = fileObj.readAll();
			alert(strResult);
		
		@return Whole contents of the file
	**/
	public function readlAll():String;

	/**
		Writes several lines in the opened file
		
		Example usage:
		
			var fileSystemObj = new FileSystem();
			var fileObj = fileSystemObj.openCommonFile(curWidget.id + '/testFile.data', 'w');
			fileObj.writeAll('something to write.');
			fileSystemObj.closeCommonFile(fileObj);
		
		@param text text to write in a file
	**/
	public function writeAll(text:String):Bool;

	public function toString():String;
}
