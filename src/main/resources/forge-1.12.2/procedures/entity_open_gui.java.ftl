if (${input$entity} instanceof net.minecraft.entity.player.EntityPlayer) {
	int guiId = ${package}.init.${JavaModName}GUIs.idForName("${field$guiname}");
	if (guiId >= 0)
		${package}.init.${JavaModName}GUIs.open((net.minecraft.entity.player.EntityPlayer) ${input$entity}, guiId,
				world, (int) (${input$x}), (int) (${input$y}), (int) (${input$z}));
}
