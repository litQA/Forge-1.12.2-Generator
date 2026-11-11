(new Object() {
	public int getAmount(int sltid) {
		if (${input$entity} instanceof net.minecraft.entity.player.EntityPlayerMP) {
			net.minecraft.inventory.Container current = ((net.minecraft.entity.player.EntityPlayerMP) ${input$entity}).openContainer;
			if (current instanceof java.util.function.Supplier) {
				Object inventory = ((java.util.function.Supplier) current).get();
				if (inventory instanceof java.util.Map) {
					net.minecraft.inventory.Slot slot = (net.minecraft.inventory.Slot) ((java.util.Map) inventory).get(sltid);
					return slot == null ? 0 : slot.getStack().getCount();
				}
			}
		}
		return 0;
	}
}.getAmount((int) (${input$slotid})))
