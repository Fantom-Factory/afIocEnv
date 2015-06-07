using build

class Build : BuildPod {

	new make() {
		podName = "afIocEnv"
		summary = "A library for determining the application environment; dev, test or prod"
		version = Version("1.0.19")

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

			"afIoc       2.0.0  - 2.0", 
			"afIocConfig 1.0.16 - 1.0"
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [`doc/`]
	}
}
