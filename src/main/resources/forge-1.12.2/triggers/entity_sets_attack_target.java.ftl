<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onEntitySetsAttackTarget(net.minecraftforge.event.entity.living.LivingSetAttackTargetEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getTarget().posX",
			"y": "event.getTarget().posY",
			"z": "event.getTarget().posZ",
			"world": "event.getEntityLiving().world",
			"entity": "event.getTarget()",
			"sourceentity": "event.getEntityLiving()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


