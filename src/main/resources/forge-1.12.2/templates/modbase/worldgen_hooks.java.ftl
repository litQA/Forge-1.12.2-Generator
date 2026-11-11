<#-- @formatter:off -->
<#assign caveBiome = "">
<#assign netherBiome = "">
<#list (types.biomes![]) as biome>
	<#if biome.spawnInCaves && !caveBiome?has_content>
		<#assign caveBiome = biome>
	</#if>
	<#if biome.spawnBiomeNether && !netherBiome?has_content>
		<#assign netherBiome = biome>
	</#if>
</#list>
package ${package}.worldgen;

import ${package}.init.${JavaModName}Biomes;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraft.world.biome.Biome;

public final class ${JavaModName}WorldgenHooks {

	public static final Biome CAVE_BIOME =
			<#if caveBiome?has_content>${JavaModName}Biomes.${caveBiome.getModElement().getRegistryNameUpper()}<#else>null</#if>;
	public static final Biome NETHER_BIOME =
			<#if netherBiome?has_content>${JavaModName}Biomes.${netherBiome.getModElement().getRegistryNameUpper()}<#else>null</#if>;

	private ${JavaModName}WorldgenHooks() {
	}

	public static Biome getBiome(World world, BlockPos pos, Biome original) {
		int dimension = world.provider.getDimension();
		if (dimension == 0 && pos.getY() < 50 && CAVE_BIOME != null) {
			return CAVE_BIOME;
		}
		if (dimension == -1 && NETHER_BIOME != null) {
			return NETHER_BIOME;
		}
		return original;
	}
}
<#-- @formatter:on -->
