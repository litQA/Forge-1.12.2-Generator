package ${package}.entity;

import net.minecraft.entity.Entity;
import net.minecraft.entity.item.EntityPainting;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.item.ItemStack;
import net.minecraft.init.SoundEvents;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;

public class ${name}PaintingEntity extends EntityPainting {
	public ${name}PaintingEntity(World world) {
		super(world);
		this.art = ${package}.init.${JavaModName}Paintings.${registryname?upper_case};
	}

	public ${name}PaintingEntity(World world, BlockPos pos, EnumFacing facing) {
		super(world, pos, facing);
		this.art = ${package}.init.${JavaModName}Paintings.${registryname?upper_case};
		this.updateFacingWithBoundingBox(facing);
	}

	@Override
	public void onBroken(Entity brokenEntity) {
		if (!this.world.getGameRules().getBoolean("doEntityDrops"))
			return;

		this.playSound(SoundEvents.ENTITY_PAINTING_BREAK, 1.0F, 1.0F);
		if (brokenEntity instanceof EntityPlayer && ((EntityPlayer) brokenEntity).capabilities.isCreativeMode)
			return;

		this.entityDropItem(new ItemStack(${package}.init.${JavaModName}Items.${registryname?upper_case}), 0.0F);
	}
}
