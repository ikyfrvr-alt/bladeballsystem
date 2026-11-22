
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local event = ReplicatedStorage:WaitForChild("ParryEvent")
local ball = workspace:WaitForChild("Ball")

local PARRY_DISTANCE = 18
local COOLDOWN = 0.8
local BALL_SPEED = 55

local lastParry = {}

local function getNearestTarget(excludedPlayer)
    local nearestRoot = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= excludedPlayer then
            local character = player.Character
            local root = character
                and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character
                and character:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then
                local distance = (root.Position - ball.Position).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestRoot = root
                end
            end
        end
    end

    return nearestRoot
end

event.OnServerEvent:Connect(function(player)
    local now = os.clock()

    if lastParry[player] and
        now - lastParry[player] < COOLDOWN then
        return
    end

    local character = player.Character
    local root = character
        and character:FindFirstChild("HumanoidRootPart")

    if not root then return end

    if (root.Position - ball.Position).Magnitude > PARRY_DISTANCE then
        return
    end

    lastParry[player] = now

    local target = getNearestTarget(player)

    if target then
        local direction = target.Position - ball.Position

        if direction.Magnitude > 0 then
            ball.AssemblyLinearVelocity =
                direction.Unit * BALL_SPEED
        end
    else
        ball.AssemblyLinearVelocity =
            (ball.Position - root.Position).Unit * BALL_SPEED
    end

    print(player.Name .. " berhasil melakukan PARRY!")
end)

Players.PlayerRemoving:Connect(function(player)
    lastParry[player] = nil
end)
