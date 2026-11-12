<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onBlockBreak(net.minecraftforge.event.world.BlockEvent.BreakEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPos().getX()",
			"y": "event.getPos().getY()",
			"z": "event.getPos().getZ()",
			"px": "event.getPlayer().posX",
			"py": "event.getPlayer().posY",
			"pz": "event.getPlayer().posZ",
			"world": "event.getWorld()",
			"entity": "event.getPlayer()",
			"blockstate": "event.getState()"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}


