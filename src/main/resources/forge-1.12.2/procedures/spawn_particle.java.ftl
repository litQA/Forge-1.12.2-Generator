<#if field$particle?starts_with("CUSTOM:")>
<#assign particle = w.getWorkspace().getModElementByName(field$particle?replace("CUSTOM:", ""))>
world.spawnParticle(${package}.init.${JavaModName}Particles.${particle.getRegistryNameUpper()}, ${input$x}, ${input$y}, ${input$z}, ${input$xs}, ${input$ys}, ${input$zs});
<#else>
world.spawnParticle(net.minecraft.util.EnumParticleTypes.${generator.map(field$particle, "particles")}, ${input$x}, ${input$y}, ${input$z}, ${input$xs}, ${input$ys}, ${input$zs});
</#if>
