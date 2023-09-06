fx_version "cerulean"
game "common"
version "v5.5.0"

lua54 "yes"

name "Custom Context Menu"
description "Context Menu using OX_LIB"
author "NeroHiro"

shared_scripts{
    "@ox_lib/init.lua"
}

client_script "client.lua"

