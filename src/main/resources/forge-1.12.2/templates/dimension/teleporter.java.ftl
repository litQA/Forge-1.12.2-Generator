<#-- @formatter:off -->
package ${package}.world.dimension;

import net.minecraft.entity.Entity;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.init.Blocks;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraftforge.common.util.ITeleporter;

public class ${name}Teleporter implements ITeleporter {

	private final BlockPos target;

	public ${name}Teleporter(BlockPos target) {
		this.target = target;
	}

	@Override public void placeEntity(World world, Entity entity, float yaw) {
		BlockPos pos = findSafePosition(world, this.target);
		double x = pos.getX() + 0.5D;
		double y = pos.getY();
		double z = pos.getZ() + 0.5D;
		entity.setLocationAndAngles(x, y, z, yaw, entity.rotationPitch);
		entity.motionX = 0.0D;
		entity.motionY = 0.0D;
		entity.motionZ = 0.0D;

		if (entity instanceof EntityPlayerMP) {
			((EntityPlayerMP) entity).connection.setPlayerLocation(x, y, z, yaw, entity.rotationPitch);
		}
	}

	private static BlockPos findSafePosition(World world, BlockPos origin) {
		for (int radius = 0; radius <= 8; radius++) {
			for (int dx = -radius; dx <= radius; dx++) {
				for (int dz = -radius; dz <= radius; dz++) {
					if (Math.abs(dx) != radius && Math.abs(dz) != radius) {
						continue;
					}
					int x = origin.getX() + dx;
					int z = origin.getZ() + dz;
					int startY = world.getHeight(x, z);
					if (startY < 1) {
						startY = 64;
					}
					for (int y = startY; y < 252; y++) {
						BlockPos feet = new BlockPos(x, y, z);
						if (world.isAirBlock(feet) && world.isAirBlock(feet.up())
								&& !world.isAirBlock(feet.down())) {
							return feet;
						}
						if (y > startY + 24) {
							break;
						}
					}
				}
			}
		}

		BlockPos fallback = new BlockPos(origin.getX(), 64, origin.getZ());
		for (int dx = -1; dx <= 1; dx++) {
			for (int dz = -1; dz <= 1; dz++) {
				world.setBlockState(fallback.add(dx, -1, dz), Blocks.STONE.getDefaultState(), 2);
			}
		}
		world.setBlockToAir(fallback);
		world.setBlockToAir(fallback.up());
		return fallback;
	}
}
<#-- @formatter:on -->
