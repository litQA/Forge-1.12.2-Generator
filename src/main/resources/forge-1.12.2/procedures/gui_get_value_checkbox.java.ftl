((${input$entity} instanceof net.minecraft.entity.player.EntityPlayer)
	&& ${package}.init.${JavaModName}GUIs.State.getServerBoolean((net.minecraft.entity.player.EntityPlayer) ${input$entity},
			"${field$checkbox}", false))
