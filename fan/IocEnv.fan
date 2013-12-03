
** (Service) - Holds the 'environment' with some hand utility methods.
const mixin IocEnv {
	
	** Returns the environment Str.
	abstract Str	env()

	** Returns 'true' if environment is 'prod', 'production' or *undefined*.
	abstract Bool	isProd()

	** Returns 'true' if environment is 'test' or 'testing'.
	abstract Bool	isTest()
	
	** Returns 'true' if environment is 'dev' or 'development'.
	abstract Bool	isDev()
	
	abstract Void logToInfo()
		
	** Create an 'IocEnv' with the given environment. 
	static IocEnv fromStr(Str environment) {
		IocEnvImpl() { it.overRIDE = environment }
	}
}

internal const class IocEnvImpl : IocEnv {
	private static const Log log	:= IocEnv#.pod.log

	override const Str	env
	override const Bool	isProd
	override const Bool	isTest
	override const Bool	isDev

	internal const Str[]	debug
	internal const Str?	overRIDE

	
	internal new make(|This|? f := null) {
		debug	:= [,]
		
		f?.call(this)	// use to set override
		this.env	= findEnv(debug, Env.cur.vars, Env.cur.args, overRIDE)
		
		this.debug	= debug
		this.isProd	= "production" .equalsIgnoreCase(env) || "prod".equalsIgnoreCase(env)
		this.isTest	= "testing"    .equalsIgnoreCase(env) || "test".equalsIgnoreCase(env)
		this.isDev	= "development".equalsIgnoreCase(env) || "dev" .equalsIgnoreCase(env)
	}

	override Void logToInfo() {
		debug.each { log.info(it) }
	}

	override Str toStr() {
		env
	}
	
	internal static Str findEnv(Str[] debug, Str:Str vars, Str[] args, Str?	overRIDE) {
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
