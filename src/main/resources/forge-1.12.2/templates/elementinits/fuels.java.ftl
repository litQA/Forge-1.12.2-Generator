<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
package ${package}.init;

import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraftforge.event.furnace.FurnaceFuelBurnTimeEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

public class ${JavaModName}Fuels {

	@SubscribeEvent public static void onFuel(FurnaceFuelBurnTimeEvent event) {
		ItemStack itemstack = event.getItemStack();
		<#list (itemextensions![])?filter(e -> e.enableFuel) as extension>
		if (itemstack.getItem() == ${mappedMCItemToItem(extension.item)}<#if hasProcedure(extension.fuelSuccessCondition)> && <@procedureOBJToConditionCode extension.fuelSuccessCondition/></#if>) {
			event.setBurnTime((int) <@procedureOBJToNumberCode extension.fuelPower/>);
		}
		</#list>
	}

}
<#-- @formatter:on -->
