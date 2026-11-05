<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
<#include "/creativeTabs.ftl">
package ${package}.item;

import java.util.HashMap;
import java.util.List;
import java.util.Set;
import net.minecraft.block.Block;
import net.minecraft.block.state.IBlockState;
import net.minecraft.client.Minecraft;
import net.minecraft.client.util.ITooltipFlag;
import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.entity.Entity;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.SharedMonsterAttributes;
import net.minecraft.entity.ai.attributes.AttributeModifier;
import net.minecraft.inventory.EntityEquipmentSlot;
import net.minecraft.item.EnumRarity;
import net.minecraft.item.Item;
import net.minecraft.item.ItemAxe;
import net.minecraft.item.ItemHoe;
import net.minecraft.item.ItemPickaxe;
import net.minecraft.item.ItemShears;
import net.minecraft.item.ItemSpade;
import net.minecraft.item.ItemStack;
import net.minecraft.item.ItemSword;
import net.minecraft.util.ActionResult;
import net.minecraft.util.EnumActionResult;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.EnumHand;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraftforge.common.util.EnumHelper;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

<#assign harvestLevel = 0>
<#if data.blockDropsTier == "STONE"><#assign harvestLevel = 1><#elseif data.blockDropsTier == "IRON"><#assign harvestLevel = 2><#elseif data.blockDropsTier == "DIAMOND"><#assign harvestLevel = 3><#elseif data.blockDropsTier == "NETHERITE"><#assign harvestLevel = 4></#if>
<#if data.toolType == "Pickaxe">
public class ${name}Item extends ItemPickaxe {
<#elseif data.toolType == "Axe">
public class ${name}Item extends ItemAxe {
<#elseif data.toolType == "Spade">
public class ${name}Item extends ItemSpade {
<#elseif data.toolType == "Hoe">
public class ${name}Item extends ItemHoe {
<#elseif data.toolType == "Sword">
public class ${name}Item extends ItemSword {
<#elseif data.toolType == "Shears">
public class ${name}Item extends ItemShears {
<#else>
public class ${name}Item extends Item {
</#if>

	<#if data.toolType == "Pickaxe" || data.toolType == "Axe" || data.toolType == "Spade" || data.toolType == "Hoe" || data.toolType == "Sword">
	private static final Item.ToolMaterial MATERIAL = EnumHelper.addToolMaterial("${registryname?upper_case}", ${harvestLevel},
			${data.usageCount}, ${data.efficiency?c}f, ${(data.damageVsEntity - 4)?c}f, ${data.enchantability});
	</#if>

	public ${name}Item() {
		<#if data.toolType == "Pickaxe">
		super(MATERIAL);
		<#elseif data.toolType == "Axe">
		super(MATERIAL, ${data.damageVsEntity?c}f, ${data.attackSpeed?c}f);
		<#elseif data.toolType == "Spade">
		super(MATERIAL);
		<#elseif data.toolType == "Hoe">
		super(MATERIAL);
		<#elseif data.toolType == "Sword">
		super(MATERIAL);
		<#else>
		super();
		</#if>
		setUnlocalizedName("${modid}.${registryname}");
		<#if data.toolType == "Shears" || data.toolType == "Special" || data.toolType == "MultiTool">
		setMaxDamage(${data.usageCount});
		</#if>
		<#if data.creativeTabs?has_content>setCreativeTab(${creativeTabValue([data.creativeTabs[0]])});</#if>
		<#if data.rarity != "COMMON">/* rarity override below */</#if>
	}

	<#if data.toolType == "Shears" || data.toolType == "Special" || data.toolType == "MultiTool">
	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}
	</#if>

	@Override public EnumRarity getRarity(ItemStack stack) {
		return EnumRarity.${data.rarity};
	}

	<#if data.repairItems?has_content>
	@Override public boolean getIsRepairable(ItemStack toRepair, ItemStack repair) {
		return <#list data.repairItems as repairItem>repair.getItem() == ${mappedMCItemToItem(repairItem)}<#sep> || </#list> || super.getIsRepairable(toRepair, repair);
	}
	</#if>

	<#if data.toolType == "Special" || data.toolType == "MultiTool">
	@Override public float getDestroySpeed(ItemStack stack, IBlockState state) {
		return ${data.efficiency?c}f;
	}

	@Override public boolean canHarvestBlock(IBlockState state) {
		return true;
	}

	@Override public Set<String> getToolClasses(ItemStack stack) {
		return new java.util.HashSet<>(java.util.Arrays.asList("pickaxe", "axe", "shovel"));
	}
	</#if>

	<#if hasProcedure(data.onRightClickedInAir)>
	@Override public ActionResult<ItemStack> onItemRightClick(World world, EntityPlayer entity, EnumHand hand) {
		ActionResult<ItemStack> retval = super.onItemRightClick(world, entity, hand);
		ItemStack itemstack = retval.getResult();
		double x = entity.posX, y = entity.posY, z = entity.posZ;
		<@procedureOBJToCode data.onRightClickedInAir/>
		return retval;
	}
	</#if>

	<#if hasProcedure(data.onRightClickedOnBlock)>
	@Override public EnumActionResult onItemUse(EntityPlayer entity, World world, BlockPos pos, EnumHand hand, EnumFacing direction, float hitX, float hitY, float hitZ) {
		EnumActionResult retval = super.onItemUse(entity, world, pos, hand, direction, hitX, hitY, hitZ);
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		ItemStack itemstack = entity.getHeldItem(hand);
		<@procedureOBJToCode data.onRightClickedOnBlock/>
		return retval;
	}
	</#if>

	<#if hasProcedure(data.onBlockDestroyedWithTool)>
	@Override public boolean onBlockDestroyed(ItemStack itemstack, World world, IBlockState state, BlockPos pos, EntityLivingBase entity) {
		boolean retval = super.onBlockDestroyed(itemstack, world, state, pos, entity);
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		<@procedureOBJToCode data.onBlockDestroyedWithTool/>
		return retval;
	}
	</#if>

	<#if hasProcedure(data.onEntityHitWith)>
	@Override public boolean hitEntity(ItemStack itemstack, EntityLivingBase target, EntityLivingBase attacker) {
		boolean retval = super.hitEntity(itemstack, target, attacker);
		double x = target.posX, y = target.posY, z = target.posZ;
		<@procedureOBJToCode data.onEntityHitWith/>
		return retval;
	}
	</#if>

	<#if data.attributeModifiers?has_content>
	@Override public com.google.common.collect.Multimap<String, AttributeModifier> getItemAttributeModifiers(EntityEquipmentSlot slot) {
		com.google.common.collect.Multimap<String, AttributeModifier> multimap = super.getItemAttributeModifiers(slot);
		if (slot == EntityEquipmentSlot.MAINHAND) {
			<#list data.attributeModifiers as modifier>
			multimap.put(${modifier.attribute}.getName(), new AttributeModifier("${registryname}_${modifier?index}", ${modifier.amount?c}d,
					<#if modifier.operation == "ADD_PERCENTAGE" || modifier.operation == "MULTIPLY_TOTAL">2<#elseif modifier.operation == "MULTIPLY_BASE">1<#else>0</#if>));
			</#list>
		}
		return multimap;
	}
	</#if>

	<#if data.specialInformation?? && data.specialInformation?is_hash>
	<#assign infoName = (data.specialInformation.getName())!"null">
	<#assign infoLines = (data.specialInformation.getFixedValue())![] >
	@SideOnly(Side.CLIENT)
	@Override public void addInformation(ItemStack stack, World world, List<String> tooltip, ITooltipFlag flag) {
		super.addInformation(stack, world, tooltip, flag);
		<#if infoLines?has_content><#list infoLines as line>tooltip.add("${JavaConventions.escapeStringForJava(line)}");</#list></#if>
		<#if infoName != "null">
		if (Minecraft.getMinecraft().player != null) {
			Entity entity = Minecraft.getMinecraft().player;
			ItemStack itemstack = stack;
			double x = entity.posX, y = entity.posY, z = entity.posZ;
			String hover = <@procedureToRetvalCode name=infoName dependencies=data.specialInformation.getDependencies(generator.getWorkspace())/>;
			if (hover != null) for (String line : hover.split("\n")) tooltip.add(line);
		}
		</#if>
	}
	</#if>

}
<#-- @formatter:on -->
