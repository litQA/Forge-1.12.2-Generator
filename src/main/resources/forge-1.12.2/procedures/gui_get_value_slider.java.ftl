((${input$entity} instanceof net.minecraft.entity.player.EntityPlayer)
	? ${package}.init.${JavaModName}GUIs.State.getServerDouble((net.minecraft.entity.player.EntityPlayer) ${input$entity},
			"${field$slider}", 0.0D)
	: 0.0D)
