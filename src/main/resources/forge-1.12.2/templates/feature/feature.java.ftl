<#-- @formatter:off -->
<#assign featureType = (featuretype!"")>
<#assign featureBlock = "">
<#assign blockMatches = (configurationcode!"")?matches('"Name"\\s*:\\s*"([^"]+)"')>
<#if blockMatches?has_content>
<#assign featureBlock = blockMatches?first?groups[1]>
</#if>
<#if featureType == "feature_simple_block" || featureType == "feature_random_patch_simple" || featureType == "feature_random_patch" || featureType == "feature_ore" || featureType == "feature_scattered_ore" || featureType == "feature_no_op">
<#else>
<#stop "Unsupported 1.12.2 feature type: " + featureType>
</#if>
<#if featureType != "feature_no_op" && !featureBlock?has_content>
<#stop "The 1.12.2 feature requires at least one block">
</#if>
package ${package}.worldgen;

import java.util.Random;

import net.minecraft.block.Block;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraft.world.chunk.IChunkProvider;
import net.minecraft.world.gen.IChunkGenerator;
import net.minecraft.world.gen.feature.WorldGenMinable;
import net.minecraftforge.fml.common.IWorldGenerator;

public class ${name}FeatureGenerator implements IWorldGenerator {

	@Override
	public void generate(Random random, int chunkX, int chunkZ, World world, IChunkGenerator chunkGenerator, IChunkProvider chunkProvider) {
		if (world.isRemote || ${data.skipPlacement?c})
			return;

		int x = chunkX * 16 + random.nextInt(16);
		int z = chunkZ * 16 + random.nextInt(16);
		if (!isBiomeAllowed(world, new BlockPos(x, 0, z)))
			return;

		Block block = Block.getBlockFromName("${featureBlock}");
		if (block == null)
			return;

		<#if featureType == "feature_no_op">
		return;
		<#elseif featureType == "feature_ore" || featureType == "feature_scattered_ore">
		int y = random.nextInt(Math.max(1, Math.min(64, world.getHeight() - 1)));
		new WorldGenMinable(block.getDefaultState(), 7).generate(world, random, new BlockPos(x, y, z));
		<#else>
		int y = world.getTopSolidOrLiquidBlock(new BlockPos(x, 0, z)).getY();
		<#if featureType == "feature_simple_block">
		world.setBlockState(new BlockPos(x, y, z), block.getDefaultState(), 2);
		<#else>
		for (int i = 0; i < 16; i++) {
			int px = x + random.nextInt(8) - 4;
			int pz = z + random.nextInt(8) - 4;
			int py = world.getTopSolidOrLiquidBlock(new BlockPos(px, 0, pz)).getY();
			world.setBlockState(new BlockPos(px, py, pz), block.getDefaultState(), 2);
		}
		</#if>
		</#if>
	}

	private boolean isBiomeAllowed(World world, BlockPos pos) {
		<#if (data.restrictionBiomes![])?has_content>
		String biome = String.valueOf(net.minecraft.world.biome.Biome.REGISTRY.getNameForObject(world.getBiome(pos)));
		<#list w.filterBrokenReferences(data.restrictionBiomes) as biome>
		if (biome.equals("${biome}"))
			return true;
		</#list>
		return false;
		<#else>
		return true;
		</#if>
	}
}
<#-- @formatter:on -->
