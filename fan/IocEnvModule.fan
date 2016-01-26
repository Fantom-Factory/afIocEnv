using afIoc
using afIocConfig::FactoryDefaults

** The [IoC]`pod:afIoc` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@Js @NoDoc
const class IocEnvModule {

	static Void defineServices(RegistryBuilder defs) {
		defs.addService(IocEnv#).withRootScope.withCtorArgs([null])
	}

	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeApplicationDefaults(Configuration config, IocEnv iocEnv) {
		config[IocEnvConfigIds.env]		= iocEnv.env
		config[IocEnvConfigIds.isProd]	= iocEnv.isProd
		config[IocEnvConfigIds.isStage]	= iocEnv.isStage
		config[IocEnvConfigIds.isTest]	= iocEnv.isTest
		config[IocEnvConfigIds.isDev]	= iocEnv.isDev

		// set the environment in IoC Config
		config["afIocConfig.env"]		= iocEnv.abbr
		config["afIocConfig.envs"]		= "dev, test, stage, prod"
	}

	static Void onRegistryStartup(Configuration config, IocEnv iocEnv) {
		config["afIocEnv.logEnv"] = |->| {
			iocEnv.logToInfo
		}
	}
}
