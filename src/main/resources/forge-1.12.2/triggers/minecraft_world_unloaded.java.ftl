<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onWorldUnload(net.minecraftforge.event.world.WorldEvent.Unload event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"world": "event.getWorld()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


