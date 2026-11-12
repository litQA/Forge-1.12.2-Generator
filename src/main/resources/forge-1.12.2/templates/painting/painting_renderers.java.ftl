<#-- @formatter:off -->
package ${package}.client;

import java.util.HashMap;
import java.util.Map;

import net.minecraft.client.renderer.entity.RenderPainting;
import net.minecraft.client.renderer.entity.RenderManager;
import net.minecraft.entity.item.EntityPainting;
import net.minecraft.util.ResourceLocation;
import net.minecraftforge.fml.client.registry.RenderingRegistry;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

@SideOnly(Side.CLIENT)
public class ${JavaModName}PaintingRenderers {

	private static final Map<EntityPainting.EnumArt, ResourceLocation> TEXTURES = new HashMap<>();

	static {
		<#list (types.paintings![]) as painting>
		TEXTURES.put(${package}.init.${JavaModName}Paintings.${painting.getModElement().getRegistryNameUpper()},
				new ResourceLocation("${modid}", "textures/painting/${painting.getModElement().getRegistryName()}.png"));
		</#list>
	}

	public static void register() {
		<#list (types.paintings![]) as painting>
		RenderingRegistry.registerEntityRenderingHandler(${package}.entity.${painting.getModElement().getName()}PaintingEntity.class, Renderer::new);
		</#list>
	}

	private static class Renderer extends RenderPainting {
		Renderer(RenderManager manager) {
			super(manager);
		}

		@Override
		protected ResourceLocation getEntityTexture(EntityPainting entity) {
			ResourceLocation texture = TEXTURES.get(entity.art);
			return texture != null ? texture : super.getEntityTexture(entity);
		}
	}
}
<#-- @formatter:on -->
