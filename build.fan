using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.0.1")

		meta = [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "IoC Env",
			"proj.uri"		: "http://repo.status302.com/doc/afIocEnv",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afiocenv",
			"license.name"	: "BSD 2-Clause License",	
			"repo.private"	: "true",

			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]


		index = [	
			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]


		depends = [
			"sys 1.0", 
			"afIoc 1.5.4+", 
			"afIocConfig 1+"
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true

		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
	}
}
