((${input$entity} instanceof net.minecraft.entity.player.EntityPlayer)
	? ${package}.init.${JavaModName}GUIs.State.getServerString((net.minecraft.entity.player.EntityPlayer) ${input$entity},
			"${field$textfield}", "")
	: "")
