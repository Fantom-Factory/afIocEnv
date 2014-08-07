using build

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.0.12")

		meta = [
			"proj.name"		: "IoC Env",
			"afIoc.module"	: "afIocEnv::IocEnvModule",
			"tags"			: "system",
			"repo.private"	: "false"
		]

		index = [	
			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]

		depends = [
			"sys 1.0", 

			"afIoc 1.7.2+", 
			"afIocConfig 1.0.12+"
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [,]
	}
}
