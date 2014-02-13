using afIoc
using afIocConfig::FactoryDefaults

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
** 
** This class is public so it may be referenced explicitly in test code.
const class IocEnvModule {

	internal static Void bind(ServiceBinder binder) {
		binder.bind(IocEnv#)
	}
	
	@Contribute { serviceType=FactoryDefaults# }
	internal static Void contributeApplicationDefaults(MappedConfig config, IocEnv iocEnv) {
		config[IocEnvConfigIds.env]		= iocEnv.env
		config[IocEnvConfigIds.isProd]	= iocEnv.isProd
		config[IocEnvConfigIds.isTest]	= iocEnv.isTest
		config[IocEnvConfigIds.isDev]	= iocEnv.isDev
	}

	@Contribute { serviceType=RegistryStartup# }
	internal static Void contributeRegistryStartup(OrderedConfig conf, IocEnv iocEnv) {
		conf.add |->| {
			iocEnv.logToInfo
		}
	}
}
