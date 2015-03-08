
** (Service) - Holds the 'environment' with some hand utility methods.
** 
** Although a 'mixin', implementations may still be made with the following code:
** 
**   iocEnv := IocEnv()
** 
** Or pass in an override with: 
** 
**   iocEnv := IocEnv("prod")
** 
const mixin IocEnv {
	
	** Returns the environment Str.
	abstract Str env()

	** Returns 'true' if the environment is 'prod', 'production' or *undefined*.
	abstract Bool isProd()

	** Returns 'true' if the environment is 'test' or 'testing'.
	abstract Bool isTest()
	
	** Returns 'true' if the environment is 'dev' or 'development'.
	abstract Bool isDev()

	** Returns 'true' if the environment matches the given 'env' in a case insensitive match.
	abstract Bool isEnv(Str env)
	
	** Logs environment to info.
	abstract Void logToInfo()
	
	** Returns the environment in abbreviated form; 'dev, test, prod'. Or just the env in lowercase if not recognised.
	abstract Str abbr()
		
	** Create an 'IocEnv' with the given (optional) environment override. This may be invoked via the ctor syntax: 
	** 
	**   iocEnv := IocEnv("prod")
	static new fromStr(Str? environmentOverride := null) {
		IocEnvImpl(environmentOverride)
	}
}

internal const class IocEnvImpl : IocEnv {
	private static const Log log	:= IocEnv#.pod.log

	override const Str	env
	override const Bool	isProd
	override const Bool	isTest
	override const Bool	isDev

			const Str[] debug
			const Str?	overRIDE

	
	new make(Str? overRIDE, |This|? f := null) {
		debug	:= [,]
		
		this.overRIDE	= overRIDE
		this.env		= findEnv(debug, Env.cur.vars, Env.cur.args, overRIDE)
		this.debug		= debug
		this.isProd		= "production" .equalsIgnoreCase(env) || "prod".equalsIgnoreCase(env)
		this.isTest		= "testing"    .equalsIgnoreCase(env) || "test".equalsIgnoreCase(env)
		this.isDev		= "development".equalsIgnoreCase(env) || "dev" .equalsIgnoreCase(env)
		
		// not currently use for anything - but it's a nice get out of jail card
		f?.call(this)
	}

	override Bool isEnv(Str env) {
		this.env.equalsIgnoreCase(env)
	}

	override Void logToInfo() {
		debug.each { log.info(it) }
	}

	override Str abbr() {
		if (isProd)	return "prod"
		if (isTest)	return "test"
		if (isDev)	return "dev"
		return env.lower
	}

	override Str toStr() {
		env
	}
	
	static Str findEnv(Str[] debug, Str:Str vars, Str[] args, Str?	overRIDE) {
		env		:= (Str?) null
		
		if (vars.containsKey("env")) {
			env = vars["env"]
			addDebug(debug, "environment variable", "env", env)
		}

		if (vars.containsKey("environment")) {
			env = vars["environment"]
			addDebug(debug, "environment variable", "environment", env)
		}

		if (args.contains("-env")) {
			index := args.index("-env")
			if (args.size > (index+1)) {
				env    = args.get(index + 1)
				addDebug(debug, "cmd line argument", "-env", env)
			}
		}

		if (args.contains("-environment")) {
			index := args.index("-environment")
			if (args.size > (index+1)) {
				env    = args.get(index + 1)
				addDebug(debug, "cmd line argument", "-environment", env)
			}
		}
		
		if (overRIDE != null) {
			env    = overRIDE
			addDebug(debug, "manual", "override", env)
		}
		
		if (env == null || env.isEmpty) {
			env = "PRODUCTION"
			debug.add("Environment has not been configured. Defaulting to 'PRODUCTION'")
		}
		
		return env
	}
	
	private static Void addDebug(Str[] debug, Str from, Str name, Str env) {
		// Setting from environment variable 'env' : dev
		// Overriding from cmd line argument 'env' : TEST
		msg := (debug.isEmpty ? "Setting" : "Overriding") + " from ${from} '${name}' : ${env}"
		debug.add(msg)
	}
}
