<#-- @formatter:off -->
<#include "/mcitems.ftl">
package ${package}.enchantment;

import java.util.List;
import net.minecraft.enchantment.Enchantment;
import net.minecraft.enchantment.EnumEnchantmentType;
import net.minecraft.inventory.EntityEquipmentSlot;
import net.minecraft.item.ItemStack;

public class ${name}Enchantment extends Enchantment {

	public ${name}Enchantment() {
		super(Enchantment.Rarity.COMMON, EnumEnchantmentType.ALL,
				new EntityEquipmentSlot[] { EntityEquipmentSlot.MAINHAND, EntityEquipmentSlot.OFFHAND,
						EntityEquipmentSlot.HEAD, EntityEquipmentSlot.CHEST, EntityEquipmentSlot.LEGS, EntityEquipmentSlot.FEET });
		setName("enchantment.${modid}.${registryname}");
		setRegistryName("${modid}:${registryname}");
	}

	@Override public int getMaxLevel() {
		return ${data.maxLevel};
	}

	@Override public int getMinEnchantability(int level) {
		return ${data.weight} + (level - 1) * ${data.weight};
	}

	@Override public int getMaxEnchantability(int level) {
		return getMinEnchantability(level) + 20;
	}

	@Override public int getWeight() {
		return ${data.weight};
	}

	<#if data.incompatibleEnchantments?has_content>
	@Override public boolean canApplyTogether(Enchantment other) {
		return <#list data.incompatibleEnchantments as incompatible>other != Enchantment.getEnchantmentByLocation("${incompatible.getUnmappedValue()}")<#sep> && </#list> && super.canApplyTogether(other);
	}
	</#if>

	<#if data.supportedItems?has_content>
	@Override public boolean canApply(ItemStack stack) {
		return <#list data.supportedItems as item>stack.getItem() == ${mappedMCItemToItem(item)}<#sep> || </#list> || super.canApply(stack);
	}
	</#if>

}
<#-- @formatter:on -->
