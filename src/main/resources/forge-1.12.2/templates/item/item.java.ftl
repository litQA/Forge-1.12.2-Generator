<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/creativeTabs.ftl">
<#include "/procedures.ftl">
package ${package}.item;

import com.google.common.collect.ImmutableMultimap;
import com.google.common.collect.Multimap;
import java.util.List;
import net.minecraft.block.state.IBlockState;
import net.minecraft.client.Minecraft;
import net.minecraft.client.util.ITooltipFlag;
import net.minecraft.entity.Entity;
import net.minecraft.util.EnumFacing;
import net.minecraft.world.World;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;
import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.entity.SharedMonsterAttributes;
import net.minecraft.entity.ai.attributes.AttributeModifier;
import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.inventory.EntityEquipmentSlot;
import net.minecraft.item.EnumAction;
import net.minecraft.item.EnumRarity;
import net.minecraft.item.Item;
import net.minecraft.item.ItemFood;
import net.minecraft.item.ItemRecord;
import net.minecraft.item.ItemStack;
import net.minecraft.util.NonNullList;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.SoundEvent;

public class ${name}Item extends <#if data.isMusicDisc>ItemRecord<#elseif data.isFood>ItemFood<#else>Item</#if> {

	<#assign musicLocation = "minecraft:record.cat">
	<#if data.musicDiscMusic??>
		<#assign musicRaw = data.musicDiscMusic.getUnmappedValue()!"">
		<#if musicRaw?starts_with("CUSTOM:")>
			<#assign musicId = musicRaw?remove_beginning("CUSTOM:")?remove_ending(".ogg")>
			<#assign musicLocation = modid + ":" + musicId>
		<#else>
			<#assign musicId = data.musicDiscMusic.getMappedValue()!musicRaw>
			<#assign musicId = musicId?remove_ending(".ogg")>
			<#assign musicLocation = musicId?contains(":")?then(musicId, "minecraft:" + musicId)>
		</#if>
	</#if>

	<#if (data.creativeTabs?size > 1)>
	// Forge 1.12.2 only stores one default tab, but getSubItems is called by
	// every tab, so overriding it exposes the item in all selected tabs.
	private static final CreativeTabs[] CREATIVE_TABS = new CreativeTabs[] {
<#list data.creativeTabs as creativeTab>
		${creativeTabValue([creativeTab])}<#if creativeTab?has_next>,</#if>
</#list>
	};
	</#if>

	public ${name}Item() {
		<#if data.isMusicDisc>
		super("${registryname}", new SoundEvent(new ResourceLocation("${musicLocation}")));
		<#elseif data.isFood>
		super(${data.nutritionalValue}, ${data.saturation?c}f, ${data.isMeat?c});
		<#else>
		super();
		</#if>

		setUnlocalizedName("${modid}.${registryname}");
		setCreativeTab(${creativeTabValue(data.creativeTabs)});

		<#if data.isMusicDisc>
		setMaxStackSize(1);
		<#elseif data.damageCount != 0>
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

	<#if (data.creativeTabs?size > 1)>
	@Override public void getSubItems(CreativeTabs tab, NonNullList<ItemStack> items) {
		for (CreativeTabs supportedTab : CREATIVE_TABS) {
			if (supportedTab == tab) {
				items.add(new ItemStack(this));
				return;
			}
		}
	}
	</#if>

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

	<#if data.specialInformation?? && data.specialInformation?is_hash>
	<#assign infoName = (data.specialInformation.getName())!"null">
	<#assign infoLines = (data.specialInformation.getFixedValue())![] >
	@SideOnly(Side.CLIENT)
	@Override public void addInformation(ItemStack stack, World world, List<String> tooltip, ITooltipFlag flag) {
		super.addInformation(stack, world, tooltip, flag);
		<#if infoLines?has_content>
		<#list infoLines as line>
		tooltip.add("${JavaConventions.escapeStringForJava(line)}");
		</#list>
		</#if>
		<#if infoName != "null">
		if (Minecraft.getMinecraft().player != null) {
			Entity entity = Minecraft.getMinecraft().player;
			ItemStack itemstack = stack;
			double x = entity.posX;
			double y = entity.posY;
			double z = entity.posZ;
			IBlockState blockstate = null;
			EnumFacing direction = null;
			String hover = <@procedureToRetvalCode name=infoName dependencies=data.specialInformation.getDependencies(generator.getWorkspace())/>;
			if (hover != null) {
				for (String line : hover.split("\n")) {
					tooltip.add(line);
				}
			}
		}
		</#if>
	}
	</#if>

}
<#-- @formatter:on -->
