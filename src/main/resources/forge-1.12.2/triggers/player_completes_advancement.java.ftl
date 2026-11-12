<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onAdvancement(net.minecraftforge.event.entity.player.AdvancementEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntityPlayer().posX",
			"y": "event.getEntityPlayer().posY",
			"z": "event.getEntityPlayer().posZ",
			"world": "event.getEntityPlayer().world",
			"entity": "event.getEntityPlayer()",
			"advancement": "event.getAdvancement()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


