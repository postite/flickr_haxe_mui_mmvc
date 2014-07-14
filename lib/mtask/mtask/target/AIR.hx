package mtask.target;

/**
	A Flash application target packaged by Adobe AIR.
**/
class AIR extends Flash
{
	static var DEFAULT_KEYSTORE = "${lib.mtask}module/air/resource/certificate.p12";
	static var DEFAULT_STOREPASS = "Q01EByaoqOI4iYAXYl7yOI";

	public var keystore:String;
	public var storepass:String;
	public var airTarget:String;

	public function new()
	{
		super();
		flags.push("air");
		keystore = replaceArgs(DEFAULT_KEYSTORE);
		storepass = DEFAULT_STOREPASS;
	}

	override function bundle()
	{
		if (keystore == DEFAULT_KEYSTORE)
		{
			Console.warn("Signing application with default mtask certificate. This is fine for development, but not for production!");
		}

		var args = [];
		args.push("-package");

		// signing
		args.push("-storetype");
		args.push("pkcs12");

		args.push("-keystore");
		args.push(keystore);

		args.push("-storepass");
		args.push(storepass);

		if(airTarget == "nativeWin")
		{
			// target native
			args.push("-target");
			args.push("native");

			// output win exe
			args.push(path + ".exe");
			args.push(path + "/manifest.xml");
		}
		else if(airTarget == "nativeMac")
		{
			// target native
			args.push("-target");
			args.push("native");

			// output mac dmg
			args.push(path + ".dmg");
			args.push(path + "/manifest.xml");
		}
		else
		{
			// target air
			args.push("-target");
			args.push("air");

			// output air
			args.push(path + ".air");
			args.push(path + "/manifest.xml");
		}

		// files
		args.push("-C");
		args.push(path);
		args.push(".");

		// only compile if release
		if (!debug)
		{
			mtask.tool.AIR.adt(args);
		}
	}

	override public function run()
	{
		if (debug)
		{
			mtask.tool.AIR.adl([path + "/manifest.xml"]);
		}
		else
		{
			open(path + ".air");
		}
	}
}
