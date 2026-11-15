if(world instanceof WorldServer)
		<#if field$particle?starts_with("CUSTOM:")>
		<#assign particle = w.getWorkspace().getModElementByName(field$particle?replace("CUSTOM:", ""))>
		((WorldServer) world).spawnParticle(${package}.init.${JavaModName}Particles.${particle.getRegistryNameUpper()}, ${input$x}, ${input$y}, ${input$z}, ${opt.toInt(input$count)}, ${input$dx}, ${input$dy}, ${input$dz}, ${input$speed}, new int[0]);
		<#else>
		((WorldServer) world).spawnParticle(net.minecraft.util.EnumParticleTypes.${generator.map(field$particle, "particles")}, ${input$x}, ${input$y}, ${input$z}, ${opt.toInt(input$count)}, ${input$dx}, ${input$dy}, ${input$dz}, ${input$speed}, new int[0]);
		</#if>
