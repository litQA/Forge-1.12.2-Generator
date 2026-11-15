<#-- @formatter:off -->
<#include "/mcitems.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 *
 *    Forge 1.12.2 registers furnace, smelting and shapeless recipes through
 *    Java code. JSON recipe files are only used for shaped crafting tables.
 */
package ${package}.init;

import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraft.item.crafting.IRecipe;
import net.minecraft.item.crafting.Ingredient;
import net.minecraft.item.crafting.ShapelessRecipes;
import net.minecraft.util.NonNullList;
import net.minecraft.util.ResourceLocation;
import net.minecraftforge.fml.common.registry.ForgeRegistries;
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
		<#elseif recipe.recipeType == "Stone cutting">
		registerShapeless("${recipe.getModElement().getRegistryName()}",
				${mappedMCItemToItemStackCode(recipe.stoneCuttingReturnStack, recipe.recipeRetstackSize)},
				${mappedMCItemToItemStackCode(recipe.stoneCuttingInputStack, 1)});
		<#elseif recipe.recipeType == "Smithing">
		registerShapeless("${recipe.getModElement().getRegistryName()}",
				${mappedMCItemToItemStackCode(recipe.smithingReturnStack, recipe.recipeRetstackSize)},
				${mappedMCItemToItemStackCode(recipe.smithingInputStack, 1)},
				${mappedMCItemToItemStackCode(recipe.smithingInputAdditionStack, 1)},
				${mappedMCItemToItemStackCode(recipe.smithingInputTemplateStack, 1)});
		</#if>
		</#list>
	}

	private static void registerShapeless(String name, ItemStack output, ItemStack... inputs) {
		NonNullList<Ingredient> ingredients = NonNullList.create();
		for (ItemStack input : inputs) {
			if (input != null && !input.isEmpty()) {
				ingredients.add(Ingredient.fromStacks(input));
			}
		}
		if (ingredients.isEmpty()) {
			return;
		}
		IRecipe recipe = new ShapelessRecipes("", output, ingredients);
		recipe.setRegistryName(new ResourceLocation("${modid}", name));
		ForgeRegistries.RECIPES.register(recipe);
	}

	// Start of user code block custom recipes
	// End of user code block custom recipes

}
<#-- @formatter:on -->
