
const class IocEnv {
	private static const Log log	:= IocEnv#.pod.log

	const Str	env
	const Bool	isProd
	const Bool	isTest
	const Bool	isDev

	private const Str[]	debug
	private const Str?	overRIDE

	new make(|This|? f := null) {
		debug	:= [,]
		
		f?.call(this)	// use to set override
		this.env	= findEnv(debug, Env.cur.vars, Env.cur.args, overRIDE)
		
		this.debug	= debug
		this.isProd	= "production" .equalsIgnoreCase(env) || "prod".equalsIgnoreCase(env)
		this.isTest	= "testing"    .equalsIgnoreCase(env) || "test".equalsIgnoreCase(env)
		this.isDev	= "development".equalsIgnoreCase(env) || "dev" .equalsIgnoreCase(env)
	}

	static IocEnv fromStr(Str environment) {
		IocEnv() { it.overRIDE = environment }
	}

	Void logToInfo() {
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
			env    = args.getSafe(index + 1)
			addDebug(debug, "cmd line argument", "-env", env)
		}

		if (args.contains("-environment")) {
			index := args.index("-environment")
			env    = args.getSafe(index + 1)
			addDebug(debug, "cmd line argument", "-environment", env)
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
	
	private static Void addDebug(Str[] debug, Str from, Str name, Str? env) {
		if (env == null)
			return
		// Setting from environment variable 'env' : dev
		// Overriding from cmd line argument 'env' : TEST
		msg := (debug.isEmpty ? "Setting" : "Overriding") + " from ${from} '${name}' : ${env}"
		debug.add(msg)
	}
}
