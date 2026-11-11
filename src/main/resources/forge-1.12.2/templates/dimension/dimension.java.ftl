<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.world.dimension;

import ${package}.init.${JavaModName}Dimensions;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.math.Vec3d;
import net.minecraft.world.DimensionType;
import net.minecraft.world.World;
import net.minecraft.world.WorldProvider;
import net.minecraft.world.gen.ChunkGeneratorEnd;
import net.minecraft.world.gen.ChunkGeneratorHell;
import net.minecraft.world.gen.ChunkGeneratorOverworld;
import net.minecraft.world.gen.IChunkGenerator;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

public class ${name}WorldProvider extends WorldProvider {

	@Override public void init() {
		this.biomeProvider = new ${name}BiomeProvider(this.world.getSeed());
		this.nether = <#if data.worldGenType == "Nether like gen">true<#else>false</#if>;
		this.hasSkyLight = ${data.hasSkyLight?c};
		this.doesWaterVaporize = ${data.doesWaterVaporize?c};
		<#if data.enableCustomSkyboxTextures>
		if (this.world.isRemote) {
			this.setSkyRenderer(new ${package}.client.${name}SkyRenderer());
		}
		</#if>
	}

	@Override public IChunkGenerator createChunkGenerator() {
		<#if data.worldGenType == "Void gen">
		return new ${name}ChunkGeneratorVoid(this.world);
		<#else>
		return new ${name}ChunkGenerator(this.world, this.world.getSeed());
		</#if>
	}

	@Override public DimensionType getDimensionType() {
		return ${JavaModName}Dimensions.${REGISTRYNAME};
	}

	<#if data.coordinateScale != 1>
	@Override public double getMovementFactor() {
		return ${data.coordinateScale?c}d;
	}
	</#if>

	<#if data.ambientLight != 0>
	@Override protected void generateLightBrightnessTable() {
		float f = ${data.ambientLight?c}f;
		for (int i = 0; i <= 15; ++i) {
			float f1 = 1.0F - (float) i / 15.0F;
			this.lightBrightnessTable[i] = (1.0F - f1) / (f1 * 3.0F + 1.0F) * (1.0F - f) + f;
		}
	}
	</#if>

	<#if !data.imitateOverworldBehaviour>
	@Override public void calculateInitialWeather() {}

	@Override public void updateWeather() {}

	@Override public boolean canDoLightning(net.minecraft.world.chunk.Chunk chunk) {
		return false;
	}

	@Override public boolean canDoRainSnowIce(net.minecraft.world.chunk.Chunk chunk) {
		return false;
	}
	</#if>

	<#if data.hasFixedTime>
	@Override public float calculateCelestialAngle(long worldTime, float partialTicks) {
		return ${data.fixedTimeValue?c}f;
	}
	<#elseif data.worldGenType == "Nether like gen">
	@Override public float calculateCelestialAngle(long worldTime, float partialTicks) {
		return 0.5f;
	}
	<#elseif data.worldGenType == "End like gen">
	@Override public float calculateCelestialAngle(long worldTime, float partialTicks) {
		return 0.0f;
	}
	</#if>

	@SideOnly(Side.CLIENT)
	@Override public Vec3d getFogColor(float celestialAngle, float partialTicks) {
		<#if data.useCustomEffects && data.airColor?has_content>
		return new Vec3d(${(data.airColor.getRed() / 255)?c}d, ${(data.airColor.getGreen() / 255)?c}d,
				${(data.airColor.getBlue() / 255)?c}d);
		<#elseif data.defaultEffects == "the_nether" || data.worldGenType == "Nether like gen">
		return new Vec3d(0.2d, 0.03d, 0.03d);
		<#elseif data.defaultEffects == "the_end" || data.worldGenType == "End like gen">
		return new Vec3d(0.1d, 0.08d, 0.1d);
		<#else>
		return super.getFogColor(celestialAngle, partialTicks);
		</#if>
	}

	@SideOnly(Side.CLIENT)
	@Override public boolean doesXZShowFog(int x, int z) {
		return ${(data.hasFog || data.worldGenType == "Nether like gen")?c};
	}

	@SideOnly(Side.CLIENT)
	@Override public float getCloudHeight() {
		<#if data.hasClouds>
		return ${data.cloudHeight?c}f;
		<#else>
		return Float.NaN;
		</#if>
	}

	@Override public boolean isSurfaceWorld() {
		return ${data.imitateOverworldBehaviour?c};
	}

	@Override public boolean canRespawnHere() {
		return ${data.canRespawnHere?c};
	}

	@Override public WorldSleepResult canSleepAt(EntityPlayer player, BlockPos pos) {
		return WorldSleepResult.<#if data.bedWorks>ALLOW<#else>BED_EXPLODES</#if>;
	}

	@Override public boolean canCoordinateBeSpawn(int x, int z) {
		return false;
	}

	@Override public boolean doesWaterVaporize() {
		return ${data.doesWaterVaporize?c};
	}

	<#if data.imitateOverworldBehaviour && data.hasSkyLight>
	@Override public boolean shouldClientCheckLighting() {
		return true;
	}
	</#if>

	<#if hasProcedure(data.onPlayerEntersDimension)>
	@Override public void onPlayerAdded(EntityPlayerMP entity) {
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		<@procedureOBJToCode data.onPlayerEntersDimension/>
	}
	</#if>

	<#if hasProcedure(data.onPlayerLeavesDimension)>
	@Override public void onPlayerRemoved(EntityPlayerMP entity) {
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		<@procedureOBJToCode data.onPlayerLeavesDimension/>
	}
	</#if>
}
<#-- @formatter:on -->
