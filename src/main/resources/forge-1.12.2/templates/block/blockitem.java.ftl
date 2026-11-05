<#-- @formatter:off -->
<#include "/creativeTabs.ftl">
<#include "/procedures.ftl">
package ${package}.item;

import java.util.List;
import net.minecraft.block.Block;
import net.minecraft.block.state.IBlockState;
import net.minecraft.client.Minecraft;
import net.minecraft.client.util.ITooltipFlag;
import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.entity.Entity;
import net.minecraft.item.EnumRarity;
import net.minecraft.item.ItemBlock;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.NonNullList;
import net.minecraft.world.World;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

public class ${name}ItemBlock extends ItemBlock {

	public ${name}ItemBlock(Block block) {
		super(block);
		setMaxStackSize(${data.maxStackSize});
		<#if data.creativeTabs?has_content>
		setCreativeTab(${creativeTabValue([data.creativeTabs[0]])});
		</#if>
	}

	@Override public EnumRarity getRarity(ItemStack stack) {
		return EnumRarity.${data.rarity};
	}

	@Override public void getSubItems(CreativeTabs tab, NonNullList<ItemStack> items) {
		CreativeTabs[] tabs = new CreativeTabs[] {
<#list data.creativeTabs as creativeTab>
			${creativeTabValue([creativeTab])}<#if creativeTab?has_next>,</#if>
</#list>
		};
		for (CreativeTabs supportedTab : tabs) {
			if (supportedTab == tab) {
				items.add(new ItemStack(this));
				return;
			}
		}
	}

	<#if data.specialInformation?? && data.specialInformation?is_hash>
	@SideOnly(Side.CLIENT)
	@Override public void addInformation(ItemStack stack, World world, List<String> tooltip, ITooltipFlag flag) {
		super.addInformation(stack, world, tooltip, flag);
		<#if data.specialInformation.getFixedValue()?has_content>
		<#list data.specialInformation.getFixedValue() as line>
		tooltip.add("${JavaConventions.escapeStringForJava(line)}");
		</#list>
		</#if>
		<#if data.specialInformation.getName() != "null">
		if (Minecraft.getMinecraft().player != null) {
			Entity entity = Minecraft.getMinecraft().player;
			ItemStack itemstack = stack;
			double x = entity.posX;
			double y = entity.posY;
			double z = entity.posZ;
			IBlockState blockstate = null;
			EnumFacing direction = null;
			String hover = <@procedureToRetvalCode name=data.specialInformation.getName() dependencies=data.specialInformation.getDependencies(generator.getWorkspace())/>;
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
