classdef    lib_resmat 
    methods ( Static = true )
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
                    result_force_int = quadcc(
                        @(x) (dist_force.dist_func(x) + 0 * x),
                        dist_force.pos_beg,
                        min(dist_force.pos_end, beam_width)
                    );
            
                    % calculates the centroid of the force (integrates from `beg` to `end`)
                    centroid = quadcc(
                        @(x) (dist_force.dist_func_times_x(x) + 0 * x),
                        dist_force.pos_beg,
                        min(dist_force.pos_end, beam_width)
                    ) / result_force_int;

                    resultant_force = Force(centroid, result_force_int);
                    
                    sum_vertical_forces = sum_vertical_forces + resultant_force.mag;

                    res_force = (0 - resultant_force.pos) * resultant_force.mag;

                    if isnan(res_force)
                        res_force = 0
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
                            t_forces(length(t_forces) + 1) = Force(0, X(num_incognitas + 1));
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
                            h_forces(length(h_forces) + 1) = Force(0, X(num_incognitas + 1));
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
                            t_forces(length(t_forces) + 1) = Force(0, X(num_incognitas + 1));
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
                            h_forces(length(h_forces) + 1) = Force(0, X(num_incognitas + 1));
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
    
        function [x_pos, v_inner_forces, m_inner_forces] = res_mat_1d_inner_solver(
                beam_width,
                vertical_forces,
                horizontal_forces,
                torques,
                momentums,
                vertical_dist_forces,
                num_steps
            )

            x_pos = 0;
            v_inner_forces = 0;
            m_inner_forces = 0;

            if num_steps > 0
                x_pos = [0 : beam_width / num_steps : beam_width];

                v_inner_forces = zeros(1, length(x_pos));
                m_inner_forces = zeros(1, length(x_pos));

                for i = 1:length(x_pos)
                    x = x_pos(i);

                    supports(1) = Support(0, SupportType().Dummy);
                    supports(2) = Support(x, SupportType().Fixed);

                    [v_forces, h_forces, t_forces, m_forces, v_dist_forces, X] = lib_resmat.res_mat_1d_solver(
                        x,
                        vertical_forces,
                        horizontal_forces,
                        torques,
                        vertical_dist_forces,
                        supports,
                        momentums
                    );

                    v_inner_forces(1, i) = -X(3);
                    m_inner_forces(1, i) = -X(4);
                end
            end
        end
    end
end
