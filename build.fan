using build

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.0.15")

		meta = [
			"proj.name"		: "IoC Env",
			"afIoc.module"	: "afIocEnv::IocEnvModule",
			"tags"			: "system",
			"repo.private"	: "true"
		]

		index = [	
			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]

		depends = [
			"sys 1.0", 

			"afIoc 2.0.0+", 
			"afIocConfig 1.0.16+"
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [,]
	}
}
