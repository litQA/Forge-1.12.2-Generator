<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
<#include "/creativeTabs.ftl">
<#assign armorTexture = registryname>
<#if data.armorTextureFile?? && data.armorTextureFile?has_content><#assign armorTexture = data.armorTextureFile></#if>
package ${package}.item;

import java.util.List;
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
import net.minecraft.item.ItemArmor;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.NonNullList;
import net.minecraft.util.SoundEvent;
import net.minecraft.util.ResourceLocation;
import net.minecraft.world.World;
import net.minecraftforge.common.util.EnumHelper;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

public class ${name}Item {

	public static final ItemArmor.ArmorMaterial MATERIAL = EnumHelper.addArmorMaterial(
			"${registryname?upper_case}", "${modid}:${armorTexture}",
			${data.maxDamage}, new int[] { ${data.damageValueBoots}, ${data.damageValueLeggings}, ${data.damageValueBody}, ${data.damageValueHelmet} },
			${data.enchantability},
			<#if data.equipSound?? && data.equipSound.getUnmappedValue()?has_content>
			(SoundEvent) SoundEvent.REGISTRY.getObject(new ResourceLocation("${data.equipSound.getUnmappedValue()}")),
			<#else>null,
			</#if> ${data.toughness?c}f);

	<#macro armorPiece className enable slot textureName="" info="" tick="" index=0>
	<#if enable>
	public static class ${className} extends ItemArmor {
		public ${className}() {
			super(MATERIAL, 0, EntityEquipmentSlot.${slot});
			setUnlocalizedName("${modid}.${registryname}_<#if className == "Helmet">helmet<#elseif className == "Chestplate">chestplate<#elseif className == "Leggings">leggings<#else>boots</#if>");
			setMaxStackSize(1);
			<#if data.creativeTabs?has_content>setCreativeTab(${creativeTabValue([data.creativeTabs[0]])});</#if>
		}

		@Override public EnumRarity getRarity(ItemStack stack) {
			return EnumRarity.${data.rarity};
		}

		<#if data.repairItems?has_content>
		@Override public boolean getIsRepairable(ItemStack toRepair, ItemStack repair) {
			return <#list data.repairItems as repairItem>repair.getItem() == ${mappedMCItemToItem(repairItem)}<#sep> || </#list> || super.getIsRepairable(toRepair, repair);
		}
		</#if>

		<#if hasProcedure(tick)>
		@Override public void onArmorTick(World world, EntityPlayer entity, ItemStack itemstack) {
			super.onArmorTick(world, entity, itemstack);
			double x = entity.posX, y = entity.posY, z = entity.posZ;
			<@procedureOBJToCode tick/>
		}
		</#if>

		<#if data.attributeModifiers?has_content>
		@Override public com.google.common.collect.Multimap<String, AttributeModifier> getItemAttributeModifiers(EntityEquipmentSlot equipmentSlot) {
			com.google.common.collect.Multimap<String, AttributeModifier> multimap = super.getItemAttributeModifiers(equipmentSlot);
			if (equipmentSlot == EntityEquipmentSlot.${slot}) {
				<#list data.attributeModifiers as modifier>
				<#if !modifier.armorPieces?has_content || modifier.armorPieces[index]>
				multimap.put(${modifier.attribute}.getName(), new AttributeModifier(
						java.util.UUID.nameUUIDFromBytes("${modid}:${registryname}:${index}:${modifier?index}".getBytes(java.nio.charset.StandardCharsets.UTF_8)),
						"${registryname}_${index}_${modifier?index}", ${modifier.amount?c}d,
						<#if modifier.operation == "ADD_PERCENTAGE" || modifier.operation == "MULTIPLY_TOTAL">2<#elseif modifier.operation == "MULTIPLY_BASE">1<#else>0</#if>));
				</#if>
				</#list>
			}
			return multimap;
		}
		</#if>

		<#if info?? && info?is_hash>
		<#assign infoName = (info.getName())!"null">
		<#assign infoLines = (info.getFixedValue())![] >
		@SideOnly(Side.CLIENT)
		@Override public void addInformation(ItemStack stack, World world, List<String> tooltip, ITooltipFlag flag) {
			super.addInformation(stack, world, tooltip, flag);
			<#if infoLines?has_content><#list infoLines as line>tooltip.add("${JavaConventions.escapeStringForJava(line)}");</#list></#if>
			<#if infoName != "null">
			if (Minecraft.getMinecraft().player != null) {
				Entity entity = Minecraft.getMinecraft().player;
				ItemStack itemstack = stack;
				double x = entity.posX, y = entity.posY, z = entity.posZ;
				String hover = <@procedureToRetvalCode name=infoName dependencies=info.getDependencies(generator.getWorkspace())/>;
				if (hover != null) for (String line : hover.split("\n")) tooltip.add(line);
			}
			</#if>
		}
		</#if>
	}
	</#if>
	</#macro>

	<@armorPiece "Helmet" data.enableHelmet "HEAD" data.textureHelmet data.helmetSpecialInformation data.onHelmetTick 0/>
	<@armorPiece "Chestplate" data.enableBody "CHEST" data.textureBody data.bodySpecialInformation data.onBodyTick 1/>
	<@armorPiece "Leggings" data.enableLeggings "LEGS" data.textureLeggings data.leggingsSpecialInformation data.onLeggingsTick 2/>
	<@armorPiece "Boots" data.enableBoots "FEET" data.textureBoots data.bootsSpecialInformation data.onBootsTick 3/>

}
<#-- @formatter:on -->
