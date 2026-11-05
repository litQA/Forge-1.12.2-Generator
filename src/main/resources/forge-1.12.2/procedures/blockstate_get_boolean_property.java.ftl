<#include "/mcitems.ftl">
<#if input$block??>
<#assign blockCode = mappedBlockToBlock(input$block)>
<#assign stateCode = mappedBlockToBlockStateCode(input$block)>
<#else>
<#assign blockCode = "blockstate.getBlock()">
<#assign stateCode = "blockstate">
</#if>
/*@logic*/(${blockCode}.getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyBool
    && ${stateCode}.getValue((net.minecraft.block.properties.PropertyBool) ${blockCode}.getBlockState().getProperty(${input$property})))
