<#-- @formatter:off -->
<#include "/mcitems.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraft.nbt.NBTTagCompound;
import net.minecraft.village.MerchantRecipe;
import net.minecraftforge.fml.common.registry.VillagerRegistry;

public class ${JavaModName}Trades {

	public static void load() {
		<#list (types.villagertrades![]) as trade>
		<#if !trade.isWanderingTrader()>
		<#assign professionRaw = trade.villagerProfession.getUnmappedValue()!"">
		<#if professionRaw?starts_with("CUSTOM:")>
			<#assign professionElement = (w.getWorkspace().getModElementByName(professionRaw?replace("CUSTOM:", "")))!"">
			<#if professionElement?has_content>
				<#assign career = package + ".init." + JavaModName + "VillagerProfessions." + professionElement.getRegistryNameUpper() + "_CAREER">
			<#else>
				<#assign career = generator.map(trade.villagerProfession, "villagerprofessions")>
			</#if>
		<#else>
			<#assign career = generator.map(trade.villagerProfession, "villagerprofessions")>
		</#if>
		<#list (trade.trades![]) as entry>
		${career}.addTrade(${entry.level?c}, (merchant, recipeList, random) -> {
			NBTTagCompound nbt = new NBTTagCompound();
			nbt.setTag("buy", ${mappedMCItemToItemStackCode(entry.price1, entry.countPrice1)}.serializeNBT());
			<#if entry.price2?? && !entry.price2.isEmpty()>
			nbt.setTag("buyB", ${mappedMCItemToItemStackCode(entry.price2, entry.countPrice2)}.serializeNBT());
			</#if>
			nbt.setTag("sell", ${mappedMCItemToItemStackCode(entry.offer, entry.countOffer)}.serializeNBT());
			nbt.setInteger("maxUses", ${entry.maxTrades?c});
			<#if entry.xp <= 0>
			nbt.setBoolean("rewardExp", false);
			</#if>
			recipeList.add(new MerchantRecipe(nbt));
		});
		</#list>
		</#if>
		</#list>
	}
}
<#-- @formatter:on -->
