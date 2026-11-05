<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/creativeTabs.ftl">
package ${package}.item;

public class ${name}Item extends <#if data.isFood>ItemFood<#else>Item</#if> {

	public ${name}Item() {
		<#if data.isFood>
		super(${data.nutritionalValue}, ${data.saturation?c}f, ${data.isMeat?c});
		<#else>
		super();
		</#if>

		setUnlocalizedName("${modid}.${registryname}");
		setCreativeTab(${creativeTabValue(data.creativeTabs)});

		<#if data.damageCount != 0>
		setMaxStackSize(1);
		setMaxDamage(${data.damageCount});
		<#elseif data.stackSize != 64>
		setMaxStackSize(${data.stackSize});
		</#if>

		<#if data.isFood && data.isAlwaysEdible>
		setAlwaysEdible();
		</#if>

		<#if data.stayInGridWhenCrafting && data.damageOnCrafting && data.damageCount != 0>
		setMaxStackSize(1);
		</#if>
	}

	<#if data.rarity != "COMMON">
	@Override public EnumRarity getRarity(ItemStack stack) {
		return EnumRarity.${data.rarity};
	}
	</#if>

	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}

	<#if data.useDuration != 0>
	@Override public int getMaxItemUseDuration(ItemStack itemstack) {
		return ${data.useDuration};
	}
	</#if>

	<#if data.animation.getUnmappedValue()?lower_case != "none" && data.animation.getUnmappedValue()?lower_case != "">
	@Override public EnumAction getItemUseAction(ItemStack itemstack) {
		return ${generator.map(data.animation.getUnmappedValue()?lower_case, "itemuseanimations")};
	}
	</#if>

	<#if data.toolType != 1>
	@Override public float getDestroySpeed(ItemStack itemstack, IBlockState state) {
		return ${data.toolType}F;
	}
	</#if>

	<#if data.enableMeleeDamage>
	@Override public Multimap<String, AttributeModifier> getItemAttributeModifiers(EntityEquipmentSlot equipmentSlot) {
		ImmutableMultimap.Builder<String, AttributeModifier> builder = ImmutableMultimap.builder();
		builder.putAll(super.getItemAttributeModifiers(equipmentSlot));
		if (equipmentSlot == EntityEquipmentSlot.MAINHAND) {
			builder.put(SharedMonsterAttributes.ATTACK_DAMAGE.getName(),
					new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Weapon modifier", ${data.damageVsEntity - 1}d, 0));
			<#if data.attackSpeed != 4>
			builder.put(SharedMonsterAttributes.ATTACK_SPEED.getName(),
					new AttributeModifier(ATTACK_SPEED_MODIFIER, "Weapon modifier", ${data.attackSpeed - 4}d, 0));
			</#if>
		}
		return builder.build();
	}
	</#if>

	<#if data.destroyAnyBlock>
	@Override public boolean canHarvestBlock(IBlockState state) {
		return true;
	}
	</#if>

	<#if data.recipeRemainder?? && !data.recipeRemainder.isEmpty()>
	@Override public ItemStack getContainerItem(ItemStack itemstack) {
		return new ItemStack(${mappedMCItemToItem(data.recipeRemainder)});
	}
	<#elseif data.stayInGridWhenCrafting && data.damageOnCrafting && data.damageCount != 0>
	@Override public ItemStack getContainerItem(ItemStack itemstack) {
		ItemStack retval = new ItemStack(this);
		retval.setItemDamage(itemstack.getItemDamage() + 1);
		if (retval.getItemDamage() >= retval.getMaxDamage()) {
			return ItemStack.EMPTY;
		}
		return retval;
	}
	</#if>

}
<#-- @formatter:on -->
