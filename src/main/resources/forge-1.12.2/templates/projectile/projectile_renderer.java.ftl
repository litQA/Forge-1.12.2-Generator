<#-- @formatter:off -->
package ${package}.client.renderer;

import net.minecraft.client.model.ModelBase;
import net.minecraft.client.renderer.GlStateManager;
import net.minecraft.client.renderer.entity.Render;
import net.minecraft.client.renderer.entity.RenderManager;
import net.minecraft.util.ResourceLocation;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

import ${package}.entity.${name}Entity;

@SideOnly(Side.CLIENT)
public class ${name}Renderer extends Render<${name}Entity> {

	private static final ResourceLocation TEXTURE = getTexture("${data.customModelTexture.getRawTextureName()}");
	private final ModelBase model;

	public ${name}Renderer(RenderManager renderManager) {
		super(renderManager);
		this.shadowSize = 0.15F;
		this.model = new ${package}.client.model.${data.entityModel}();
	}

	@Override public void doRender(${name}Entity entity, double x, double y, double z, float entityYaw, float partialTicks) {
		this.bindEntityTexture(entity);
		GlStateManager.pushMatrix();
		GlStateManager.translate((float) x, (float) y, (float) z);
		GlStateManager.rotate(entityYaw, 0.0F, 1.0F, 0.0F);
		GlStateManager.rotate(90.0F - entity.prevRotationPitch
				- (entity.rotationPitch - entity.prevRotationPitch) * partialTicks, 1.0F, 0.0F, 0.0F);
		this.model.setRotationAngles(0, 0, entity.ticksExisted + partialTicks, entity.rotationYaw,
				entity.rotationPitch, 1.0F, entity);
		this.model.render(entity, 0, 0, 0, 0, 0, 1.0F);
		GlStateManager.popMatrix();
		super.doRender(entity, x, y, z, entityYaw, partialTicks);
	}

	@Override protected ResourceLocation getEntityTexture(${name}Entity entity) {
		return TEXTURE;
	}

	private static ResourceLocation getTexture(String path) {
		if (path == null || path.isEmpty())
			return new ResourceLocation("textures/entity/arrow.png");
		if (path.contains(":"))
			return new ResourceLocation(path);
		if (!path.endsWith(".png"))
			path += ".png";
		return new ResourceLocation("${modid}", "textures/entities/" + path);
	}

}
<#-- @formatter:on -->
