<#-- @formatter:off -->
<#include "/mcitems.ftl">
package ${package}.entity;

import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.projectile.EntityArrow;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraft.world.World;

public class ${name}EntityProjectile extends EntityArrow {

	public ${name}EntityProjectile(World world) {
		super(world);
		this.setSize(0.5F, 0.5F);
	}

	public ${name}EntityProjectile(double x, double y, double z, World world) {
		super(world, x, y, z);
		this.setSize(0.5F, 0.5F);
	}

	public ${name}EntityProjectile(EntityLivingBase shooter, World world) {
		super(world, shooter);
		this.setSize(0.5F, 0.5F);
	}

	@Override protected void arrowHit(EntityLivingBase livingEntity) {
		super.arrowHit(livingEntity);
		livingEntity.setArrowCountInEntity(livingEntity.getArrowCountInEntity() - 1);
	}

	@Override protected ItemStack getArrowStack() {
		return ${mappedMCItemToItemStackCode(data.rangedAttackItem, 1)};
	}

}
<#-- @formatter:on -->
