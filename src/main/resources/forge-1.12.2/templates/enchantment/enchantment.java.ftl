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
import net.minecraftforge.common.util.EnumHelper;
import net.minecraftforge.event.entity.living.LivingHurtEvent;
import net.minecraftforge.event.entity.living.LivingKnockBackEvent;
import net.minecraftforge.event.entity.living.LivingExperienceDropEvent;
import net.minecraftforge.event.entity.living.LivingDropsEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

<#assign supportedItems = (data.supportedItems![])>
<#assign effects = data.effectsxml!"">
<#assign effectDamage = effects?contains("ench_component_damage") || effects?contains("ench_component_armor_effectiveness")>
<#assign effectKnockback = effects?contains("ench_component_knockback")>
<#assign effectExperience = effects?contains("ench_component_mob_experience") || effects?contains("ench_component_block_experience")>
<#assign effectDrops = effects?contains("ench_component_prevent_equipment_drop")>

<#function weightToRarity weight>
	<#if weight <= 1><#return "VERY_RARE">
	<#elseif weight <= 2><#return "RARE">
	<#elseif weight <= 5><#return "UNCOMMON">
	<#else><#return "COMMON">
	</#if>
</#function>

<#function tagToEnchantmentType tag>
	<#if tag == "TAG:minecraft:enchantable/foot_armor"><#return "ARMOR_FEET">
	<#elseif tag == "TAG:minecraft:enchantable/leg_armor"><#return "ARMOR_LEGS">
	<#elseif tag == "TAG:minecraft:enchantable/chest_armor"><#return "ARMOR_CHEST">
	<#elseif tag == "TAG:minecraft:enchantable/head_armor"><#return "ARMOR_HEAD">
	<#elseif tag == "TAG:minecraft:enchantable/armor"><#return "ARMOR">
	<#elseif tag == "TAG:minecraft:enchantable/weapon"><#return "WEAPON">
	<#elseif tag == "TAG:minecraft:enchantable/sword"><#return "WEAPON">
	<#elseif tag == "TAG:minecraft:enchantable/mining"><#return "DIGGER">
	<#elseif tag == "TAG:minecraft:enchantable/fishing"><#return "FISHING_ROD">
	<#elseif tag == "TAG:minecraft:enchantable/trident"><#return "WEAPON">
	<#elseif tag == "TAG:minecraft:enchantable/durability"><#return "BREAKABLE">
	<#elseif tag == "TAG:minecraft:enchantable/bow"><#return "BOW">
	<#elseif tag == "TAG:minecraft:enchantable/equippable"><#return "WEARABLE">
	<#elseif tag == "TAG:minecraft:enchantable/crossbow"><#return "BOW">
	<#elseif tag == "TAG:minecraft:enchantable/vanishing"><#return "ALL">
	<#else><#return "">
	</#if>
</#function>

<#function tagToOreName tag>
	<#return tag?replace("TAG:", "")?replace("mod:", modid + ":")?replace(":", "")?replace("/", "")?lower_case>
</#function>

<#function supportedItemPredicate item>
	<#if mcItemIsTag(item)>
		<#local oreName = tagToOreName(mcItemRaw(item))>
		<#return "net.minecraftforge.oredict.OreDictionary.containsMatch(false, net.minecraftforge.oredict.OreDictionary.getOres(\"" + oreName + "\"), new ItemStack(candidate))">
	<#else>
		<#return "candidate == " + mappedMCItemToItem(item)>
	</#if>
</#function>

<#assign category = "">
<#if supportedItems?size == 1>
	<#assign category = tagToEnchantmentType(mcItemRaw(supportedItems?first))>
</#if>

<#macro slotsCode slots>
	<#if slots == "any">new EntityEquipmentSlot[] { EntityEquipmentSlot.MAINHAND, EntityEquipmentSlot.OFFHAND, EntityEquipmentSlot.HEAD, EntityEquipmentSlot.CHEST, EntityEquipmentSlot.LEGS, EntityEquipmentSlot.FEET }
	<#elseif slots == "hand">new EntityEquipmentSlot[] { EntityEquipmentSlot.MAINHAND, EntityEquipmentSlot.OFFHAND }
	<#elseif slots == "armor">new EntityEquipmentSlot[] { EntityEquipmentSlot.HEAD, EntityEquipmentSlot.CHEST, EntityEquipmentSlot.LEGS, EntityEquipmentSlot.FEET }
	<#elseif slots == "body">new EntityEquipmentSlot[] { EntityEquipmentSlot.CHEST }
	<#else>new EntityEquipmentSlot[] { EntityEquipmentSlot.${(slots!"any")?upper_case} }
	</#if>
</#macro>

public class ${name}Enchantment extends Enchantment {

	<#if category?has_content>
	private static final EnumEnchantmentType ENCHANTMENT_CATEGORY = EnumEnchantmentType.${category};
	<#elseif supportedItems?has_content>
	private static final EnumEnchantmentType ENCHANTMENT_CATEGORY = EnumHelper.addEnchantmentType("${modid}_${registryname}",
			candidate -> <#list supportedItems as item>${supportedItemPredicate(item)}<#sep> || </#list>);
	<#else>
	private static final EnumEnchantmentType ENCHANTMENT_CATEGORY = EnumEnchantmentType.ALL;
	</#if>

	public ${name}Enchantment() {
		super(Enchantment.Rarity.${weightToRarity(data.weight)}, ENCHANTMENT_CATEGORY, <@slotsCode data.supportedSlots/>);
		setName("${modid}.${registryname}");
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

	<#if data.incompatibleEnchantments?has_content>
	@Override public boolean canApplyTogether(Enchantment other) {
		return <#list data.incompatibleEnchantments as incompatible>other != Enchantment.getEnchantmentByLocation("${incompatible.getUnmappedValue()}")<#sep> && </#list> && super.canApplyTogether(other);
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
