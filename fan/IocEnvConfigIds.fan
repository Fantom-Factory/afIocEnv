
** Config values as provided by afIocEnv.
const mixin IocEnvConfigIds {
	
	** Returns the environment Str.
	static const Str	env		:= "afIocEnv.env"

	** Returns 'true' if environment is 'prod', 'production' or *undefined*.
	static const Str	isProd	:= "afIocEnv.isProd"

	** Returns 'true' if environment is 'test' or 'testing'.
	static const Str	isTest	:= "afIocEnv.isTest"

	** Returns 'true' if environment is 'dev' or 'development'.
	static const Str	isDev	:= "afIocEnv.isDev"
}
