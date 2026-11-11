<#-- @formatter:off -->
<#function skyboxTexture holder="" fallback="">
	<#if holder?? && holder?is_hash && !holder.isEmpty()>
		<#return holder.format("%s:textures/%s.png")>
	</#if>
	<#return fallback>
</#function>
package ${package}.client;

import net.minecraft.client.Minecraft;
import net.minecraft.client.multiplayer.WorldClient;
import net.minecraft.client.renderer.BufferBuilder;
import net.minecraft.client.renderer.GlStateManager;
import net.minecraft.client.renderer.Tessellator;
import net.minecraft.client.renderer.vertex.DefaultVertexFormats;
import net.minecraft.util.ResourceLocation;
import net.minecraftforge.client.IRenderHandler;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

@SideOnly(Side.CLIENT)
public class ${name}SkyRenderer extends IRenderHandler {

	private static final ResourceLocation UP = new ResourceLocation("${skyboxTexture(data.skyboxTextureUp, "${modid}:textures/skybox/${registryname}.png")}");
	private static final ResourceLocation DOWN = new ResourceLocation("${skyboxTexture(data.skyboxTextureDown, "${modid}:textures/skybox/${registryname}.png")}");
	private static final ResourceLocation NORTH = new ResourceLocation("${skyboxTexture(data.skyboxTextureNorth, "${modid}:textures/skybox/${registryname}.png")}");
	private static final ResourceLocation SOUTH = new ResourceLocation("${skyboxTexture(data.skyboxTextureSouth, "${modid}:textures/skybox/${registryname}.png")}");
	private static final ResourceLocation WEST = new ResourceLocation("${skyboxTexture(data.skyboxTextureWest, "${modid}:textures/skybox/${registryname}.png")}");
	private static final ResourceLocation EAST = new ResourceLocation("${skyboxTexture(data.skyboxTextureEast, "${modid}:textures/skybox/${registryname}.png")}");

	@Override public void render(float partialTicks, WorldClient world, Minecraft mc) {
		GlStateManager.disableFog();
		GlStateManager.disableDepth();
		GlStateManager.disableCull();
		GlStateManager.enableBlend();
		GlStateManager.color(1.0F, 1.0F, 1.0F, 1.0F);

		float size = 100.0F;
		Tessellator tessellator = Tessellator.getInstance();
		BufferBuilder buffer = tessellator.getBuffer();

		drawFace(buffer, mc, UP, -size, size, -size, size, size, -size, size, size, size, -size, size, size);
		drawFace(buffer, mc, DOWN, -size, -size, size, size, -size, size, size, -size, -size, -size, -size, -size);
		drawFace(buffer, mc, NORTH, -size, -size, -size, size, -size, -size, size, size, -size, -size, size, -size);
		drawFace(buffer, mc, SOUTH, size, -size, size, -size, -size, size, -size, size, size, size, size, size);
		drawFace(buffer, mc, WEST, -size, -size, size, -size, -size, -size, -size, size, -size, -size, size, size);
		drawFace(buffer, mc, EAST, size, -size, -size, size, -size, size, size, size, size, size, size, -size);

		GlStateManager.disableBlend();
		GlStateManager.enableCull();
		GlStateManager.enableDepth();
		GlStateManager.enableFog();
	}

	private static void drawFace(BufferBuilder buffer, Minecraft mc, ResourceLocation texture,
			double x1, double y1, double z1, double x2, double y2, double z2,
			double x3, double y3, double z3, double x4, double y4, double z4) {
		mc.getTextureManager().bindTexture(texture);
		buffer.begin(7, DefaultVertexFormats.POSITION_TEX);
		buffer.pos(x1, y1, z1).tex(0.0D, 0.0D).endVertex();
		buffer.pos(x2, y2, z2).tex(1.0D, 0.0D).endVertex();
		buffer.pos(x3, y3, z3).tex(1.0D, 1.0D).endVertex();
		buffer.pos(x4, y4, z4).tex(0.0D, 1.0D).endVertex();
		Tessellator.getInstance().draw();
	}
}
<#-- @formatter:on -->
