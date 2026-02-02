local Entity = require("engine.ecs.entity")
local SpriteComponent = require("engine.components.spriteComponent")
local RenderComponent = require("engine.components.renderComponent")
local AnimatorComponent = require("engine.components.animatorComponent")

local Player = Entity:extend()

function Player:new() end
