function ret = output_file(v_forces, h_forces, t_forces, m_forces)
    % Output

    for i = 2:length(v_forces)
        printf("[Vertical force %d] [Applied at %.2e m] [Magnitude = %.4e N]\n", i - 1, v_forces(i).pos, v_forces(i).mag)
    end

    printf("\n");

    for i = 2:length(h_forces)
        printf("[Horizontal force %d] [Applied at %.2e m] [Magnitude = %.4e N]\n", i - 1, h_forces(i).pos, h_forces(i).mag)
    end

    printf("\n");

    for i = 2:length(t_forces)
        printf("[Torque force %d] [Due the position %.2e m] [Magnitude = %.4e N]\n", i - 1, t_forces(i).pos, t_forces(i).mag)
    end

    printf("\n");

    for i = 2:length(m_forces)
        printf("[Momemtum force %d] [Due the position %.2e m] [Magnitude = %.4e N]\n", i - 1, m_forces(i).pos, m_forces(i).mag)
    end

end