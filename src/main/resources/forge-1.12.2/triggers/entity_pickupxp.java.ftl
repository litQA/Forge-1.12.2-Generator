<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onPickupXP(net.minecraftforge.event.entity.player.PlayerPickupXpEvent event) {
		if (event != null && event.getEntityPlayer() != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntityPlayer().posX",
				"y": "event.getEntityPlayer().posY",
				"z": "event.getEntityPlayer().posZ",
				"world": "event.getEntityPlayer().world",
				"entity": "event.getEntityPlayer()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}


