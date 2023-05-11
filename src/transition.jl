function T(p::RockSamplePOMDP, pos::RSPos, rocks)
    if pos[1] > p.map_size[1]
        return p.terminal_state
    end

    x = clamp(pos[1], 1, p.map_size[1])
    y = clamp(pos[2], 1, p.map_size[2])
    pos = RSPos(x, y)

    return RSState(pos, rocks)
end

function POMDPs.transition(p::RockSamplePOMDP, s::RSState, a::SampleAction)
    if isterminal(p, s)
        return Deterministic(p.terminal_state)
    end

    rocks = s.rocks
    if in(s.pos, p.rocks_positions)
        rock_idx = findfirst(isequal(s.pos), p.rocks_positions)
        rocks = MVector{length(rocks), Bool}(undef)
        for r=1:length(rocks)
            rocks[r] = r == rock_idx ? false : s.rocks[r]
        end
        rocks = SVector(rocks)
    end

    sp = T(p, s.pos, rocks)
    return Deterministic(sp)
end

function POMDPs.transition(p::RockSamplePOMDP, s::RSState, a::MoveAction)
    if isterminal(p, s)
        return Deterministic(p.terminal_state)
    end

    pos = s.pos + a.pos
    sp = T(p, pos, s.rocks)
    return Deterministic(sp)
end

function POMDPs.transition(p::RockSamplePOMDP, s::RSState, a::ScanAction)
    if isterminal(p, s)
        return Deterministic(p.terminal_state)
    end

    sp = T(p, s.pos, s.rocks)
    return Deterministic(sp)
end
