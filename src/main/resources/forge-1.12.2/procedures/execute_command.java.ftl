<@addTemplate file="utils/world/execute_command_context.java.ftl"/>
<#if (input$command)?contains("data remove block ")>
{
	String __mcreatorCommand = ${input$command};
	if (world instanceof WorldServer && __mcreatorCommand.startsWith("data remove block ")) {
		net.minecraft.tileentity.TileEntity __mcreatorTile = world.getTileEntity(new net.minecraft.util.math.BlockPos((int) (${input$x}), (int) (${input$y}), (int) (${input$z})));
		if (__mcreatorTile instanceof net.minecraft.inventory.IInventory) {
			net.minecraft.inventory.IInventory __mcreatorInventory = (net.minecraft.inventory.IInventory) __mcreatorTile;
			for (int __mcreatorSlot = 0; __mcreatorSlot < __mcreatorInventory.getSizeInventory(); __mcreatorSlot++) {
				if (!__mcreatorInventory.getStackInSlot(__mcreatorSlot).isEmpty()) {
					__mcreatorInventory.setInventorySlotContents(__mcreatorSlot, net.minecraft.item.ItemStack.EMPTY);
					break;
				}
			}
		}
	}
}
<#else>
{
	String __mcreatorCommand = ${input$command};
	if (world instanceof WorldServer && !__mcreatorCommand.startsWith("data get block ") && !__mcreatorCommand.startsWith("data remove block "))
		world.getMinecraftServer().getCommandManager().executeCommand(executeCommand(world, ${input$x}, ${input$y}, ${input$z}), __mcreatorCommand);
}
</#if>