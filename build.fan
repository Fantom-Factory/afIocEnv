using build

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.0.6")

		meta = [
			"proj.name"		: "IoC Env",
			"afIoc.module"	: "afIocEnv::IocEnvModule",
			"tags"			: "system",
			"repo.private"	: "false",
		]

		index = [	
			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]

		depends = [
			"sys 1.0", 

			"afIoc 1.6.4+", 
			"afIocConfig 1.0.8+"
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [,]
	}
}
