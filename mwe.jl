#!/usr/bin/env julia --project=@.
import Pkg
let
    pkgs = ["POMDPs", "POMDPTools", "NativeSARSOP", "SARSOP"]
    for pkg in pkgs
        if Base.find_package(pkg) === nothing
            Pkg.add(pkg)
        end
    end
end

using POMDPs
using POMDPTools
using NativeSARSOP
using SARSOP
using RockSample

rs_pomdp = RockSamplePOMDP()
rs_solver = NativeSARSOP.SARSOPSolver()
rs_solver = SARSOP.SARSOPSolver()
rs_policy = solve(rs_solver, rs_pomdp)

rs_b0 = initialize_belief(updater(rs_policy), initialstate(rs_pomdp))
rs_b1 = initialstate(rs_pomdp)
rs_b1.probs[1] = 0.5
rs_b1.probs[2:end] .= 0.5 / (length(rs_b1) - 1)
rs_b1 = initialize_belief(updater(rs_policy), rs_b1)

@show actionvalues(rs_policy, rs_b0)
@show actionvalues(rs_policy, rs_b1)
