using afIoc
using afIocConfig::FactoryDefaults

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
** 
** This class is public so it may be referenced explicitly in test code.
const class IocEnvModule {

	internal static Void bind(ServiceBinder binder) {
		binder.bindImpl(IocEnv#)
	}
	
	@Contribute { serviceType=FactoryDefaults# }
	internal static Void contributeApplicationDefaults(MappedConfig config, IocEnv iocEnv) {
		config[IocEnvConfigIds.env]		= iocEnv.env
		config[IocEnvConfigIds.inProd]	= iocEnv.isProd
		config[IocEnvConfigIds.inTest]	= iocEnv.isTest
		config[IocEnvConfigIds.inDev]	= iocEnv.isDev
	}
	
	@Contribute { serviceType=RegistryStartup# }
	static Void contributeRegistryStartup(OrderedConfig conf, IocEnv iocEnv) {
		conf.add |->| {
			iocEnv.logDebug
		}
	}
}
