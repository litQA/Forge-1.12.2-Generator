<#-- @formatter:off -->
<#include "/mcitems.ftl">
package ${package}.world.dimension;

import java.util.List;
import java.util.Random;
import net.minecraft.entity.EnumCreatureType;
import net.minecraft.init.Blocks;
import net.minecraft.block.state.IBlockState;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraft.world.biome.Biome;
import net.minecraft.world.chunk.Chunk;
import net.minecraft.world.chunk.ChunkPrimer;
import net.minecraft.world.gen.IChunkGenerator;
import net.minecraft.world.gen.NoiseGeneratorPerlin;

public class ${name}ChunkGenerator implements IChunkGenerator {

	private static final IBlockState FILLER = ${mappedBlockToBlockStateCode(data.mainFillerBlock)};
	private static final IBlockState FLUID =
			${(data.fluidBlock?has_content)?then(mappedBlockToBlockStateCode(data.fluidBlock), "net.minecraft.init.Blocks.WATER.getDefaultState()")};
	private static final IBlockState BEDROCK = Blocks.BEDROCK.getDefaultState();
	private static final int SEA_LEVEL = ${data.seaLevel};
	private static final int MAX_TERRAIN_Y = 252;

	private final World world;
	private final Random random;
	private final NoiseGeneratorPerlin heightNoise;
	private final NoiseGeneratorPerlin detailNoise;
	private final NoiseGeneratorPerlin aquiferNoise;
	private final double heightScale;
	private final double verticalScale;
	private final boolean aquifers;

	public ${name}ChunkGenerator(World world, long seed) {
		this.world = world;
		this.random = new Random(seed);
		this.heightNoise = new NoiseGeneratorPerlin(this.random, 4);
		this.detailNoise = new NoiseGeneratorPerlin(this.random, 2);
		this.aquiferNoise = new NoiseGeneratorPerlin(this.random, 2);
		this.heightScale = Math.max(0.005D, 0.02D * ${data.horizontalNoiseSize?c});
		this.verticalScale = Math.max(4.0D, 12.0D * ${data.verticalNoiseSize?c});
		this.aquifers = ${data.generateAquifers?c};
		this.world.setSeaLevel(SEA_LEVEL);
	}

	@Override public Chunk generateChunk(int chunkX, int chunkZ) {
		this.random.setSeed((long) chunkX * 535358712L + (long) chunkZ * 347539041L);
		ChunkPrimer primer = new ChunkPrimer();
		Biome[] biomes = this.world.getBiomeProvider().getBiomesForGeneration(
				null, chunkX * 16, chunkZ * 16, 16, 16);

		for (int x = 0; x < 16; x++) {
			for (int z = 0; z < 16; z++) {
				Biome biome = biomes[x + z * 16];
				double worldX = chunkX * 16 + x;
				double worldZ = chunkZ * 16 + z;
				double noise = this.heightNoise.getValue(worldX * this.heightScale, worldZ * this.heightScale);
				noise += this.detailNoise.getValue(worldX * this.heightScale * 3.0D,
						worldZ * this.heightScale * 3.0D) * 0.25D;
				double shapedNoise = Math.tanh(noise * 0.75D);
				double maxRise = Math.min(this.verticalScale, 180.0D);
				int terrainHeight = (int) (SEA_LEVEL + 6 + shapedNoise * maxRise);
				if (terrainHeight < 4) {
					terrainHeight = 4;
				} else if (terrainHeight > MAX_TERRAIN_Y) {
					terrainHeight = MAX_TERRAIN_Y;
				}
				double aquifer = this.aquiferNoise.getValue((chunkX * 16 + x) * 0.05D,
						(chunkZ * 16 + z) * 0.05D);

				for (int y = 0; y < 256; y++) {
					if (y == 0) {
						primer.setBlockState(x, y, z, BEDROCK);
						continue;
					}

					if (y > terrainHeight) {
						if (y <= SEA_LEVEL) {
							primer.setBlockState(x, y, z, FLUID);
						}
						continue;
					}

					boolean fluid = y <= SEA_LEVEL;
					if (this.aquifers && y > SEA_LEVEL && aquifer > 0.45D) {
						fluid = true;
					}

					if (fluid) {
						primer.setBlockState(x, y, z, FLUID);
					} else if (y >= terrainHeight - 1 && biome.topBlock != null) {
						primer.setBlockState(x, y, z, biome.topBlock);
					} else if (y >= terrainHeight - 4 && biome.fillerBlock != null) {
						primer.setBlockState(x, y, z, biome.fillerBlock);
					} else {
						primer.setBlockState(x, y, z, FILLER);
					}
				}
			}
		}

		Chunk chunk = new Chunk(this.world, primer, chunkX, chunkZ);
		byte[] biomeArray = chunk.getBiomeArray();
		for (int i = 0; i < biomeArray.length; i++) {
			biomeArray[i] = (byte) Biome.getIdForBiome(biomes[i]);
		}
		chunk.generateSkylightMap();
		return chunk;
	}

	@Override public void populate(int chunkX, int chunkZ) {
		Biome biome = this.world.getBiome(new BlockPos(chunkX * 16 + 8, 0, chunkZ * 16 + 8));
		this.random.setSeed(this.world.getSeed());
		long k = this.random.nextLong() / 2L * 2L + 1L;
		long l = this.random.nextLong() / 2L * 2L + 1L;
		this.random.setSeed((long) chunkX * k + (long) chunkZ * l ^ this.world.getSeed());
		biome.decorate(this.world, this.random, new BlockPos(chunkX * 16, 0, chunkZ * 16));
	}

	@Override public boolean generateStructures(Chunk chunkIn, int x, int z) {
		return false;
	}

	@Override public List<Biome.SpawnListEntry> getPossibleCreatures(EnumCreatureType creatureType, BlockPos pos) {
		return this.world.getBiome(pos).getSpawnableList(creatureType);
	}

	@Override public BlockPos getNearestStructurePos(World worldIn, String structureName, BlockPos position, boolean findUnexplored) {
		return null;
	}

	@Override public void recreateStructures(Chunk chunkIn, int x, int z) {
	}

	@Override public boolean isInsideStructure(World worldIn, String structureName, BlockPos pos) {
		return false;
	}
}
<#-- @formatter:on -->
