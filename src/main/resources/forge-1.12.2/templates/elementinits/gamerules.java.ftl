<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import net.minecraft.world.GameRules;
import net.minecraftforge.event.world.WorldEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

@Mod.EventBusSubscriber
public class ${JavaModName}GameRules {

	@SubscribeEvent
	public static void onWorldLoad(WorldEvent.Load event) {
		GameRules rules = event.getWorld().getGameRules();

		<#list (types.gamerules![]) as gamerule>
		if (!rules.hasRule("${gamerule.getModElement().getRegistryName()}")) {
			rules.addGameRule("${gamerule.getModElement().getRegistryName()}",
					<#if gamerule.type == "Number">
					"${gamerule.defaultValueNumber}", GameRules.ValueType.NUMERICAL_VALUE);
					<#else>
					"${gamerule.defaultValueLogic?c}", GameRules.ValueType.BOOLEAN_VALUE);
					</#if>
		}
		</#list>
	}
}
<#-- @formatter:on -->
