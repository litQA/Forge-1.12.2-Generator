<#-- @formatter:off -->
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;
<#list biomes as biome>
import ${package}.world.biome.${biome.getModElement().getName()}Biome;
</#list>
import net.minecraft.util.ResourceLocation;
import net.minecraft.world.biome.Biome;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

public class ${JavaModName}Biomes {

	private static final List<Biome> REGISTRY = new ArrayList<>();

	<#list biomes as biome>
	public static final Biome ${biome.getModElement().getRegistryNameUpper()} =
			register("${biome.getModElement().getRegistryName()}", ${biome.getModElement().getName()}Biome::new);
	</#list>

	private static Biome register(String registryname, Supplier<Biome> biome) {
		Biome instance = biome.get().setRegistryName(new ResourceLocation("${modid}", registryname));
		REGISTRY.add(instance);
		return instance;
	}

	@SubscribeEvent public static void registerBiomes(RegistryEvent.Register<Biome> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Biome[0]));
	}

	public static void init() {
		<#list biomes as biome>
		<#if biome.spawnBiome>
		${biome.getModElement().getName()}Biome.init();
		</#if>
		</#list>
	}
}
<#-- @formatter:on -->
