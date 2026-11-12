<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onExplode(net.minecraftforge.event.world.ExplosionEvent.Detonate event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getExplosion().getPosition().x",
			"y": "event.getExplosion().getPosition().y",
			"z": "event.getExplosion().getPosition().z",
			"world": "event.getWorld()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


