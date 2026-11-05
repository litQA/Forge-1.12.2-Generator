<#-- @formatter:off -->
<#include "/mcitems.ftl">
package ${package}.enchantment;

import java.util.List;
import net.minecraft.enchantment.Enchantment;
import net.minecraft.enchantment.EnumEnchantmentType;
import net.minecraft.inventory.EntityEquipmentSlot;
import net.minecraft.item.ItemStack;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.enchantment.EnchantmentHelper;
import net.minecraftforge.event.entity.living.LivingHurtEvent;
import net.minecraftforge.event.entity.living.LivingKnockBackEvent;
import net.minecraftforge.event.entity.living.LivingExperienceDropEvent;
import net.minecraftforge.event.entity.living.LivingDropsEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

<#assign effects = data.effectsxml!"">
<#assign effectDamage = effects?contains("ench_component_damage") || effects?contains("ench_component_armor_effectiveness")>
<#assign effectKnockback = effects?contains("ench_component_knockback")>
<#assign effectExperience = effects?contains("ench_component_mob_experience") || effects?contains("ench_component_block_experience")>
<#assign effectDrops = effects?contains("ench_component_prevent_equipment_drop")>
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


	<#if effectDamage || effectKnockback || effectExperience || effectDrops>
	private static int getLevel(EntityLivingBase entity) {
		int level = 0;
		for (ItemStack stack : entity.getArmorInventoryList()) {
			level = Math.max(level, EnchantmentHelper.getEnchantmentLevel(${package}.init.${JavaModName}Enchantments.${registryname?upper_case}, stack));
		}
		level = Math.max(level, EnchantmentHelper.getEnchantmentLevel(${package}.init.${JavaModName}Enchantments.${registryname?upper_case}, entity.getHeldItemMainhand()));
		level = Math.max(level, EnchantmentHelper.getEnchantmentLevel(${package}.init.${JavaModName}Enchantments.${registryname?upper_case}, entity.getHeldItemOffhand()));
		return level;
	}

	<#if effectDamage>
	@SubscribeEvent public static void onLivingHurt(LivingHurtEvent event) {
		int level = getLevel(event.getEntityLiving());
		if (level > 0) {
			event.setAmount(event.getAmount() * Math.max(0.1f, 1.0f - 0.08f * level));
		}
	}
	</#if>

	<#if effectKnockback>
	@SubscribeEvent public static void onLivingKnockback(LivingKnockBackEvent event) {
		int level = getLevel(event.getEntityLiving());
		if (level > 0) {
			event.setStrength(event.getStrength() * Math.max(0.1f, 1.0f - 0.1f * level));
		}
	}
	</#if>

	<#if effectExperience>
	@SubscribeEvent public static void onExperienceDrop(LivingExperienceDropEvent event) {
		if (event.getAttackingPlayer() != null && getLevel(event.getAttackingPlayer()) > 0) {
			event.setDroppedExperience(event.getDroppedExperience() + 1 + getLevel(event.getAttackingPlayer()));
		}
	}
	</#if>

	<#if effectDrops>
	@SubscribeEvent public static void onDrops(LivingDropsEvent event) {
		if (getLevel(event.getEntityLiving()) > 0) {
			event.getDrops().removeIf(drop -> drop.getItem().getItem() instanceof net.minecraft.item.ItemArmor);
		}
	}
	</#if>
	</#if>

}
<#-- @formatter:on -->
