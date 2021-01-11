classdef    lib_resmat 
    methods ( Static = true )
        function val = delta(x)
            if x >= 0
                val = 1;
            else
                val = 0;
            end
        end
        
        function resultant_force = calcresforce(dist_force, p_beg, p_end)
            poly_int_res = polyint(dist_force.poly_func);

            result_force_int = polyval(poly_int_res, p_end) - polyval(poly_int_res, p_beg);
    
            aux_poly = dist_force.poly_func;
            aux_poly(length(aux_poly) + 1) = 0;
            poly_int_res = polyint(aux_poly);

            % calculates the centroid of the force (integrates from `beg` to `end`)
            centroid = (polyval(poly_int_res, p_end) - polyval(poly_int_res, p_beg)) / result_force_int;

            resultant_force = Force(centroid, result_force_int);

            if isnan(resultant_force.mag)
                resultant_force.mag = 0;
            end
        end

        function [v_forces, h_forces, t_forces, m_forces, v_dist_forces, X, support_momentuns] = res_mat_1d_solver(
                beam_width,
                vertical_forces,
                horizontal_forces,
                torques,
                vertical_dist_forces,
                supports,
                momentums
            )

            t_forces = torques;
            v_forces = Force(0, 0);
            m_forces(1) = Force(0, 0);
            h_forces = horizontal_forces;
            v_dist_forces(1) = Force(0, 0);
            support_momentuns(1) = Force(0, 0);

            % calculates the resultant vertical and horizontal forces, as well the resultant torques
            sum_torque_forces = 0;
            sum_vertical_forces = 0;
            sum_momentums_forces = 0;
            sum_horizontal_forces = 0;
        
            % resultant torques
            for i = 2:length(torques)
                sum_torque_forces = sum_torque_forces + torques(i).mag;
            end

            % resultant horizontal forces
            for i = 2:length(horizontal_forces)
                sum_horizontal_forces = sum_horizontal_forces + horizontal_forces(i).mag;
            end

            % Converts the distributed forces to punctual forces
            for i = 2:length(vertical_dist_forces)
                dist_force = vertical_dist_forces(i);

                if dist_force.pos_beg <= beam_width
                    % calculates the resultant force (integrates from `beg` to `end`)
                    resultant_force = lib_resmat.calcresforce(dist_force, dist_force.pos_beg, min(dist_force.pos_end, beam_width));
                    
                    sum_vertical_forces = sum_vertical_forces + resultant_force.mag;

                    res_force = (0 - resultant_force.pos) * resultant_force.mag;

                    if isnan(res_force)
                        res_force = 0;
                    end

                    sum_momentums_forces = sum_momentums_forces + res_force;

                    % add the punctual forces to the end of the vertical forces vector
                    v_dist_forces(length(v_dist_forces) + 1) = resultant_force;

                    m_forces(length(m_forces) + 1) = Force(resultant_force.pos, res_force);
                end
            end
        
            % resultant vertical forces
            for i = 2:length(vertical_forces)
                force = vertical_forces(i);

                if force.pos <= beam_width
                    v_forces(length(v_forces) + 1) = force;

                    sum_vertical_forces = sum_vertical_forces + force.mag;
                    sum_momentums_forces = sum_momentums_forces + (0 - force.pos) * force.mag;

                    m_forces(length(m_forces) + 1) = Force(force.pos, (0 - force.pos) * force.mag);
                end
            end

            % resultant horizontal forces
            for i = 2:length(momentums)
                force = momentums(i);

                if force.pos <= beam_width
                    sum_momentums_forces = sum_momentums_forces + force.mag;
                end
            end
        
            B = [
                -sum_vertical_forces;
                -sum_horizontal_forces;
                -sum_torque_forces;
                -sum_momentums_forces
            ];
        
            num_incognitas = 0;
        
            for i = 2:length(supports)
                _support = supports(i);
        
                if _support.type == SupportType().Roller
                    num_incognitas = num_incognitas + 1;
                elseif _support.type == SupportType().Pinned
                    num_incognitas = num_incognitas + 3;
                elseif _support.type == SupportType().Fixed
                    num_incognitas = num_incognitas + 4;
                end
            end
        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % line 1: vertical forces equilibrium       %
            % line 2: horizontal forces equilibrium     %
            % line 3: torques forces equilibrium        %
            % line 4: momemtum forces equilibrium       %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % column X: represents the X incognita      %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            X = zeros(num_incognitas);
            A = zeros(4, num_incognitas);

            for loopIdx = 1:2
                num_incognitas = 0;

                for i = 2:length(supports)
                    _support = supports(i);
            
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Roller support force decomposition
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if _support.type == SupportType().Roller
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Vertical Force decomposition (and consequently the generation of momentum due to the vertical force)
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the vertical (and its momentum) incognita column
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = 0 - _support.pos;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (0 - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Pinned support force decomposition
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    elseif _support.type == SupportType().Pinned
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Torque Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the torque incognita column
                            A(3, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            t_forces(length(t_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Horizontal Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the horizontal incognita column
                            A(2, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            h_forces(length(h_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                        end
                        
                        num_incognitas = num_incognitas + 1;
            
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Vertical Force decomposition (and consequently the generation of momentum due to the vertical force)
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the vertical (and its momentum) incognita column
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = 0 - _support.pos;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (0 - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Fixed support force decomposition
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    elseif _support.type == SupportType().Fixed
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Torque Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the torque incognita column
                            A(3, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            t_forces(length(t_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;

                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Horizontal Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the horizontal incognita column
                            A(2, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            h_forces(length(h_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Vertical Force decomposition (and consequently the generation of momentum due to the vertical force)
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the vertical (and its momentum) incognita column
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = 0 - _support.pos;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (0 - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Momentum Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            A(4, num_incognitas + 1) = 1;
                        else
                            m_forces(length(m_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));

                            support_momentuns(length(support_momentuns) + 1) = Force(_support.pos, X(num_incognitas + 1));
                        end
                        
                        num_incognitas = num_incognitas + 1;
                    end
                end

                if loopIdx == 1
                    X = A \ B;
                end
            end
        end
    
        function [x_pos, h_inner_forces, t_inner_forces, v_inner_forces, m_inner_forces, slope, deflection, elongation, torsion_angle] = res_mat_1d_inner_solver(
                beam_width,
                vertical_forces,
                horizontal_forces,
                torques,
                momentums,
                vertical_dist_forces,
                supports,
                num_steps,
                young_module,
                momentum_inertia,
                shear_module,
                polar_momentum_inertia
            )

            x_pos = 0;
            slope = 0;
            deflection = 0;
            elongation = 0;
            torsion_angle = 0;
            v_inner_forces = 0;
            m_inner_forces = 0;
            h_inner_forces = 0;
            t_inner_forces = 0;

            if num_steps > 0
                x_pos = [0 : beam_width / num_steps : beam_width];

                slope = zeros(1, length(x_pos));
                deflection = zeros(1, length(x_pos));
                v_inner_forces = zeros(1, length(x_pos));
                m_inner_forces = zeros(1, length(x_pos));
                h_inner_forces = zeros(1, length(x_pos));
                t_inner_forces = zeros(1, length(x_pos));

                elongation = zeros(1, length(x_pos));
                torsion_angle = zeros(1, length(x_pos));

                pos_vx = 1;
                pos_dvx = 1;

                % add the vertical forces
                for i = 2:length(vertical_forces)
                    v_force = vertical_forces(i);

                    Vx(pos_vx).pos = v_force.pos;
                    Vx(pos_vx).mag = [v_force.mag];

                    pos_vx = pos_vx + 1;
                end

                % forças cortantes
                if pos_vx > 1
                    for i = 1:length(x_pos)
                        x = x_pos(i);
                        res_force = 0;
                        
                        for j = 1:pos_vx-1
                            res_force = res_force + polyval(Vx(j).mag, x - Vx(j).pos) * lib_resmat.delta(x - Vx(j).pos);
                        end

                        for k = 2:length(vertical_dist_forces)
                            dist_v_force = vertical_dist_forces(k);

                            if x >= dist_v_force.pos_beg
                                resultant_force = lib_resmat.calcresforce(dist_v_force, dist_v_force.pos_beg, x);

                                if !isnan(resultant_force.pos) && !isnan(resultant_force.mag)
                                    res_force = res_force + polyval([resultant_force.mag], x - resultant_force.pos) * lib_resmat.delta(x - resultant_force.pos);
                                end
                            end
                        end

                        v_inner_forces(1, i) = res_force;
                    end
                end

                % integrate all terms to get the momentum
                for i = 1:pos_vx-1
                    Vx(i).mag = polyint(Vx(i).mag);
                end

                % add the momentum term
                for i = 1:length(momentums)
                    momentum_force = momentums(i);

                    Vx(pos_vx).pos = momentum_force.pos;
                    Vx(pos_vx).mag = [momentum_force.mag];

                    pos_vx = pos_vx + 1;
                end

                % internal momentum calculation
                if pos_vx > 1
                    for i = 1:length(x_pos)
                        x = x_pos(i);
                        momentum_force = 0;
                        
                        for j = 1:pos_vx-1
                            momentum_force = momentum_force + polyval(Vx(j).mag, x - Vx(j).pos) * lib_resmat.delta(x - Vx(j).pos);
                        end

                        for k = 2:length(vertical_dist_forces)
                            dist_v_force = vertical_dist_forces(k);

                            if x >= dist_v_force.pos_beg
                                resultant_force = lib_resmat.calcresforce(dist_v_force, dist_v_force.pos_beg, x);
                                
                                if !isnan(resultant_force.pos) && !isnan(resultant_force.mag)
                                    momentum_force = momentum_force + polyval([resultant_force.mag 0], x - resultant_force.pos) * lib_resmat.delta(x - resultant_force.pos);
                                end
                            end
                        end

                        m_inner_forces(1, i) = momentum_force;
                    end
                end


                % integrate all terms to get the slope
                for i = 1:pos_vx-1
                    Vx(i).mag = polyint(Vx(i).mag);
                end

                % find the C_3 constant (for the slope equation)
                c_3 = 0;
                support_found = 0;

                % find the C_3 constant (for the elongation equation)
                for i = 2:length(supports)
                    _support = supports(i);

                    % phi(x) = 0
                    if _support.type == SupportType().Fixed
                        support_found = 1;

                        for j = 1:pos_vx-1
                            c_3 = c_3 -(polyval(Vx(j).mag, _support.pos - Vx(j).pos) * lib_resmat.delta(_support.pos - Vx(j).pos));
                        end

                        for k = 2:length(vertical_dist_forces)
                            dist_v_force = vertical_dist_forces(k);

                            if _support.pos >= dist_v_force.pos_beg
                                resultant_force = lib_resmat.calcresforce(dist_v_force, dist_v_force.pos_beg, _support.pos);

                                if !isnan(resultant_force.pos) && !isnan(resultant_force.mag)
                                    c_3 = c_3 - (polyval([resultant_force.mag 0 0], _support.pos - resultant_force.pos) * lib_resmat.delta(_support.pos - resultant_force.pos));
                                end
                            end
                        end

                        break;
                    end
                end

                if support_found == 0
                    % there is no contourn condition by the supports. we choose a reference point to be null
                    % find the C_3 constant (for the elongation equation)
                    for i = 2:length(supports)
                        _support = supports(i);

                        for j = 1:pos_vx-1
                            c_3 = c_3 -(polyval(Vx(j).mag, _support.pos - Vx(j).pos) * lib_resmat.delta(_support.pos - Vx(j).pos));
                        end

                        for k = 2:length(vertical_dist_forces)
                            dist_v_force = vertical_dist_forces(k);

                            if _support.pos >= dist_v_force.pos_beg
                                resultant_force = lib_resmat.calcresforce(dist_v_force, dist_v_force.pos_beg, _support.pos);

                                if !isnan(resultant_force.pos) && !isnan(resultant_force.mag)
                                    c_3 = c_3 - (polyval([resultant_force.mag 0 0], _support.pos - resultant_force.pos) * lib_resmat.delta(_support.pos - resultant_force.pos));
                                end
                            end
                        end

                        break;
                    end
                end

                Vx(pos_vx).pos = 0;
                Vx(pos_vx).mag = [c_3];

                pos_vx = pos_vx + 1;

                % slope calculation
                if pos_vx > 1
                    for i = 1:length(x_pos)
                        x = x_pos(i);
                        s = 0;
                        
                        for j = 1:pos_vx-1
                            s = s + polyval(Vx(j).mag, x - Vx(j).pos) * lib_resmat.delta(x - Vx(j).pos);
                        end

                        for k = 2:length(vertical_dist_forces)
                            dist_v_force = vertical_dist_forces(k);

                            if x >= dist_v_force.pos_beg
                                resultant_force = lib_resmat.calcresforce(dist_v_force, dist_v_force.pos_beg, x);
                                
                                if !isnan(resultant_force.pos) && !isnan(resultant_force.mag)
                                    s = s + polyval([resultant_force.mag 0 0], x - resultant_force.pos) * lib_resmat.delta(x - resultant_force.pos);
                                end
                            end
                        end

                        slope(1, i) = s / (young_module * momentum_inertia);
                    end
                end

                % integrate all terms to get the deflection
                for i = 1:pos_vx-1
                    Vx(i).mag = polyint(Vx(i).mag);
                end

                % find the C_4 constant (for the slope equation)
                c_4 = 0;

                support_found = 0;

                % find the C_4 constant (for the elongation equation)
                for i = 2:length(supports)
                    _support = supports(i);

                    c_4 = 0;

                    support_found = 1;

                    for j = 1:pos_vx-1
                        c_4 = c_4 -(polyval(Vx(j).mag, _support.pos - Vx(j).pos) * lib_resmat.delta(_support.pos - Vx(j).pos));
                    end

                    for k = 2:length(vertical_dist_forces)
                        dist_v_force = vertical_dist_forces(k);

                        if _support.pos >= dist_v_force.pos_beg
                            resultant_force = lib_resmat.calcresforce(dist_v_force, dist_v_force.pos_beg, _support.pos);

                            if !isnan(resultant_force.pos) && !isnan(resultant_force.mag)
                                c_4 = c_4 - (polyval([resultant_force.mag 0 0 0], _support.pos - resultant_force.pos) * lib_resmat.delta(_support.pos - resultant_force.pos));
                            end
                        end
                    end

                    break;
                end

                Vx(pos_vx).pos = 0;
                Vx(pos_vx).mag = [c_4];

                pos_vx = pos_vx + 1;

                % deflection calculation
                if pos_vx > 1
                    for i = 1:length(x_pos)
                        x = x_pos(i);
                        d = 0;
                        
                        for j = 1:pos_vx-1
                            d = d + polyval(Vx(j).mag, x - Vx(j).pos) * lib_resmat.delta(x - Vx(j).pos);
                        end

                        for k = 2:length(vertical_dist_forces)
                            dist_v_force = vertical_dist_forces(k);

                            if x >= dist_v_force.pos_beg
                                resultant_force = lib_resmat.calcresforce(dist_v_force, dist_v_force.pos_beg, x);
                                
                                if !isnan(resultant_force.pos) && !isnan(resultant_force.mag)
                                    d = d + polyval([resultant_force.mag 0 0 0], x - resultant_force.pos) * lib_resmat.delta(x - resultant_force.pos);
                                end
                            end
                        end

                        deflection(1, i) = d / (young_module * momentum_inertia);
                    end
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Horizontal and Inner Forces calculation %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                pos_hx = 1;

                % add the horizontal forces
                for i = 2:length(horizontal_forces)
                    h_force = horizontal_forces(i);

                    Hx(pos_hx).pos = h_force.pos;
                    Hx(pos_hx).mag = [h_force.mag];

                    pos_hx = pos_hx + 1;
                end

                % horizontal inner force calculation
                if pos_hx > 1
                    for i = 1:length(x_pos)
                        x = x_pos(i);
                        res_force = 0;
                        
                        for j = 1:pos_hx-1
                            res_force = res_force + polyval(Hx(j).mag, x - Hx(j).pos) * lib_resmat.delta(x - Hx(j).pos);
                        end

                        h_inner_forces(1, i) = -res_force;
                    end
                end

                % integrate all terms to get the elongation
                for i = 1:pos_hx-1
                    Hx(i).mag = polyint(Hx(i).mag);
                end

                support_found = 0;

                % find the C_5 constant (for the elongation equation)
                for i = 2:length(supports)
                    _support = supports(i);

                    % delta_L(x) = 0
                    if _support.type == SupportType().Fixed || _support.type == SupportType().Pinned
                        support_found = 1;

                        c_5 = 0;

                        for j = 1:pos_hx-1
                            c_5 = c_5 -(polyval(Hx(j).mag, _support.pos - Hx(j).pos) * lib_resmat.delta(_support.pos - Hx(j).pos));
                        end

                        break;
                    end
                end

                if support_found == 0
                    % there is no contourn condition by the supports. we choose a reference point to be null

                    c_5 = 0;

                    for j = 1:pos_hx-1
                        c_5 = c_5 -(polyval(Hx(j).mag, 0 - Hx(j).pos) * lib_resmat.delta(0 - Hx(j).pos));
                    end
                end

                Hx(pos_hx).pos = 0;
                Hx(pos_hx).mag = [c_5];

                pos_hx = pos_hx + 1;

                % elongation calculation
                if pos_hx > 1
                    for i = 1:length(x_pos)
                        e = 0;

                        x = x_pos(i);
                        
                        for j = 1:pos_hx-1
                            e = e + polyval(Hx(j).mag, x - Hx(j).pos) * lib_resmat.delta(x - Hx(j).pos);
                        end

                        elongation(1, i) = -e / (young_module * momentum_inertia);
                    end
                end


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Internal Torque and Elongation calculation %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                pos_tx = 1;

                % add the torque forces
                for i = 2:length(torques)
                    t_force = torques(i);

                    Tx(pos_tx).pos = t_force.pos;
                    Tx(pos_tx).mag = [t_force.mag];

                    pos_tx = pos_tx + 1;
                end

                % internal torque calculation
                if pos_tx > 1
                    for i = 1:length(x_pos)
                        x = x_pos(i);
                        res_force = 0;
                        
                        for j = 1:pos_tx-1
                            res_force = res_force + polyval(Tx(j).mag, x - Tx(j).pos) * lib_resmat.delta(x - Tx(j).pos);
                        end

                        t_inner_forces(1, i) = -res_force;
                    end
                end

                % integrate all terms to get the torsion angle
                for i = 1:pos_tx-1
                    Tx(i).mag = polyint(Tx(i).mag);
                end

                c_6 = 0;
                support_found = 0;

                % find the C_6 constant (for the elongation equation)
                for i = 2:length(supports)
                    _support = supports(i);

                    % phi(x) = 0
                    if _support.type == SupportType().Fixed || _support.type == SupportType().Pinned
                        support_found = 1;

                        for j = 1:pos_tx-1
                            c_6 = c_6 -(polyval(Tx(j).mag, _support.pos - Tx(j).pos) * lib_resmat.delta(_support.pos - Tx(j).pos));
                        end

                        break;
                    end
                end

                if support_found == 0
                    % there is no contourn condition by the supports. we choose a reference point to be null
                    
                    for j = 1:pos_tx-1
                        c_6 = c_6 -(polyval(Tx(j).mag, 0 - Tx(j).pos) * lib_resmat.delta(0 - Tx(j).pos));
                    end
                end

                Tx(pos_tx).pos = 0;
                Tx(pos_tx).mag = [c_6];

                pos_tx = pos_tx + 1;

                % torsion angle calculation
                if pos_tx > 1
                    for i = 1:length(x_pos)
                        e = 0;

                        x = x_pos(i);
                        
                        for j = 1:pos_tx-1
                            e = e + polyval(Tx(j).mag, x - Tx(j).pos) * lib_resmat.delta(x - Tx(j).pos);
                        end

                        torsion_angle(1, i) = -e / (shear_module * polar_momentum_inertia);
                    end
                end
            end
        end

        function [t_normal, t_shear, principal_1, principal_2, principal_3, shear_max_plane, shear_max_abs, tresca_coefs, von_mises_coefs, eps_x, eps_y, eps_z, gama_x, gama_y, gama_z] = res_mat_1d_tension_solver(
                h_inner_forces,
                t_inner_forces,
                v_inner_forces,
                m_inner_forces,
                young_module,
                momentum_inertia,
                shear_module,
                polar_momentum_inertia,
                section_area,
                yield_strength,
                point_ref,
                radius1,
                radius2,
                poisson
            )

            size_array = length(h_inner_forces);

            max_radius = max(radius1, radius2);

            t_normal = zeros(1, size_array);
            t_shear = zeros(1, size_array);
            principal_1 = zeros(1, size_array);
            principal_2 = zeros(1, size_array);
            principal_3 = zeros(1, size_array);
            shear_max_plane = zeros(1, size_array);
            shear_max_abs = zeros(1, size_array);
            tresca_coefs = zeros(1, size_array);
            von_mises_coefs = zeros(1, size_array);

            eps_x = zeros(1, size_array);
            eps_y = zeros(1, size_array);
            eps_z = zeros(1, size_array);

            gama_x = zeros(1, size_array);
            gama_y = zeros(1, size_array);
            gama_z = zeros(1, size_array);

            if point_ref == PointType().A
                point_ref_y = max_radius;
            end

            if point_ref == PointType().B
                point_ref_y = 0;
            end

            if point_ref == PointType().C
                point_ref_y = -max_radius;
            end

            if point_ref == PointType().D
                point_ref_y = 0;
            end

            for i = 1:size_array
                shear = 0;

                normal = 0;

                % tensao normal devido as forcas normais
                normal = normal + h_inner_forces(i) / section_area;

                % tensao normal devido aos momentos
                normal = normal - m_inner_forces(i) * point_ref_y / momentum_inertia;

                % tensao de cisalhamento devido as forcas de torque
                torque = t_inner_forces(i);

                if point_ref == PointType().B
                    torque = -1 * torque;

                    % tensao de cisalhamento devido as forcas de corte (somente no ponto de y = 0)
                    shear = shear - (4 / 3) * (v_inner_forces(i) / section_area) * ((radius1**2 + radius1 * radius2 + radius2**2) / (radius1**2 + radius2**2));
                end
    
                if point_ref == PointType().C
                    torque = -1 * torque;
                end

                if point_ref == PointType().D
                    % tensao de cisalhamento devido as forcas de corte (somente no ponto de y = 0)
                    shear = shear - (4 / 3) * (v_inner_forces(i) / section_area) * ((radius1**2 + radius1 * radius2 + radius2**2) / (radius1**2 + radius2**2));
                end

                shear = shear + torque * max_radius / polar_momentum_inertia;

                % computo final das tensoes normal e cizalhante

                t_shear(1, i) = shear;

                t_normal(i) = normal;

                % computo das tensoes principais
                p_1 = normal / 2 + sqrt((normal / 2) ** 2 + shear ** 2);
                p_2 = normal / 2 - sqrt((normal / 2) ** 2 + shear ** 2);
                p_3 = 0;

                p_array = sort([p_1 p_2 p_3], "descend");

                principal_1(i) = p_array(1);
                principal_2(i) = p_array(2);
                principal_3(i) = p_array(3);

                % computo das tensoes de cisalhamento maximas absolutas
                shear_max_plane(i) = sqrt((normal / 2) ** 2 + shear ** 2);

                shear_max_abs(i) = (p_array(1) - p_array(3)) / 2;

                % computo dos coeficientes de seguranca por tresca
                tresca_coefs(i) = yield_strength / (p_array(1) - p_array(3));

                % computo dos coeficientes de seguranca por von mises
                von_mises_coefs(i) = yield_strength / sqrt(((p_array(1) - p_array(2)) ** 2 + (p_array(2) - p_array(3)) ** 2 + (p_array(3) - p_array(1)) ** 2) / 2);


                eps_x(i) = normal / young_module;
                eps_y(i) = (0 - poisson * normal) / young_module;
                eps_z(i) = (0 - poisson * normal) / young_module;

                gama_x(i) = shear / shear_module;
                gama_y(i) = 0;
                gama_z(i) = 0;

            end
        end
    end
end
