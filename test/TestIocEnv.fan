using afIoc

internal class TestIocEnv : Test {
	
	Void testDefaultsToProd() {
		env := IocEnv.findEnv([,], [:], [,], null)
		verifyEq(env, "PRODUCTION")
	}

	Void testPicksUpEnvVar() {
		env := IocEnv.findEnv([,], ["env":"Fire"], [,], null)
		verifyEq(env, "Fire")

		env = IocEnv.findEnv([,], ["environment":"Ice"], [,], null)
		verifyEq(env, "Ice")
	}

	Void testPicksUpProgArgs() {
		env := IocEnv.findEnv([,], [:], "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, null)
		verifyEq(env, "Fire")

		env = IocEnv.findEnv([,], [:], "afBedSheet::MainProxied -pingProxy -pingProxyPort -environment Ice 8069 afWebsite 8070".split, null)
		verifyEq(env, "Ice")
	}

	Void testPicksUpOverride() {
		env := IocEnv.findEnv([,], [:], [,], "Fire")
		verifyEq(env, "Fire")
	}
	
	Void testProgArgsTrumpEnvVar() {
		env := IocEnv.findEnv([,], ["environment":"Ice"], "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, null)
		verifyEq(env, "Fire")
	}

	Void testOverrideTrumpProgArgs() {
		env := IocEnv.findEnv([,], ["environment":"Ice"], "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, "Pigs")
		verifyEq(env, "Pigs")
	}

	Void testProgArgsEdgeCases() {
		env := IocEnv.findEnv([,], [:], "-env".split, null)
		verifyEq(env, "PRODUCTION")
	}

	Void testIocOverride() {
		reg := RegistryBuilder().addModule(T_AppModule#).build.startup

		iocEnv := (IocEnv) reg.dependencyByType(IocEnv#)
		
		verifyEq(iocEnv.env, "MoFo")
	}
}

internal class T_AppModule {

	static Void bind(ServiceBinder binder) {
		binder.bindImpl(IocEnv#)
	}	

	@Contribute { serviceId="ServiceOverride" }
	static Void contributeServiceOverride(MappedConfig config) {
		config["IocEnv"] = IocEnv.fromStr("MoFo")
	}
}
