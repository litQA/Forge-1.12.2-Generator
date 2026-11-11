if (${input$entity} instanceof net.minecraft.entity.player.EntityPlayerMP) {
	net.minecraft.inventory.Container current = ((net.minecraft.entity.player.EntityPlayerMP) ${input$entity}).openContainer;
	if (current instanceof java.util.function.Supplier) {
		Object inventory = ((java.util.function.Supplier) current).get();
		if (inventory instanceof java.util.Map) {
			net.minecraft.inventory.Slot slot = (net.minecraft.inventory.Slot) ((java.util.Map) inventory).get((int) (${input$slotid}));
			if (slot != null) {
				ItemStack stack = slot.getStack();
				if (!stack.isEmpty()) {
					stack.attemptDamageItem((int) (${input$amount}), new java.util.Random(), null);
					current.detectAndSendChanges();
				}
			}
		}
	}
}
