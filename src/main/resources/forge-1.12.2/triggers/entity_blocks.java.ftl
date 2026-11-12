<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityBlocks(LivingDestroyBlockEvent event) {
		if (event != null && event.getEntityLiving() != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPos().getX()",
			"y": "event.getPos().getY()",
			"z": "event.getPos().getZ()",
			"world": "event.getEntityLiving().world",
			"entity": "event.getEntityLiving()",
			"blockstate": "event.getState()",
			"event": "event"
			}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
