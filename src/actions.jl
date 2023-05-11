const MoveAction = Action{:move}
Move(x::Number, y::Number) = Move(RSPos(x, y))
Move(pos::RSPos) = Action{:move}(pos)
const MoveActionN = Move( 0,  1)
const MoveActionE = Move( 1,  0)
const MoveActionS = Move( 0, -1)
const MoveActionW = Move(-1,  0)

const SampleAction = Action{:sample}
Sample() = Action{:sample}(RSPos(0, 0))

const ScanAction = Action{:scan}
Scan(x::Number, y::Number) = Scan(RSPos(x, y))
Scan(pos::RSPos) = Action{:scan}(pos)

function POMDPs.actions(p::RockSamplePOMDP{K}) where K
    move_actions = [MoveActionN, MoveActionE, MoveActionS, MoveActionW]
    sample = Sample()
    scan_actions = Scan.(p.rocks_positions)

    return vcat([sample], move_actions, scan_actions)
end

function POMDPs.actionindex(p::RockSamplePOMDP, a::Action)
    return findfirst(isequal(a), actions(p))
end

function POMDPs.actions(p::RockSamplePOMDP{K}, s::RSState) where K
    if in(s.pos, p.rocks_positions)
        return actions(p)
    else
        return filter(a -> !isa(a, SampleAction), actions(p))
    end
end

function POMDPs.actions(p::RockSamplePOMDP, b)
    s = rand(Rand.GLOBAL_RNG, b)
    return actions(p, s)
end
