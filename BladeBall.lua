
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local event = ReplicatedStorage:WaitForChild("ParryEvent")

local cooldown = false
local cooldownTime = 0.8

local function Parry()
    if cooldown then
        return
    end

    cooldown = true

    event:FireServer()

    task.wait(cooldownTime)
    cooldown = false
end

local gui = Instance.new("ScreenGui")
gui.Name = "ParrySystem"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "ParryButton"
button.Size = UDim2.new(0, 130, 0, 65)
button.Position = UDim2.new(1, -150, 1, -120)
button.BackgroundColor3 = Color3.fromRGB(220, 35, 35)
button.Text = "PARRY"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true
button.Parent = gui

button.MouseButton1Click:Connect(Parry)
