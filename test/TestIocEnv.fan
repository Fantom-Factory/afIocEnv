using afIoc

internal class TestIocEnv : Test {

	Void testDefaultsToProd() {
		env := IocEnvImpl.findEnv([,], [:], [,], null)
		verifyEq(env, "PRODUCTION")
	}

	Void testPicksUpEnvVar() {
		env := IocEnvImpl.findEnv([,], ["env":"Fire"], [,], null)
		verifyEq(env, "Fire")

		env = IocEnvImpl.findEnv([,], ["environment":"Ice"], [,], null)
		verifyEq(env, "Ice")
	}

	Void testPicksUpProgArgs() {
		env := IocEnvImpl.findEnv([,], [:], "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, null)
		verifyEq(env, "Fire")

		env = IocEnvImpl.findEnv([,], [:], "afBedSheet::MainProxied -pingProxy -pingProxyPort -environment Ice 8069 afWebsite 8070".split, null)
		verifyEq(env, "Ice")
	}

	Void testPicksUpOverride() {
		env := IocEnvImpl.findEnv([,], [:], [,], "Fire")
		verifyEq(env, "Fire")
	}
	
	Void testProgArgsTrumpEnvVar() {
		env := IocEnvImpl.findEnv([,], ["environment":"Ice"], "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, null)
		verifyEq(env, "Fire")
	}

	Void testOverrideTrumpProgArgs() {
		env := IocEnvImpl.findEnv([,], ["environment":"Ice"], "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, "Pigs")
		verifyEq(env, "Pigs")
	}

	Void testProgArgsEdgeCases() {
		env := IocEnvImpl.findEnv([,], ["environment":"Ice"], "-env".split, null)
		verifyEq(env, "Ice")
	}

	Void testIocOverride() {
		reg := RegistryBuilder().addModule(T_AppModule#).build.startup

		iocEnv := (IocEnv) reg.dependencyByType(IocEnv#)
		
		verifyEq(iocEnv.env, "MoFo")
	}
}

internal class T_AppModule {

	static Void bind(ServiceBinder binder) {
		binder.bind(IocEnv#)
	}	

	@Contribute { serviceType=ServiceOverrides# }
	static Void contributeServiceOverrides(Configuration config) {
		config[IocEnv#] = IocEnv.fromStr("MoFo")
	}
}
