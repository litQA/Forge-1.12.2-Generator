<#assign entity = input$entity>
((${entity}).isInWater() || (${entity}).world.isRainingAt((${entity}).getPosition()))
