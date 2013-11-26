
const class IocEnv {
	private static const Log log	:= IocEnv#.pod.log
	
	const Str?	env
	const Bool	isProd
	const Bool	isTest
	const Bool	isDev

	private const Str[]	debug
	
	new make() {
		debug	:= [,]
		env		:= (Str?) null

		if (Env.cur.vars.containsKey("env")) {
			env = Env.cur.vars["env"]
			addDebug(debug, "environment variable", "env", env)
		}

		if (Env.cur.vars.containsKey("environment")) {
			env = Env.cur.vars["environment"]
			addDebug(debug, "environment variable", "environment", env)
		}

		if (Env.cur.args.contains("-env")) {
			index := Env.cur.args.index("-env")
			env    = Env.cur.args.getSafe(index + 1)
			addDebug(debug, "cmd line argument", "-env", env)
		}

		if (Env.cur.args.contains("-environment")) {
			index := Env.cur.args.index("-environment")
			env    = Env.cur.args.getSafe(index + 1)
			addDebug(debug, "cmd line argument", "-environment", env)
		}
		
		// need to mess about with static ctors - wait for v1.0!
//		if (oVeRrIdE != null) {
//			env    = oVeRrIdE
//			addDebug(debug, "manual", "override", env)
//		}
		
		if (env == null || env.isEmpty) {
			env = "PRODUCTION"
			debug.add("Environment has not been configured. Defaulting to 'PRODUCTION'")
		}

		this.env	= env
		this.debug	= debug
		this.isProd	= "production" .equalsIgnoreCase(env) || "prod".equalsIgnoreCase(env)
		this.isTest	= "testing"    .equalsIgnoreCase(env) || "test".equalsIgnoreCase(env)
		this.isDev	= "development".equalsIgnoreCase(env) || "dev" .equalsIgnoreCase(env)
	}
	
	Void logDebug() {
		debug.each { log.info(it) }
	}
	
	override Str toStr() {
		(env == null) ? "IocEnv::PRODUCTION" : "IocEnv::${env}"
	}
	
	private Void addDebug(Str[] debug, Str from, Str name, Str env) {
		// Setting from environment variable 'env' : dev
		// Overriding from cmd line argument 'env' : TEST
		msg := (debug.isEmpty ? "Setting" : "Overriding") + " from ${from} '${name}' : ${env}"
		debug.add(msg)
	}
}
