<#-- @formatter:off -->
<#include "/mcitems.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 *
 *    Forge 1.12.2 registers furnace and smelting recipes through Java code.
 *    JSON recipe files are only used for shaped crafting tables.
 */
package ${package}.init;

import net.minecraft.item.ItemStack;
import net.minecraftforge.fml.common.registry.GameRegistry;

public class ${JavaModName}Recipes {

	public static void init() {
		<#list types.recipes as recipe>
		<#if recipe.recipeType == "Smelting">
		GameRegistry.addSmelting(
				${mappedMCItemToItemStackCode(recipe.smeltingInputStack, 1)},
				${mappedMCItemToItemStackCode(recipe.smeltingReturnStack, recipe.recipeRetstackSize)}, ${recipe.xpReward?c}f);
		<#elseif recipe.recipeType == "Brewing">
		net.minecraftforge.common.brewing.BrewingRecipeRegistry.addRecipe(
				new ${package}.recipe.${recipe.getModElement().getName()}BrewingRecipe());
		<#elseif recipe.recipeType == "Blasting" || recipe.recipeType == "Smoking" || recipe.recipeType == "Campfire cooking">
		GameRegistry.addSmelting(
				${mappedMCItemToItemStackCode(recipe.blastingInputStack, 1)},
				${mappedMCItemToItemStackCode(recipe.blastingReturnStack, recipe.recipeRetstackSize)}, ${recipe.xpReward?c}f);
		</#if>
		</#list>
	}

	// Start of user code block custom recipes
	// End of user code block custom recipes

}
<#-- @formatter:on -->
