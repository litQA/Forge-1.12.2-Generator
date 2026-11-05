<#-- @formatter:off -->
<#include "../utils/mcitems.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 *
 *    Forge 1.12.2 has no JSON support for the Blasting, Smoking and Campfire cooking
 *    recipe types, so these are registered as regular furnace smelting recipes.
 */
package ${package}.init;

public class ${JavaModName}Recipes {

	public static void init() {
		<#list recipes as recipe>
		<#if recipe.recipeType == "Smelting" || recipe.recipeType == "Blasting" || recipe.recipeType == "Smoking" || recipe.recipeType == "Campfire cooking">
		GameRegistry.addSmelting(${mappedMCItemToItemStackCode(recipeInput(recipe), 1)},
				${mappedMCItemToItemStackCode(recipeOutput(recipe), recipe.recipeRetstackSize)}, ${recipe.xpReward?c}f);
		</#if>
		</#list>
	}

	// Start of user code block custom recipes
	// End of user code block custom recipes

}

<#function recipeInput recipe>
	<#if recipe.recipeType == "Blasting">
		<#return recipe.blastingInputStack>
	<#elseif recipe.recipeType == "Smoking">
		<#return recipe.smokingInputStack>
	<#elseif recipe.recipeType == "Campfire cooking">
		<#return recipe.campfireCookingInputStack>
	<#else>
		<#return recipe.smeltingInputStack>
	</#if>
</#function>

<#function recipeOutput recipe>
	<#if recipe.recipeType == "Blasting">
		<#return recipe.blastingReturnStack>
	<#elseif recipe.recipeType == "Smoking">
		<#return recipe.smokingReturnStack>
	<#elseif recipe.recipeType == "Campfire cooking">
		<#return recipe.campfireCookingReturnStack>
	<#else>
		<#return recipe.smeltingReturnStack>
	</#if>
</#function>
<#-- @formatter:on -->
