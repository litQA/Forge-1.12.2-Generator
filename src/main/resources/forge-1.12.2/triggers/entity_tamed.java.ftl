<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onEntityTamed(net.minecraftforge.event.entity.living.AnimalTameEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getAnimal().posX",
			"y": "event.getAnimal().posY",
			"z": "event.getAnimal().posZ",
			"world": "event.getAnimal().world",
			"entity": "event.getAnimal()",
			"sourceentity": "event.getTamer()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


