if (${input$entity} instanceof net.minecraft.entity.player.EntityPlayer)
	${package}.init.${JavaModName}GUIs.State.setServerAndSync((net.minecraft.entity.player.EntityPlayer) ${input$entity},
			"${field$slider}", 2, ${input$value});
