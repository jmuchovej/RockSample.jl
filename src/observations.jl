const OBSERVATION_NAME = (:good, :bad, :none)

POMDPs.observations(pomdp::RockSamplePOMDP) = 1:3
POMDPs.obsindex(pomdp::RockSamplePOMDP, o::Int) = o

function POMDPs.observation(p::RockSamplePOMDP, a::Action, s::RSState)
    probs = zeros(length(observations(p)))
    probs[end] = 1.
    return SparseCat(observations(p), probs)
end

function POMDPs.observation(p::RockSamplePOMDP, a::ScanAction, s::RSState)
    rock_pos = a.pos  # sugar
    rock_idx = findfirst(isequal(rock_pos), p.rocks_positions)

    dist = norm(rock_pos - s.pos)    
    efficiency = 0.5 * (1. + exp(-dist * log(2) / p.sensor_efficiency))
    rock_state = s.rocks[rock_idx]

    rock_probs_bad  = (1. - efficiency, efficiency, 0.)
    rock_probs_good = (efficiency, 1. - efficiency, 0.)

    return SparseCat(
        observations(p),
        rock_state ? rock_probs_good : rock_probs_bad
    )
end
