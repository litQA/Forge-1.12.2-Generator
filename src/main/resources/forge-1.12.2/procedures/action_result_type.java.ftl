<#if field$type != "CONSUME">
    EnumActionResult.${field$type}
<#else>
    EnumActionResult.FAIL
</#if>
