{
    "variants": {
<#list 0..15 as age>
        "age=${age}": { "model": "${modid}:${registryname}" }<#sep>,
</#list>
    }
}
