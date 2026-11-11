<#-- @formatter:off -->
<#include "/mcitems.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import net.minecraft.client.Minecraft;
import net.minecraft.client.renderer.entity.RenderBoat;
import net.minecraft.client.renderer.entity.RenderSnowball;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraftforge.fml.client.registry.RenderingRegistry;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

@SideOnly(Side.CLIENT)
public class ${JavaModName}EntityRenderers {

	public static void register() {
		<#list (types.livingentities![]) as entity>
		RenderingRegistry.registerEntityRenderingHandler(${package}.entity.${entity.getModElement().getName()}Entity.class,
				${package}.client.renderer.${entity.getModElement().getName()}Renderer::new);
		<#if entity.hasCustomProjectile()>
		RenderingRegistry.registerEntityRenderingHandler(${package}.entity.${entity.getModElement().getName()}EntityProjectile.class,
				renderManager -> new RenderSnowball(renderManager,
						<#if entity.rangedAttackItem.isEmpty()>Items.ARROW<#else>${mappedMCItemToItem(entity.rangedAttackItem)}</#if>,
						Minecraft.getMinecraft().getRenderItem()));
		</#if>
		</#list>

		<#list (types.projectiles![]) as projectile>
		RenderingRegistry.registerEntityRenderingHandler(${package}.entity.${projectile.getModElement().getName()}Entity.class,
				${package}.client.renderer.${projectile.getModElement().getName()}Renderer::new);
		</#list>

		<#list (types.specialentities![]) as specialentity>
		RenderingRegistry.registerEntityRenderingHandler(${package}.entity.${specialentity.getModElement().getName()}Entity.class, RenderBoat::new);
		</#list>
	}

}
<#-- @formatter:on -->
