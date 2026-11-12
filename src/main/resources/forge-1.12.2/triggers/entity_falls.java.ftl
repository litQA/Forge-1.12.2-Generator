<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onEntityFall(net.minecraftforge.event.entity.living.LivingFallEvent event) {
		if (event != null && event.getEntityLiving() != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntityLiving().posX",
				"y": "event.getEntityLiving().posY",
				"z": "event.getEntityLiving().posZ",
				"damagemultiplier": "event.getDamageMultiplier()",
				"distance": "event.getDistance()",
				"world": "event.getEntityLiving().world",
				"entity": "event.getEntityLiving()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}


