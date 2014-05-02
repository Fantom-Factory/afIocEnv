using build

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.0.4")

		meta = [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "IoC Env",
			"proj.uri"		: "http://www.fantomfactory.org/pods/afIocEnv",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afiocenv",
			"license.name"	: "The MIT Licence",	
			"repo.private"	: "false",

			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]


		index = [	
			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]

		depends = [
			"sys 1.0", 
			"afIoc 1.6.0+", 
			"afIocConfig 1.0.4+"
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [`licence.txt`, `doc/`]

		docApi = true
		docSrc = true
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// see "stripTest" in `/etc/build/config.props` to exclude test src & res dirs
		super.compile
		
		// copy src to %FAN_HOME% for F4 debugging
		log.indent
		destDir := Env.cur.homeDir.plus(`src/${podName}/`)
		destDir.delete
		destDir.create		
		`fan/`.toFile.copyInto(destDir)		
		log.info("Copied `fan/` to ${destDir.normalize}")
		log.unindent
	}
}
