<#-- @formatter:off -->
package ${package}.init;

import net.minecraft.init.Items;
import net.minecraft.init.MobEffects;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.potion.PotionEffect;
import net.minecraft.potion.PotionType;
import net.minecraft.potion.PotionUtils;
import net.minecraftforge.common.brewing.BrewingRecipeRegistry;
import net.minecraftforge.common.brewing.IBrewingRecipe;
import net.minecraftforge.fml.common.registry.ForgeRegistries;

public class ${JavaModName}Potions {

	<#list (potions![]) as potion>
	public static final PotionType ${potion.getModElement().getRegistryNameUpper()} = new PotionType(
			new PotionEffect[] {
				<#list (potion.effects![]) as effect>
				new PotionEffect(${effect.effect}, ${effect.getDuration()}, ${effect.amplifier}, ${effect.ambient?c}, ${effect.showParticles?c})<#sep>,
				</#list>
			});
	</#list>

	public static void init() {
		<#list (potions![]) as potion>
		${potion.getModElement().getRegistryNameUpper()}.setRegistryName("${modid}", "${potion.getModElement().getRegistryName()}");
		ForgeRegistries.POTION_TYPES.register(${potion.getModElement().getRegistryNameUpper()});
		BrewingRecipeRegistry.addRecipe(new CustomPotionBrewingRecipe(${potion.getModElement().getRegistryNameUpper()},
				Items.POTIONITEM, Items.GUNPOWDER, Items.SPLASH_POTION));
		BrewingRecipeRegistry.addRecipe(new CustomPotionBrewingRecipe(${potion.getModElement().getRegistryNameUpper()},
				Items.SPLASH_POTION, Items.DRAGON_BREATH, Items.LINGERING_POTION));
		</#list>
	}

	private static final class CustomPotionBrewingRecipe implements IBrewingRecipe {
		private final PotionType type;
		private final Item input;
		private final Item ingredient;
		private final Item output;

		private CustomPotionBrewingRecipe(PotionType type, Item input, Item ingredient, Item output) {
			this.type = type;
			this.input = input;
			this.ingredient = ingredient;
			this.output = output;
		}

		@Override public boolean isInput(ItemStack stack) {
			return stack.getItem() == input && PotionUtils.getPotionFromItem(stack) == type;
		}

		@Override public boolean isIngredient(ItemStack stack) {
			return stack.getItem() == ingredient;
		}

		@Override public ItemStack getOutput(ItemStack input, ItemStack ingredient) {
			return isInput(input) && isIngredient(ingredient) ? PotionUtils.addPotionToItemStack(new ItemStack(output), type) : ItemStack.EMPTY;
		}
	}

}
<#-- @formatter:on -->
