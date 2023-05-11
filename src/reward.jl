function R(p::RockSamplePOMDP, s::RSState, a::MoveAction)
    if (s.pos + a.pos)[1] <= p.map_size[1]
        return 0
    end

    return p.exit_reward
end

function R(p::RockSamplePOMDP, s::RSState, a::SampleAction)
    if !in(s.pos, p.rocks_positions)
        return 0
    end
    
    rock_idx = findfirst(isequal(s.pos), p.rocks_positions)
    return s.rocks[rock_idx] ? p.good_rock_reward : p.bad_rock_penalty
end

function R(p::RockSamplePOMDP, s::RSState, a::ScanAction)
    return p.sensor_use_penalty
end

function POMDPs.reward(p::RockSamplePOMDP, s::RSState, a::Action)
    return p.step_penalty + R(p, s, a)
end
