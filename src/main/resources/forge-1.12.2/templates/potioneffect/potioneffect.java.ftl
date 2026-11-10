<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.potion;

import net.minecraft.client.Minecraft;
import net.minecraft.client.gui.Gui;
import net.minecraft.entity.Entity;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.SharedMonsterAttributes;
import net.minecraft.entity.ai.attributes.AbstractAttributeMap;
import net.minecraft.potion.Potion;
import net.minecraft.potion.PotionEffect;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.text.translation.I18n;
import net.minecraft.world.World;
import net.minecraftforge.fml.common.registry.ForgeRegistries;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

public class ${name}MobEffect extends Potion {

	private static final ResourceLocation POTION_ICON =
			new ResourceLocation("${modid}:textures/mob_effect/${registryname}.png");

	public ${name}MobEffect() {
		super(${(data.mobEffectCategory == "HARMFUL")?c}, ${data.color.getRGB()?c});
		setPotionName("effect.${modid}.${registryname}");
		setIconIndex(0, 0);
		<#if data.mobEffectCategory == "BENEFICIAL">
		setBeneficial();
		</#if>
		<#list (data.modifiers![]) as modifier>
		registerPotionAttributeModifier(${modifier.attribute},
				java.util.UUID.nameUUIDFromBytes("${modid}:${registryname}:${modifier?index}".getBytes(java.nio.charset.StandardCharsets.UTF_8)).toString(),
				${modifier.amount?c}d, ${getAttributeOperation(modifier.operation)});
		</#list>
	}

	<#if data.isInstant>
	@Override public boolean isInstant() {
		return true;
	}
	</#if>

	<#if hasProcedure(data.onStarted) || (data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content)>
	<#if data.isInstant>
	@Override public void affectEntity(Entity source, Entity indirectSource, EntityLivingBase entity, int amplifier, double health) {
		<@startedContext/>
	}
	<#else>
	@Override public void applyAttributesModifiersToEntity(EntityLivingBase entity, AbstractAttributeMap attributeMap, int amplifier) {
		super.applyAttributesModifiersToEntity(entity, attributeMap, amplifier);
		<@startedContext/>
	}
	</#if>
	</#if>

	<#if hasProcedure(data.onActiveTick)>
	@Override public void performEffect(EntityLivingBase entity, int amplifier) {
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		World world = entity.world;
		<@procedureOBJToCode data.onActiveTick/>
	}
	</#if>

	<#if hasProcedure(data.onExpired)>
	@Override public void removeAttributesModifiersFromEntity(EntityLivingBase entity, AbstractAttributeMap attributeMap, int amplifier) {
		super.removeAttributesModifiersFromEntity(entity, attributeMap, amplifier);
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		World world = entity.world;
		<@procedureOBJToCode data.onExpired/>
	}
	</#if>

	<#if hasProcedure(data.activeTickCondition) || hasProcedure(data.onActiveTick)>
	@Override public boolean isReady(int duration, int amplifier) {
		<#if hasProcedure(data.activeTickCondition)>
		return <@procedureOBJToConditionCode data.activeTickCondition/>;
		<#else>
		return true;
		</#if>
	}
	</#if>

	<#if !data.renderStatusInInventory>
	@Override @SideOnly(Side.CLIENT) public boolean shouldRender(PotionEffect effect) {
		return false;
	}

	@Override @SideOnly(Side.CLIENT) public boolean shouldRenderInvText(PotionEffect effect) {
		return false;
	}
	</#if>

	<#if !data.renderStatusInHUD>
	@Override @SideOnly(Side.CLIENT) public boolean shouldRenderHUD(PotionEffect effect) {
		return false;
	}
	</#if>

	@Override @SideOnly(Side.CLIENT) public void renderInventoryEffect(PotionEffect effect, Gui gui, int x, int y, float z) {
		Minecraft.getMinecraft().getTextureManager().bindTexture(POTION_ICON);
		gui.drawModalRectWithCustomSizedTexture(x + 6, y + 7, 0, 0, 18, 18, 18, 18);
	}

	@Override @SideOnly(Side.CLIENT) public void renderHUDEffect(PotionEffect effect, Gui gui, int x, int y, float z, float alpha) {
		Minecraft.getMinecraft().getTextureManager().bindTexture(POTION_ICON);
		gui.drawModalRectWithCustomSizedTexture(x + 3, y + 3, 0, 0, 18, 18, 18, 18);
	}

}
<#-- @formatter:on -->

<#function getAttributeOperation operation>
	<#if operation == "ADD_VALUE"><#return "0">
	<#elseif operation == "ADD_MULTIPLIED_BASE"><#return "1">
	<#else><#return "2">
	</#if>
</#function>

<#macro startedContext>
	<#if data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content>
	entity.world.playSound(null, entity.posX, entity.posY, entity.posZ,
			ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.onAddedSound}")),
			entity.getSoundCategory(), 1.0F, 1.0F);
	</#if>
	<#if hasProcedure(data.onStarted)>
	double x = entity.posX;
	double y = entity.posY;
	double z = entity.posZ;
	World world = entity.world;
	<@procedureOBJToCode data.onStarted/>
	</#if>
</#macro>
