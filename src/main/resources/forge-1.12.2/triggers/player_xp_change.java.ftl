<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	private static final java.util.Map<java.util.UUID, Integer> LAST_XP = new java.util.HashMap<>();

	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onPlayerXpChange(net.minecraftforge.fml.common.gameevent.TickEvent.PlayerTickEvent event) {
		if (event.phase == net.minecraftforge.fml.common.gameevent.TickEvent.Phase.END && event.player != null && !event.player.world.isRemote) {
			java.util.UUID playerId = event.player.getUniqueID();
			int currentXp = event.player.experienceTotal;
			Integer previousXp = LAST_XP.put(playerId, currentXp);
			if (previousXp != null && previousXp.intValue() != currentXp) {
				<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "event.player.posX",
					"y": "event.player.posY",
					"z": "event.player.posZ",
					"world": "event.player.world",
					"entity": "event.player",
					"amount": "(double) (currentXp - previousXp)",
					"event": "event"
					}/>
				</#assign>
				execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
			}
		}
	}

	@net.minecraftforge.fml.common.eventhandler.SubscribeEvent public static void onPlayerLogout(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerLoggedOutEvent event) {
		if (event.player != null) {
			LAST_XP.remove(event.player.getUniqueID());
		}
	}
