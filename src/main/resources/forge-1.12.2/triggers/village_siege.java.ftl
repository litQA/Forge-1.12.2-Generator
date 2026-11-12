<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onVillageSiege(net.minecraftforge.event.village.VillageSiegeEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getAttemptedSpawnPos().x",
			"y": "event.getAttemptedSpawnPos().y",
			"z": "event.getAttemptedSpawnPos().z",
			"world": "event.getWorld()",
			"entity": "event.getPlayer()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


