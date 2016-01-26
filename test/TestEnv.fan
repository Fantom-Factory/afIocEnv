using afIoc
using afIocConfig

@Js
internal class TestEnv : Test {
	
	Void testConfig() {
		reg := RegistryBuilder()
			.addModule(IocEnvModule#)
			.addModule(IocConfigModule#)
			.contributeToService(ConfigSource#.qname) |Configuration config| {
				config["myEnv"] = ConfigProvider([
					"acme.prop"			: "dredd",
					"dev.acme.prop"		: "anderson",
					"test.acme.prop"	: "hershey",
					"prod.acme.prop"	: "death"
				])
			}
			{ overrideService(IocEnv#.qname).withCtorArgs(["dev"]) }
			.build
		
		config := (ConfigSource) reg.activeScope.serviceById(ConfigSource#.qname)
		verifyEq(config.configMuted["acme.prop"], "anderson")

		// config, despite not being muted, should not contain env props
		// we want a working set of props, not a work-in-progress set of props!
		verifyEq   (config.config["acme.prop"], "anderson")
		verifyFalse(config.config.containsKey("dev.acme.prop"))
		verifyFalse(config.config.containsKey("test.acme.prop"))
		verifyFalse(config.config.containsKey("prod.acme.prop"))
	}
}
