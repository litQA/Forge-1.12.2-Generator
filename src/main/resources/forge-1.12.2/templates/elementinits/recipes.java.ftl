<#-- @formatter:off -->
<#include "/mcitems.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 *
 *    Forge 1.12.2 registers furnace and brewing recipes through Java code.
 *    JSON recipe files are only used for crafting tables.
 */
package ${package}.init;

import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;

public class ${JavaModName}Recipes {

	public static void init() {
		<#list types.recipes as recipe>
		<#if recipe.recipeType == "Smelting">
		net.minecraftforge.fml.common.registry.GameRegistry.addSmelting(
				${mappedMCItemToItemStackCode(recipe.smeltingInputStack, 1)},
				${mappedMCItemToItemStackCode(recipe.smeltingReturnStack, recipe.recipeRetstackSize)}, ${recipe.xpReward?c}f);
		<#elseif recipe.recipeType == "Brewing">
		net.minecraftforge.common.brewing.BrewingRecipeRegistry.addRecipe(
				new ${package}.recipe.${recipe.getModElement().getName()}BrewingRecipe());
		</#if>
		</#list>
	}

	// Start of user code block custom recipes
	// End of user code block custom recipes

}
<#-- @formatter:on -->
