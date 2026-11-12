package ${package}.entity;

import net.minecraft.entity.item.EntityPainting;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;

public class ${name}PaintingEntity extends EntityPainting {
	public ${name}PaintingEntity(World world) {
		super(world);
	}

	public ${name}PaintingEntity(World world, BlockPos pos, EnumFacing facing) {
		super(world, pos, facing);
		this.art = ${package}.init.${JavaModName}Paintings.${registryname?upper_case};
		this.updateFacingWithBoundingBox(facing);
	}
}
