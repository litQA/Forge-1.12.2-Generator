<#include "/mcitems.ftl">
<#if input$block??>
<#assign blockCode = mappedBlockToBlock(input$block)>
<#assign stateCode = mappedBlockToBlockStateCode(input$block)>
<#else>
<#assign blockCode = "blockstate.getBlock()">
<#assign stateCode = "blockstate">
</#if>
/*@int*/(getIntegerProperty(${blockCode}, ${input$property}) != null
    ? ${stateCode}.getValue(getIntegerProperty(${blockCode}, ${input$property})) : -1)
