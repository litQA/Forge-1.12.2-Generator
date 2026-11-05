<#-- @formatter:off -->
<#include "/mcitems.ftl">
package ${package}.recipe;

import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.init.PotionTypes;
import net.minecraft.potion.PotionUtils;
import net.minecraftforge.common.brewing.IBrewingRecipe;

public class ${name}BrewingRecipe implements IBrewingRecipe {

	private static boolean isPotionItem(Item item) {
		return item == Items.POTIONITEM || item == Items.SPLASH_POTION || item == Items.LINGERING_POTION;
	}

	@Override public boolean isInput(ItemStack input) {
		<#if mcItemRaw(data.brewingInputStack)?starts_with("POTION:")>
		return isPotionItem(input.getItem())
				&& PotionUtils.getPotionFromItem(input) == ${generator.map(mcItemRaw(data.brewingInputStack)?replace("POTION:", ""), "potions")};
		<#else>
		return ${mappedMCItemToIngredient(data.brewingInputStack)}.test(input);
		</#if>
	}

	@Override public boolean isIngredient(ItemStack ingredient) {
		return ${mappedMCItemToIngredient(data.brewingIngredientStack)}.test(ingredient);
	}

	@Override public ItemStack getOutput(ItemStack input, ItemStack ingredient) {
		if (!isInput(input) || !isIngredient(ingredient)) {
			return ItemStack.EMPTY;
		}
		<#if mcItemRaw(data.brewingReturnStack)?starts_with("POTION:")>
		return PotionUtils.addPotionToItemStack(
				new ItemStack(<#if mcItemRaw(data.brewingInputStack)?starts_with("POTION:")>input.getItem()<#else>Items.POTIONITEM</#if>),
				${generator.map(mcItemRaw(data.brewingReturnStack)?replace("POTION:", ""), "potions")});
		<#else>
		return ${mappedMCItemToItemStackCode(data.brewingReturnStack, 1)};
		</#if>
	}

}
<#-- @formatter:on -->
