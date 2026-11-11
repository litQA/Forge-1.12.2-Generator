<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.client.particle;

import net.minecraft.client.particle.Particle;
import net.minecraft.client.particle.IParticleFactory;
import net.minecraft.client.renderer.BufferBuilder;
import net.minecraft.entity.Entity;
import net.minecraft.world.World;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

import ${package}.init.${JavaModName}Particles;

@SideOnly(Side.CLIENT) public class ${name}Particle extends net.minecraft.client.particle.Particle {

	@SideOnly(Side.CLIENT) public static class ${name}IParticleFactory implements IParticleFactory {
		@Override public Particle createParticle(int particleID, World world, double x, double y, double z,
				double xSpeed, double ySpeed, double zSpeed, int... parameters) {
			return new ${name}Particle(world, x, y, z, xSpeed, ySpeed, zSpeed);
		}
	}

	<#if data.angularVelocity != 0 || data.angularAcceleration != 0>
	private float angularVelocity;
	private float angularAcceleration;
	</#if>
	<#if hasProcedure(data.scale)>
	private final float originalScale;
	</#if>

	protected ${name}Particle(World world, double x, double y, double z, double vx, double vy, double vz) {
		super(world, x, y, z);

		this.setSize(${data.width?c}F, ${data.height?c}F);
		<#if hasProcedure(data.scale)>
		this.originalScale = this.particleScale;
		this.particleScale *= ${data.scale.getFixedValue()?c}F;
		<#elseif data.scale.getFixedValue() != 1>
		this.particleScale *= ${data.scale.getFixedValue()?c}F;
		</#if>

		<#if data.maxAgeDiff gt 0>
		this.particleMaxAge = (int) Math.max(1, ${data.maxAge} + (this.rand.nextInt(${data.maxAgeDiff * 2}) - ${data.maxAgeDiff}));
		<#else>
		this.particleMaxAge = ${data.maxAge};
		</#if>

		this.particleGravity = ${data.gravity?c}F;
		this.canCollide = ${data.canCollide?c};

		this.motionX = vx * ${data.speedFactor?c};
		this.motionY = vy * ${data.speedFactor?c};
		this.motionZ = vz * ${data.speedFactor?c};

		<#if data.angularVelocity != 0 || data.angularAcceleration != 0>
		this.angularVelocity = ${data.angularVelocity?c}F;
		this.angularAcceleration = ${data.angularAcceleration?c}F;
		</#if>

		<#assign frameCount = data.getTextureTileCount()>
		<#if data.animate && frameCount != 1>
		this.setParticleTexture(${JavaModName}Particles.${REGISTRYNAME}_TEX[0]);
		<#elseif frameCount != 1>
		this.setParticleTexture(${JavaModName}Particles.${REGISTRYNAME}_TEX[this.rand.nextInt(${frameCount})]);
		<#else>
		this.setParticleTexture(${JavaModName}Particles.${REGISTRYNAME}_TEX);
		</#if>
	}

	@Override public int getFXLayer() {
		return 1;
	}

	<#if data.emissiveRendering>
	@Override public int getBrightnessForRender(float partialTick) {
		return 15728880;
	}
	</#if>

	<#if hasProcedure(data.scale)>
	@Override public void renderParticle(BufferBuilder buffer, Entity entity, float partialTicks, float rotationX,
			float rotationZ, float rotationYZ, float rotationXY, float rotationXZ) {
		double x = this.posX;
		double y = this.posY;
		double z = this.posZ;
		World world = this.world;
		double age = this.particleAge;
		double scale = partialTicks;
		this.particleScale = this.originalScale * (float) <@procedureOBJToNumberCode data.scale/>;
		super.renderParticle(buffer, entity, partialTicks, rotationX, rotationZ, rotationYZ, rotationXY, rotationXZ);
	}
	</#if>

	@Override public void onUpdate() {
		super.onUpdate();

		<#if data.angularVelocity != 0 || data.angularAcceleration != 0>
		this.prevParticleAngle = this.particleAngle;
		this.particleAngle += this.angularVelocity;
		this.angularVelocity += this.angularAcceleration;
		</#if>

		<#if hasProcedure(data.rotationProvider)>
		double x = this.posX;
		double y = this.posY;
		double z = this.posZ;
		World world = this.world;
		Entity entity = null;
		double age = this.particleAge;
		double scale = 1.0D;
		this.prevParticleAngle = this.particleAngle;
		this.particleAngle = (float) <@procedureOBJToNumberCode data.rotationProvider/>;
		</#if>

		<#assign frameCount = data.getTextureTileCount()>
		<#if data.animate && frameCount != 1>
		if (!this.isExpired)
			this.setParticleTexture(${JavaModName}Particles.${REGISTRYNAME}_TEX[(this.particleAge / ${data.frameDuration}) % ${frameCount}]);
		</#if>

		<#if hasProcedure(data.additionalExpiryCondition)>
		double x = this.posX;
		double y = this.posY;
		double z = this.posZ;
		World world = this.world;
		Entity entity = null;
		double age = this.particleAge;
		double scale = 1.0D;
		if (<@procedureOBJToConditionCode data.additionalExpiryCondition/>)
			this.setExpired();
		</#if>
	}

}
<#-- @formatter:on -->
