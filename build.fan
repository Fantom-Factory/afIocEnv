using build

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.1.0")

		meta = [
			"proj.name"		: "IoC Env",
			"afIoc.module"	: "afIocEnv::IocEnvModule",
			"repo.tags"		: "system",
			"repo.public"	: "false"
		]

		index = [	
			"afIoc.module"	: "afIocEnv::IocEnvModule"
		]

		depends = [
			"sys 1.0", 

			"afIoc       3.0.0 - 3.0",
			"afIocConfig 1.1.0 - 1.1"
		]

		srcDirs = [`fan/`, `test/`]
		resDirs = [`doc/`]
	}
}
