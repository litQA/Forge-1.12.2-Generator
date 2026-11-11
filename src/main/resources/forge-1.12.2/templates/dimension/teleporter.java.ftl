<#-- @formatter:off -->
package ${package}.world.dimension;

import net.minecraft.entity.Entity;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraftforge.common.util.ITeleporter;

public class ${name}Teleporter implements ITeleporter {

	private final BlockPos target;

	public ${name}Teleporter(BlockPos target) {
		this.target = target;
	}

	@Override public void placeEntity(World world, Entity entity, float yaw) {
		BlockPos pos = this.target;
		if (pos.getY() <= 0) {
			pos = new BlockPos(pos.getX(), 64, pos.getZ());
		}

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
}
<#-- @formatter:on -->
