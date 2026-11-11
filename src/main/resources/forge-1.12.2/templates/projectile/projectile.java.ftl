<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
package ${package}.entity;

import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.projectile.EntityArrow;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraft.util.DamageSource;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.SoundCategory;
import net.minecraft.util.SoundEvent;
import net.minecraft.util.math.MathHelper;
import net.minecraft.util.math.RayTraceResult;
import net.minecraft.world.World;

public class ${name}Entity extends EntityArrow {

	public static final ItemStack PROJECTILE_ITEM = <#if data.projectileItem.isEmpty()>ItemStack.EMPTY<#else>${mappedMCItemToItemStackCode(data.projectileItem, 1)}</#if>;

	public ${name}Entity(World world) {
		super(world);
		this.setSize(${data.modelWidth?c}F, ${data.modelHeight?c}F);
		<#if data.disableGravity>
		this.setNoGravity(true);
		</#if>
	}

	public ${name}Entity(double x, double y, double z, World world) {
		super(world, x, y, z);
		this.setSize(${data.modelWidth?c}F, ${data.modelHeight?c}F);
		<#if data.disableGravity>
		this.setNoGravity(true);
		</#if>
	}

	public ${name}Entity(EntityLivingBase shooter, World world) {
		super(world, shooter);
		this.setSize(${data.modelWidth?c}F, ${data.modelHeight?c}F);
		<#if data.disableGravity>
		this.setNoGravity(true);
		</#if>
	}

	@Override protected ItemStack getArrowStack() {
		return PROJECTILE_ITEM;
	}

	@Override protected void arrowHit(EntityLivingBase entity) {
		super.arrowHit(entity);
		entity.setArrowCountInEntity(entity.getArrowCountInEntity() - 1);
	}

	<#if hasProcedure(data.onHitsBlock) || hasProcedure(data.onHitsPlayer) || hasProcedure(data.onHitsEntity)>
	@Override public void onHit(RayTraceResult rayTraceResult) {
		super.onHit(rayTraceResult);

		<#if hasProcedure(data.onHitsBlock)>
		if (rayTraceResult.typeOfHit == RayTraceResult.Type.BLOCK) {
			<@procedureCode data.onHitsBlock, {
				"x": "rayTraceResult.getBlockPos().getX()",
				"y": "rayTraceResult.getBlockPos().getY()",
				"z": "rayTraceResult.getBlockPos().getZ()",
				"entity": "this.shootingEntity",
				"immediatesourceentity": "this",
				"world": "this.world"
			}/>
		}
		</#if>

		<#if hasProcedure(data.onHitsPlayer)>
		if (rayTraceResult.typeOfHit == RayTraceResult.Type.ENTITY
				&& rayTraceResult.entityHit instanceof net.minecraft.entity.player.EntityPlayer) {
			<@procedureCode data.onHitsPlayer, {
				"x": "this.posX",
				"y": "this.posY",
				"z": "this.posZ",
				"entity": "rayTraceResult.entityHit",
				"sourceentity": "this.shootingEntity",
				"immediatesourceentity": "this",
				"world": "this.world"
			}/>
		}
		</#if>

		<#if hasProcedure(data.onHitsEntity)>
		if (rayTraceResult.typeOfHit == RayTraceResult.Type.ENTITY
				&& !(rayTraceResult.entityHit instanceof net.minecraft.entity.player.EntityPlayer)) {
			<@procedureCode data.onHitsEntity, {
				"x": "this.posX",
				"y": "this.posY",
				"z": "this.posZ",
				"entity": "rayTraceResult.entityHit",
				"sourceentity": "this.shootingEntity",
				"immediatesourceentity": "this",
				"world": "this.world"
			}/>
		}
		</#if>
	}
	</#if>

	@Override public void onUpdate() {
		super.onUpdate();

		<#if hasProcedure(data.onFlyingTick)>
		<@procedureCode data.onFlyingTick, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"world": "this.world",
			"entity": "this.shootingEntity",
			"immediatesourceentity": "this"
		}/>
		</#if>

		<#if !data.disableDiscarding>
		if (this.inGround)
			this.setDead();
		</#if>
	}

	public static ${name}Entity shoot(World world, EntityLivingBase shooter, java.util.Random random) {
		return shoot(world, shooter, random, ${data.power?c}F, ${data.damage?c}, ${data.knockback});
	}

	public static ${name}Entity shoot(World world, EntityLivingBase shooter, java.util.Random random, float pullingPower) {
		return shoot(world, shooter, random, pullingPower * ${data.power?c}F, ${data.damage?c}, ${data.knockback});
	}

	public static ${name}Entity shoot(World world, EntityLivingBase shooter, java.util.Random random, float power, double damage, int knockback) {
		${name}Entity projectile = new ${name}Entity(shooter, world);
		projectile.shoot(shooter.getLook(1).x, shooter.getLook(1).y, shooter.getLook(1).z, power * 2.0F, 0.0F);
		projectile.setSilent(true);
		projectile.setIsCritical(${data.showParticles?c});
		projectile.setDamage(damage);
		projectile.setKnockbackStrength(knockback);
		<#if data.igniteFire>
		projectile.setFire(100);
		</#if>
		world.spawnEntity(projectile);

		<#if data.actionSound?has_content && data.actionSound.getUnmappedValue()?has_content>
		world.playSound(null, shooter.posX, shooter.posY, shooter.posZ,
				SoundEvent.REGISTRY.getObject(new ResourceLocation("${data.actionSound.getUnmappedValue()}")),
				SoundCategory.PLAYERS, 1.0F, 1.0F / (world.rand.nextFloat() * 0.5F + 1.0F) + (power * 0.5F));
		</#if>

		return projectile;
	}

	public static ${name}Entity shoot(EntityLivingBase shooter, EntityLivingBase target) {
		${name}Entity projectile = new ${name}Entity(shooter, shooter.world);
		double dx = target.posX - shooter.posX;
		double dy = target.posY + target.getEyeHeight() - 1.1D;
		double dz = target.posZ - shooter.posZ;
		projectile.shoot(dx, dy - projectile.posY + MathHelper.sqrt(dx * dx + dz * dz) * 0.2F, dz, ${data.power?c}F * 2.0F, 12.0F);
		projectile.setSilent(true);
		projectile.setDamage(${data.damage?c});
		projectile.setKnockbackStrength(${data.knockback});
		projectile.setIsCritical(${data.showParticles?c});
		<#if data.igniteFire>
		projectile.setFire(100);
		</#if>
		shooter.world.spawnEntity(projectile);

		<#if data.actionSound?has_content && data.actionSound.getUnmappedValue()?has_content>
		shooter.world.playSound(null, shooter.posX, shooter.posY, shooter.posZ,
				SoundEvent.REGISTRY.getObject(new ResourceLocation("${data.actionSound.getUnmappedValue()}")),
				SoundCategory.PLAYERS, 1.0F, 1.0F / (shooter.world.rand.nextFloat() * 0.5F + 1.0F));
		</#if>

		return projectile;
	}

}
<#-- @formatter:on -->
