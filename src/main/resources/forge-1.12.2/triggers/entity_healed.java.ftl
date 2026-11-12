<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onEntityHealed(net.minecraftforge.event.entity.living.LivingHealEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntityLiving().posX",
			"y": "event.getEntityLiving().posY",
			"z": "event.getEntityLiving().posZ",
			"amount": "event.getAmount()",
			"world": "event.getEntityLiving().world",
			"entity": "event.getEntityLiving()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


