<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onPlayerTick(net.minecraftforge.fml.common.gameevent.TickEvent.PlayerTickEvent event) {
		if (event.phase == net.minecraftforge.fml.common.gameevent.TickEvent.Phase.END) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.player.posX",
				"y": "event.player.posY",
				"z": "event.player.posZ",
				"world": "event.player.world",
				"entity": "event.player",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}


