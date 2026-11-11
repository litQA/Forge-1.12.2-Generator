<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.client.screens;

import net.minecraft.client.Minecraft;
import net.minecraft.client.gui.inventory.GuiInventory;
import net.minecraft.client.gui.GuiScreen;
import net.minecraft.client.renderer.GlStateManager;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.MathHelper;
import net.minecraft.world.World;
import net.minecraftforge.client.event.GuiScreenEvent;
import net.minecraftforge.client.event.RenderGameOverlayEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.eventhandler.EventPriority;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

@SideOnly(Side.CLIENT) @Mod.EventBusSubscriber(Side.CLIENT)
public class ${name}Overlay {

	@SubscribeEvent(priority = EventPriority.${data.priority})
	<#if generator.map(data.overlayTarget, "screens") == "Ingame">
	public static void eventHandler(RenderGameOverlayEvent.Post event) {
		if (event.getType() != RenderGameOverlayEvent.ElementType.HELMET)
			return;
		int width = event.getResolution().getScaledWidth();
		int height = event.getResolution().getScaledHeight();
	<#else>
	public static void eventHandler(GuiScreenEvent.DrawScreenEvent.Post event) {
		if (!(event.getGui() instanceof ${generator.map(data.overlayTarget, "screens")}))
			return;
		int width = event.getGui().width;
		int height = event.getGui().height;
	</#if>

		World world = null;
		double x = 0;
		double y = 0;
		double z = 0;

		EntityPlayer entity = Minecraft.getMinecraft().player;
		if (entity != null) {
			world = entity.world;
			x = entity.posX;
			y = entity.posY;
			z = entity.posZ;
		}

		<#if data.hasTextures()>
		GlStateManager.disableDepth();
		GlStateManager.depthMask(false);
		GlStateManager.tryBlendFuncSeparate(GlStateManager.SourceFactor.SRC_ALPHA,
				GlStateManager.DestFactor.ONE_MINUS_SRC_ALPHA, GlStateManager.SourceFactor.ONE,
				GlStateManager.DestFactor.ZERO);
		GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
		GlStateManager.disableAlpha();
		</#if>

		if (<@procedureOBJToConditionCode data.displayCondition/>) {
			<#if data.baseTexture?has_content>
			Minecraft.getMinecraft().getTextureManager()
					.bindTexture(new ResourceLocation("${modid}:textures/screens/${data.baseTexture}"));
			Minecraft.getMinecraft().ingameGUI.drawModalRectWithCustomSizedTexture(0, 0, 0, 0, width, height, width, height);
			</#if>

			<#list data.getComponentsOfType("Image") as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>) {
			</#if>
			Minecraft.getMinecraft().getTextureManager()
					.bindTexture(new ResourceLocation("${modid}:textures/screens/${component.image}"));
			Minecraft.getMinecraft().ingameGUI.drawModalRectWithCustomSizedTexture(
					<@calculatePosition component/>, 0, 0,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>
			}
			</#if>
			</#list>

			<#list data.getComponentsOfType("Sprite") as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>) {
			</#if>
			Minecraft.getMinecraft().getTextureManager()
					.bindTexture(new ResourceLocation("${modid}:textures/screens/${component.sprite}"));
			Minecraft.getMinecraft().ingameGUI.drawModalRectWithCustomSizedTexture(
					<@calculatePosition component/>,
					<#if component.getTextureWidth(w.getWorkspace()) gt component.getTextureHeight(w.getWorkspace())>
					<@getSpriteByIndex component "width"/>, 0
					<#else>
					0, <@getSpriteByIndex component "height"/>
					</#if>,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getTextureWidth(w.getWorkspace())}, ${component.getTextureHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>
			}
			</#if>
			</#list>

			<#list data.getComponentsOfType("Label") as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>) {
			</#if>
			Minecraft.getMinecraft().fontRenderer.<#if component.hasShadow>drawStringWithShadow<#else>drawString</#if>(
					<#if hasProcedure(component.text)><@procedureOBJToStringCode component.text/><#else>new net.minecraft.util.text.TextComponentTranslation("gui.${modid}.${registryname}.${component.getName()}").getUnformattedText()</#if>,
					<@calculatePosition component/>, ${component.color.getRGB()?c});
			<#if hasProcedure(component.displayCondition)>
			}
			</#if>
			</#list>

			<#list data.getComponentsOfType("EntityModel") as component>
			<#if hasProcedure(component.entityModel)>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>) {
			</#if>
			if (<@procedureOBJToConditionCode component.entityModel/> instanceof EntityLivingBase) {
				GuiInventory.drawEntityOnScreen(<@calculatePosition component x_offset=10 y_offset=20/>,
						${component.scale}, ${component.rotationX / 20.0}F, 0.0F,
						(EntityLivingBase) <@procedureOBJToConditionCode component.entityModel/>);
			}
			<#if hasProcedure(component.displayCondition)>
			}
			</#if>
			</#if>
			</#list>
		}

		<#if data.hasTextures()>
		GlStateManager.depthMask(true);
		GlStateManager.enableDepth();
		GlStateManager.enableAlpha();
		GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);
		</#if>
	}

}

<#macro calculatePosition component x_offset=0 y_offset=0>
	<#assign anchor = (component.anchorPoint!"TOP_LEFT")>
	<#if anchor?string == "TOP_LEFT">
		${component.x + x_offset}, ${component.y + y_offset}
	<#elseif anchor?string == "TOP_CENTER">
		width / 2 + ${component.x - (213 - x_offset)}, ${component.y + y_offset}
	<#elseif anchor?string == "TOP_RIGHT">
		width - ${427 - (component.x + x_offset)}, ${component.y + y_offset}
	<#elseif anchor?string == "CENTER_LEFT">
		${component.x + x_offset}, height / 2 + ${component.y - (120 - y_offset)}
	<#elseif anchor?string == "CENTER">
		width / 2 + ${component.x - (213 - x_offset)}, height / 2 + ${component.y - (120 - y_offset)}
	<#elseif anchor?string == "CENTER_RIGHT">
		width - ${427 - (component.x + x_offset)}, height / 2 + ${component.y - (120 - y_offset)}
	<#elseif anchor?string == "BOTTOM_LEFT">
		${component.x + x_offset}, height - ${240 - (component.y + y_offset)}
	<#elseif anchor?string == "BOTTOM_CENTER">
		width / 2 + ${component.x - (213 - x_offset)}, height - ${240 - (component.y + y_offset)}
	<#elseif anchor?string == "BOTTOM_RIGHT">
		width - ${427 - (component.x + x_offset)}, height - ${240 - (component.y + y_offset)}
	</#if>
</#macro>

<#macro getSpriteByIndex component dim>
	<#if hasProcedure(component.spriteIndex)>
		MathHelper.clamp((int) <@procedureOBJToNumberCode component.spriteIndex/>
			* <#if dim == "width">${component.getWidth(w.getWorkspace())}<#else>${component.getHeight(w.getWorkspace())}</#if>,
			0,
			<#if dim == "width">${component.getTextureWidth(w.getWorkspace()) - component.getWidth(w.getWorkspace())}<#else>${component.getTextureHeight(w.getWorkspace()) - component.getHeight(w.getWorkspace())}</#if>)
	<#else>
		<#if dim == "width">
			${component.getWidth(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		<#else>
			${component.getHeight(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		</#if>
	</#if>
</#macro>
<#-- @formatter:on -->

