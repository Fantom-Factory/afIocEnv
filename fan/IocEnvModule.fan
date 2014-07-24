using afIoc
using afIocConfig::FactoryDefaults

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@NoDoc
const class IocEnvModule {

	internal static Void bind(ServiceBinder binder) {
		binder.bind(IocEnv#)
	}
	
	@Contribute { serviceType=FactoryDefaults# }
	internal static Void contributeApplicationDefaults(Configuration config, IocEnv iocEnv) {
		config[IocEnvConfigIds.env]		= iocEnv.env
		config[IocEnvConfigIds.isProd]	= iocEnv.isProd
		config[IocEnvConfigIds.isTest]	= iocEnv.isTest
		config[IocEnvConfigIds.isDev]	= iocEnv.isDev
	}

	@Contribute { serviceType=RegistryStartup# }
	internal static Void contributeRegistryStartup(Configuration conf, IocEnv iocEnv) {
		conf["afIocEnv.logEnv"] = |->| {
			iocEnv.logToInfo
		}
	}
}
