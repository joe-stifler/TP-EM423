function alfa = res_mat_1d_solver(
        beam_width,
        vertical_forces,
        horizontal_forces,
        torques,
        vertical_dist_forces,
        horizontal_supports,
        vertical_supports
    )

    
    for i = 2:length(vertical_dist_forces)
        dist_force = vertical_dist_forces(i);

        result_force = quadcc(dist_force.dist_func, dist_force.pos_beg, dist_force.pos_end);

        func_x = @(x) x .* dist_force.dist_func(x);

        centroid = quadcc(func_x, dist_force.pos_beg, dist_force.pos_end) / result_force;

        vertical_forces(length(vertical_forces) + 1) = Force(centroid, result_force);
    end


endfunction

