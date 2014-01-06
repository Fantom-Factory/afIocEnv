using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.0.1")

		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/AlienFactory/afiocenv",
					"proj.name"		: "Ioc Env",
					"license.name"	: "BSD 2-Clause License",	
					"repo.private"	: "true"

					,"afIoc.module"	: "afIocEnv::IocEnvModule"
				]


		index	= [	"afIoc.module"	: "afIocEnv::IocEnvModule"
				]


		depends = ["sys 1.0", "afIoc 1.4.10+", "afIocConfig 0+"]
		srcDirs = [`test/`, `fan/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true

		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
	}
}
