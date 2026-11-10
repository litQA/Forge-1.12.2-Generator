<#-- @formatter:off -->
<#assign dimensionBiomes = w.filterBrokenReferences(data.biomesInDimension![])>
package ${package}.world.dimension;

import java.util.Arrays;
import java.util.List;
import java.util.Random;
import net.minecraft.init.Biomes;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.biome.Biome;
import net.minecraft.world.biome.BiomeProvider;
import net.minecraftforge.fml.common.registry.ForgeRegistries;

public class ${name}BiomeProvider extends BiomeProvider {

	private static final Biome[] CONFIGURED_BIOMES = new Biome[] {
		<#list dimensionBiomes as biome>
		ForgeRegistries.BIOMES.getValue(new ResourceLocation("${biome}"))<#sep>,</#list>
	};
	private static final Biome[] DEFAULT_BIOMES = new Biome[] {
		<#if data.worldGenType == "Nether like gen">Biomes.HELL<#elseif data.worldGenType == "End like gen">Biomes.SKY<#else>Biomes.PLAINS</#if>
	};
	private final Biome[] biomes;

	public ${name}BiomeProvider(long seed) {
		super();
		this.biomes = CONFIGURED_BIOMES.length == 0 ? DEFAULT_BIOMES : CONFIGURED_BIOMES;
	}

	private Biome biomeAt(int x, int z) {
		return this.biomes[Math.floorMod((x >> 4) * 31 + (z >> 4) * 17, this.biomes.length)];
	}

	@Override public List<Biome> getBiomesToSpawnIn() {
		return Arrays.asList(this.biomes);
	}

	@Override public Biome getBiome(BlockPos pos) {
		return this.biomeAt(pos.getX(), pos.getZ());
	}

	@Override public Biome getBiome(BlockPos pos, Biome defaultBiome) {
		return this.biomeAt(pos.getX(), pos.getZ());
	}

	@Override public Biome[] getBiomesForGeneration(Biome[] biomes, int x, int z, int width, int height) {
		if (biomes == null || biomes.length < width * height) {
			biomes = new Biome[width * height];
		}
		for (int dz = 0; dz < height; dz++) {
			for (int dx = 0; dx < width; dx++) {
				biomes[dx + dz * width] = this.biomeAt(x + dx, z + dz);
			}
		}
		return biomes;
	}

	@Override public Biome[] getBiomes(Biome[] listToReuse, int x, int z, int width, int length) {
		return this.getBiomes(listToReuse, x, z, width, length, true);
	}

	@Override public Biome[] getBiomes(Biome[] listToReuse, int x, int z, int width, int length, boolean cacheFlag) {
		if (listToReuse == null || listToReuse.length < width * length) {
			listToReuse = new Biome[width * length];
		}
		for (int dz = 0; dz < length; dz++) {
			for (int dx = 0; dx < width; dx++) {
				listToReuse[dx + dz * width] = this.biomeAt(x + dx, z + dz);
			}
		}
		return listToReuse;
	}

	@Override public boolean areBiomesViable(int x, int z, int radius, List<Biome> allowed) {
		return allowed.contains(this.biomeAt(x, z));
	}

	@Override public BlockPos findBiomePosition(int x, int z, int range, List<Biome> biomes, Random random) {
		return new BlockPos(x - range + random.nextInt(range * 2 + 1), 0,
				z - range + random.nextInt(range * 2 + 1));
	}

	@Override public void cleanupCache() {
	}

	@Override public boolean isFixedBiome() {
		return this.biomes.length == 1;
	}

	@Override public Biome getFixedBiome() {
		return this.biomes.length == 1 ? this.biomes[0] : null;
	}
}
<#-- @formatter:on -->
