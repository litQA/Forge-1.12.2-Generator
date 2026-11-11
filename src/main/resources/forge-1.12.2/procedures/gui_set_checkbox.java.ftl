if (${input$entity} instanceof net.minecraft.entity.player.EntityPlayer)
	${package}.init.${JavaModName}GUIs.State.setServerAndSync((net.minecraft.entity.player.EntityPlayer) ${input$entity},
			"${field$checkbox}", 1, ${input$value});
