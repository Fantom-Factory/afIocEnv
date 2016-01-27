using afIoc
using afIocConfig

@Js
internal class TestIocEnv : Test {

	Void testDefaultsToProd() {
		env := IocEnvImpl.findEnv([,], [:], null, [,], null)
		verifyEq(env, "PRODUCTION")
	}

	Void testPicksUpEnvVar() {
		env := IocEnvImpl.findEnv([,], ["env":"Fire"], null, [,], null)
		verifyEq(env, "Fire")

		env = IocEnvImpl.findEnv([,], ["environment":"Ice"], null, [,], null)
		verifyEq(env, "Ice")
	}

	Void testPicksUpProgArgs() {
		env := IocEnvImpl.findEnv([,], [:], null, "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, null)
		verifyEq(env, "Fire")

		env = IocEnvImpl.findEnv([,], [:], null, "afBedSheet::MainProxied -pingProxy -pingProxyPort -environment Ice 8069 afWebsite 8070".split, null)
		verifyEq(env, "Ice")
	}

	Void testPicksUpOverride() {
		env := IocEnvImpl.findEnv([,], [:], null, [,], "Fire")
		verifyEq(env, "Fire")
	}
	
	Void testProgArgsTrumpEnvVar() {
		env := IocEnvImpl.findEnv([,], ["environment":"Ice"], null, "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, null)
		verifyEq(env, "Fire")
	}

	Void testOverrideTrumpProgArgs() {
		env := IocEnvImpl.findEnv([,], ["environment":"Ice"], null, "afBedSheet::MainProxied -pingProxy -pingProxyPort -env Fire 8069 afWebsite 8070".split, "Pigs")
		verifyEq(env, "Pigs")
	}

	Void testProgArgsEdgeCases() {
		env := IocEnvImpl.findEnv([,], ["environment":"Ice"], null, "-env".split, null)
		verifyEq(env, "Ice")
	}

	Void testIocNormal() {
		reg := RegistryBuilder().addModules([IocEnvModule#, IocConfigModule#]).build
		iocEnv := (IocEnv) reg.rootScope.serviceByType(IocEnv#)
		// no verifies - we're just testing there are no errors
	}

	Void testIocOverride() {
		reg := RegistryBuilder().addModules([IocEnvModule#, IocConfigModule#, T_AppModule#]).build

		iocEnv := (IocEnv) reg.rootScope.serviceByType(IocEnv#)
		
		verifyEq(iocEnv.env, "MoFo")
	}
}

@Js
internal const class T_AppModule {
	static Void defineServices(RegistryBuilder defs) {
		defs.overrideService(IocEnv#.qname).withCtorArgs(["MoFo"])
	}
}
