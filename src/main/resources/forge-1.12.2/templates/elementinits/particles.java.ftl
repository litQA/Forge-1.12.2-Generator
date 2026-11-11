<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 *
 *    Forge 1.12.2 has no particle registry. Custom particles extend the
 *    EnumParticleTypes enum and are added to its private lookup maps.
 */
package ${package}.init;

import java.lang.reflect.Field;
import java.util.Map;
import net.minecraft.client.Minecraft;
import net.minecraft.client.renderer.texture.TextureAtlasSprite;
import net.minecraft.client.renderer.texture.TextureMap;
import net.minecraft.util.EnumParticleTypes;
import net.minecraft.util.ResourceLocation;
import net.minecraftforge.client.event.TextureStitchEvent;
import net.minecraftforge.common.util.EnumHelper;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

import ${package}.${JavaModName};

@Mod.EventBusSubscriber(Side.CLIENT) public class ${JavaModName}Particles {

	private static final Class<?>[] PARTICLE_PARAMS = { String.class, int.class, boolean.class };

	<#list (types.particles![]) as particle>
	<#assign frameCount = particle.getTextureTileCount()>
	public static EnumParticleTypes ${particle.getModElement().getRegistryNameUpper()};
	public static <#if frameCount != 1>final </#if>TextureAtlasSprite<#if frameCount != 1>[]</#if> ${particle.getModElement().getRegistryNameUpper()}_TEX<#if frameCount != 1> = new TextureAtlasSprite[${frameCount}]</#if>;
	</#list>

	public static void load() {
		<#list (types.particles![]) as particle>
		${particle.getModElement().getRegistryNameUpper()} = makeParticle("${particle.getModElement().getRegistryNameUpper()}",
				"${particle.getModElement().getRegistryName()}", EnumParticleTypes.values().length, ${particle.alwaysShow?c});
		</#list>
	}

	private static EnumParticleTypes makeParticle(String enumName, String particleName, int index, boolean shouldIgnoreRange) {
		EnumParticleTypes particle = EnumHelper.addEnum(EnumParticleTypes.class, enumName, PARTICLE_PARAMS,
				${JavaModName}.MODID + ":" + particleName, index, shouldIgnoreRange);
		if (particle != null)
			addToParticleMaps(particle);
		return particle;
	}

	public static void registerFactories() {
		if (Minecraft.getMinecraft().effectRenderer == null)
			return;

		<#list (types.particles![]) as particle>
		Minecraft.getMinecraft().effectRenderer.registerParticle(
				${particle.getModElement().getRegistryNameUpper()}.getParticleID(),
				new ${package}.client.particle.${particle.getModElement().getName()}Particle.${particle.getModElement().getName()}IParticleFactory());
		</#list>
	}

	@SuppressWarnings("unchecked")
	private static void addToParticleMaps(EnumParticleTypes particle) {
		for (Field field : EnumParticleTypes.class.getDeclaredFields()) {
			if (!Map.class.isAssignableFrom(field.getType()))
				continue;
			try {
				field.setAccessible(true);
				Map<Object, Object> map = (Map<Object, Object>) field.get(null);
				if (map == null)
					continue;
				if (map.containsKey(EnumParticleTypes.EXPLOSION_NORMAL.getParticleID()))
					map.put(particle.getParticleID(), particle);
				else if (map.containsKey(EnumParticleTypes.EXPLOSION_NORMAL.getParticleName()))
					map.put(particle.getParticleName(), particle);
			} catch (Exception exception) {
				exception.printStackTrace();
			}
		}
	}

	@SubscribeEvent @SideOnly(Side.CLIENT) public static void onTextureStitch(TextureStitchEvent.Pre event) {
		TextureMap map = event.getMap();
		<#list (types.particles![]) as particle>
		<#assign frameCount = particle.getTextureTileCount()>
		<#if frameCount == 1>
		${particle.getModElement().getRegistryNameUpper()}_TEX = map.registerSprite(new ResourceLocation(${JavaModName}.MODID, "particle/${particle.getModElement().getRegistryName()}"));
		<#else>
		for (int i = 0; i < ${frameCount}; i++)
			${particle.getModElement().getRegistryNameUpper()}_TEX[i] = map.registerSprite(new ResourceLocation(${JavaModName}.MODID, "particle/${particle.getModElement().getRegistryName()}_" + (i + 1)));
		</#if>
		</#list>

		registerFactories();
	}

}
<#-- @formatter:on -->
